import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:uuid/uuid.dart';

class QuizProvider with ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://quizzz-79fa5-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();
  List<Quiz> _quizzes = [];
  List<Quiz> _myQuizzes = [];
  bool _isLoading = false;
  bool _myQuizzesLoading = false;
  bool _allQuizzesLoading = false;
  String? _error;

  List<Quiz> get quizzes => _quizzes;
  List<Quiz> get myQuizzes => _myQuizzes;
  bool get isLoading => _isLoading || _myQuizzesLoading || _allQuizzesLoading;
  bool get isLoadingMyQuizzes => _myQuizzesLoading;
  bool get isLoadingAllQuizzes => _allQuizzesLoading;
  String? get error => _error;

  void _clearError() {
    _error = null;
  }

  // Helper method to safely convert Firebase data to Quiz objects
  List<Quiz> _parseQuizData(dynamic data) {
    List<Quiz> result = [];
    try {
      if (data is Map) {
        // Convert to a Map<String, dynamic> safely
        data.forEach((key, value) {
          if (value is Map) {
            try {
              // Convert each entry to a Map<String, dynamic>
              final quizData = Map<String, dynamic>.fromEntries(
                value.entries.map((e) => MapEntry(e.key.toString(), e.value)),
              );
              
              // Add debugging print
              debugPrint('Parsing quiz with id: ${quizData['id']}');
              
              result.add(Quiz.fromJson(quizData));
            } catch (e) {
              debugPrint('Error parsing quiz data: $e');
            }
          }
        });
      }
      return result;
    } catch (e) {
      debugPrint('Error in _parseQuizData: $e');
      return [];
    }
  }

  Future<void> loadQuizzes() async {
    if (_allQuizzesLoading) {
      debugPrint('Skipping loadQuizzes - already in progress');
      return; // Prevent multiple simultaneous calls
    }
    
    try {
      _allQuizzesLoading = true;
      _clearError();
      notifyListeners();

      debugPrint('Starting loadQuizzes from Firebase');
      final snapshot = await _database.child('quizzes').get();
      
      debugPrint('Loaded all quizzes snapshot, exists: ${snapshot.exists}, hasChildren: ${snapshot.children.isNotEmpty}');
      
      // Only reset the list if we have valid data to replace it
      if (snapshot.exists && snapshot.value != null) {
        final parsedQuizzes = _parseQuizData(snapshot.value);
        debugPrint('Parsed ${parsedQuizzes.length} quizzes from Firebase');
        
        // Sort by newest first
        parsedQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        // Update the list only if we have parsed quizzes successfully
        _quizzes = parsedQuizzes;
      } else {
        debugPrint('No quizzes found in Firebase');
      }
    } catch (e) {
      _error = "Failed to load quizzes: ${e.toString()}";
      debugPrint(_error);
    } finally {
      _allQuizzesLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyQuizzes(String userId) async {
    if (_myQuizzesLoading) {
      debugPrint('Skipping loadMyQuizzes - already in progress');
      return; // Prevent multiple simultaneous calls
    }
    
    try {
      _myQuizzesLoading = true;
      _clearError();
      notifyListeners();

      debugPrint('Loading my quizzes for user: $userId');
      
      // Get all quizzes and filter client-side to work around missing .indexOn rule
      final snapshot = await _database.child('quizzes').get();
          
      if (snapshot.exists && snapshot.value != null) {
        // Parse all quizzes
        final allQuizzes = _parseQuizData(snapshot.value);
        debugPrint('Found ${allQuizzes.length} total quizzes');
        
        // Filter quizzes by creator ID client-side
        final filteredQuizzes = allQuizzes.where((quiz) => quiz.creatorId == userId).toList();
        debugPrint('Filtered to ${filteredQuizzes.length} quizzes for user $userId');
        
        // Sort by newest first
        filteredQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        // Update the list
        _myQuizzes = filteredQuizzes;
      } else {
        debugPrint('No quizzes found in database');
      }
    } catch (e) {
      _error = "Failed to load your quizzes: ${e.toString()}";
      debugPrint(_error);
    } finally {
      _myQuizzesLoading = false;
      notifyListeners();
    }
  }

  Future<void> createQuiz({
    required String title,
    required String description,
    required String creatorId,
    required String creatorEmail,
    required List<Question> questions,
    int timeLimit = 0,
  }) async {
    if (_isLoading) {
      debugPrint('Skipping createQuiz - already in progress');
      return;
    }
    
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      // Double-check that we have a valid user before proceeding
      if (creatorId.isEmpty) {
        throw 'Invalid user ID. Please log in again.';
      }

      // Create quiz object
      final quiz = Quiz(
        id: const Uuid().v4(),
        title: title,
        description: description,
        creatorId: creatorId,
        creatorEmail: creatorEmail,
        questions: questions,
        createdAt: DateTime.now(),
        timeLimit: timeLimit,
      );

      debugPrint('Creating quiz with id: ${quiz.id} for user: $creatorId');
      
      // Save to Firebase
      await _database.child('quizzes/${quiz.id}').set(quiz.toJson());
      debugPrint('Quiz created successfully in Firebase');
      
      // Add to local lists if not already there
      if (!_myQuizzes.any((q) => q.id == quiz.id)) {
        _myQuizzes.insert(0, quiz);
      }
      
      if (!_quizzes.any((q) => q.id == quiz.id)) {
        _quizzes.insert(0, quiz);
      }
      
      // Force reload from server to ensure we have the latest data
      await Future.delayed(const Duration(milliseconds: 500));
      await loadMyQuizzes(creatorId);
      debugPrint('Reloaded quizzes after creation');
    } catch (e) {
      _error = "Failed to create quiz: ${e.toString()}";
      debugPrint(_error);
      throw e; // Rethrow to let the UI handle it
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    if (_isLoading) return; // Prevent multiple simultaneous calls
    
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      await _database.child('quizzes/$quizId').remove();
      _myQuizzes.removeWhere((quiz) => quiz.id == quizId);
      _quizzes.removeWhere((quiz) => quiz.id == quizId);
    } catch (e) {
      _error = "Failed to delete quiz: ${e.toString()}";
      debugPrint(_error);
      throw e; // Rethrow to let the UI handle it
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 