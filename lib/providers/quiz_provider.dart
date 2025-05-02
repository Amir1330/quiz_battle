import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/firebase_service.dart';

class QuizProvider with ChangeNotifier {
  static const String _quizzesKey = 'quizzes';
  late SharedPreferences _prefs;
  final FirebaseService _firebaseService = FirebaseService.instance;
  List<Quiz> _quizzes = [];
  final List<Quiz> _defaultQuizzes = [
    Quiz(
      title: 'Basic Math',
      description: 'Test your basic math skills',
      language: 'en',
      isDefault: true,
      questions: [
        Question(
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctOptionIndex: 1,
        ),
        Question(
          question: 'What is 10 - 5?',
          options: ['3', '4', '5', '6'],
          correctOptionIndex: 2,
        ),
      ],
    ),
  ];

  List<Quiz> get quizzes => _quizzes;
  List<Quiz> get defaultQuizzes => _defaultQuizzes;

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizComplete = false;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;
  int get score => _score;
  bool get isQuizComplete => _isQuizComplete;

  QuizProvider() {
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await _initializePrefs();
    await _initializeFirebase();
  }

  Future<void> _initializePrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
    }
  }
  
  Future<void> _initializeFirebase() async {
    final result = await _firebaseService.initialize();
    debugPrint('Firebase initialization result: $result (supported: ${FirebaseService.isSupported})');
  }
  
  bool get _isFirebaseAvailable => FirebaseService.isInitialized && FirebaseService.isSupported;

  Future<void> loadQuizzes() async {
    try {
      await _initializePrefs();
      
      // Skip Firebase if not supported or not initialized
      if (!_isFirebaseAvailable) {
        debugPrint('Firebase not available, loading from local storage only');
        await _loadFromLocalStorage();
        return;
      }

      debugPrint('Loading quizzes from Firebase...');
      final snapshot = await _firebaseService.getData('quizzes');

      if (snapshot != null && snapshot.exists && snapshot.value != null) {
        try {
          final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          _quizzes = data.entries
              .map((entry) {
                try {
                  return Quiz.fromJson(Map<String, dynamic>.from(entry.value));
                } catch (e) {
                  debugPrint('Error parsing quiz: $e');
                  return null;
                }
              })
              .whereType<Quiz>()
              .toList();

          if (_quizzes.isEmpty) {
            debugPrint('No valid quizzes found in Firebase, loading default quizzes');
            _quizzes = List.from(_defaultQuizzes);
            
            // Save default quizzes to Firebase
            await _saveDefaultQuizzesToFirebase();
          } else {
            debugPrint('Loaded ${_quizzes.length} quizzes from Firebase');
          }
        } catch (e) {
          debugPrint('Error parsing Firebase data: $e');
          _quizzes = List.from(_defaultQuizzes);
        }
      } else {
        debugPrint('No quizzes found in Firebase database, loading default quizzes');
        _quizzes = List.from(_defaultQuizzes);
        
        // Save default quizzes to Firebase
        await _saveDefaultQuizzesToFirebase();
      }
      
      // Always save to local storage as backup
      await _saveQuizzes();
    } catch (e, stackTrace) {
      debugPrint('Error loading quizzes from Firebase: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Falling back to local storage...');
      await _loadFromLocalStorage();
    } finally {
      notifyListeners();
    }
  }
  
  Future<void> _saveDefaultQuizzesToFirebase() async {
    if (!_isFirebaseAvailable) return;
    
    try {
      for (final quiz in _defaultQuizzes) {
        final result = await _firebaseService.saveData('quizzes/${quiz.id}', quiz.toJson());
        debugPrint('Saved default quiz to Firebase (${quiz.title}): $result');
      }
    } catch (e) {
      debugPrint('Error saving default quizzes to Firebase: $e');
    }
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      await _initializePrefs();
      final quizzesJson = _prefs.getStringList(_quizzesKey) ?? [];
      if (quizzesJson.isNotEmpty) {
        try {
          _quizzes = quizzesJson
              .map((json) => Quiz.fromJson(jsonDecode(json)))
              .toList();
          debugPrint('Loaded ${_quizzes.length} quizzes from local storage');
        } catch (e) {
          debugPrint('Error parsing quizzes from local storage: $e');
          _quizzes = List.from(_defaultQuizzes);
        }
      } else {
        debugPrint('No quizzes in local storage, loading default quizzes');
        _quizzes = List.from(_defaultQuizzes);
      }
    } catch (e) {
      debugPrint('Error loading from local storage: $e');
      _quizzes = List.from(_defaultQuizzes);
    }
  }

  Future<void> _saveQuizzes() async {
    try {
      await _initializePrefs();
      final quizzesJson =
          _quizzes.map((quiz) => jsonEncode(quiz.toJson())).toList();
      await _prefs.setStringList(_quizzesKey, quizzesJson);
      debugPrint('Quizzes saved to local storage');
    } catch (e) {
      debugPrint('Error saving quizzes to local storage: $e');
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    try {
      debugPrint('Adding quiz: ${quiz.title} with ID: ${quiz.id}');
      
      // Add to local list first
      _quizzes.add(quiz);
      
      // Save to Firebase if available
      if (_isFirebaseAvailable) {
        debugPrint('Saving quiz to Firebase...');
        final result = await _firebaseService.saveData('quizzes/${quiz.id}', quiz.toJson());
        debugPrint('Quiz saved to Firebase: $result');
      } else {
        debugPrint('Firebase not available, saving only to local storage');
      }
      
      // Always save to local storage
      await _saveQuizzes();
      notifyListeners();
      debugPrint('Quiz added successfully');
    } catch (e) {
      debugPrint('Error adding quiz: $e');
      // If Firebase fails, try to recover
      await _saveQuizzes();
      notifyListeners();
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      debugPrint('Updating quiz: ${quiz.title} with ID: ${quiz.id}');
      
      // Update in local list
      final index = _quizzes.indexWhere((q) => q.id == quiz.id);
      if (index != -1) {
        _quizzes[index] = quiz;
        
        // Update in Firebase if available
        if (_isFirebaseAvailable) {
          debugPrint('Updating quiz in Firebase...');
          final result = await _firebaseService.updateData('quizzes/${quiz.id}', quiz.toJson());
          debugPrint('Quiz updated in Firebase: $result');
        } else {
          debugPrint('Firebase not available, updating only in local storage');
        }
        
        // Always save to local storage
        await _saveQuizzes();
        notifyListeners();
        debugPrint('Quiz updated successfully');
      }
    } catch (e) {
      debugPrint('Error updating quiz: $e');
      // If Firebase fails, try to recover
      await _saveQuizzes();
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      debugPrint('Deleting quiz with ID: $quizId');
      
      // Remove from local list
      _quizzes.removeWhere((quiz) => quiz.id == quizId);
      
      // Remove from Firebase if available
      if (_isFirebaseAvailable) {
        debugPrint('Deleting quiz from Firebase...');
        final result = await _firebaseService.deleteData('quizzes/$quizId');
        debugPrint('Quiz deleted from Firebase: $result');
      } else {
        debugPrint('Firebase not available, deleting only from local storage');
      }
      
      // Always save to local storage
      await _saveQuizzes();
      notifyListeners();
      debugPrint('Quiz deleted successfully');
    } catch (e) {
      debugPrint('Error deleting quiz: $e');
      // If Firebase fails, try to recover
      await _saveQuizzes();
      notifyListeners();
    }
  }

  List<Quiz> getQuizzesByLanguage(String language) {
    return _quizzes.where((quiz) => quiz.language == language).toList();
  }

  void loadQuestions(List<Question> questions) {
    _questions = questions;
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (_currentQuestionIndex >= _questions.length) return;

    if (_questions[_currentQuestionIndex].correctOptionIndex == selectedIndex) {
      _score++;
    }

    _currentQuestionIndex++;
    if (_currentQuestionIndex >= _questions.length) {
      _isQuizComplete = true;
    }

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    notifyListeners();
  }
}
