import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';

class QuizProvider with ChangeNotifier {
  static const String _quizzesKey = 'quizzes';
  late SharedPreferences _prefs;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
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
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> loadQuizzes() async {
    try {
      debugPrint('Loading quizzes from Firebase...');
      await _initializePrefs();

      final DataSnapshot snapshot = await _database.child('quizzes').get();
      debugPrint('Snapshot value: ${snapshot.value}');

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            snapshot.value as Map<dynamic, dynamic>;
        _quizzes =
            data.entries
                .map((entry) {
                  try {
                    return Quiz.fromJson(
                      Map<String, dynamic>.from(entry.value),
                    );
                  } catch (e) {
                    debugPrint('Error parsing quiz: $e');
                    return null;
                  }
                })
                .whereType<Quiz>()
                .toList();

        if (_quizzes.isEmpty) {
          debugPrint('No valid quizzes found, loading default quizzes');
          _quizzes = List.from(_defaultQuizzes);
        }

        await _saveQuizzes();

        debugPrint('Loaded ${_quizzes.length} quizzes');
      } else {
        debugPrint(
          'No quizzes found in database, trying to load from local storage',
        );
        final quizzesJson = _prefs.getStringList(_quizzesKey) ?? [];
        if (quizzesJson.isNotEmpty) {
          _quizzes =
              quizzesJson
                  .map((json) => Quiz.fromJson(jsonDecode(json)))
                  .toList();
          debugPrint('Loaded ${_quizzes.length} quizzes from local storage');
        } else {
          debugPrint('No quizzes in local storage, loading default quizzes');
          _quizzes = List.from(_defaultQuizzes);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading quizzes from Firebase: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Trying to load from local storage...');

      try {
        final quizzesJson = _prefs.getStringList(_quizzesKey) ?? [];
        if (quizzesJson.isNotEmpty) {
          _quizzes =
              quizzesJson
                  .map((json) => Quiz.fromJson(jsonDecode(json)))
                  .toList();
          debugPrint('Loaded ${_quizzes.length} quizzes from local storage');
        } else {
          debugPrint('Loading default quizzes as fallback');
          _quizzes = List.from(_defaultQuizzes);
        }
      } catch (e) {
        debugPrint('Error loading from local storage: $e');
        _quizzes = List.from(_defaultQuizzes);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveQuizzes() async {
    try {
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
      await _database.child('quizzes').child(quiz.id).set(quiz.toJson());
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error adding quiz: $e');
      rethrow;
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _database.child('quizzes').child(quiz.id).update(quiz.toJson());
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error updating quiz: $e');
      rethrow;
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _database.child('quizzes').child(quizId).remove();
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error deleting quiz: $e');
      rethrow;
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
