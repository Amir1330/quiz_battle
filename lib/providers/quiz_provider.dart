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
    _initializeQuizzes();
  }

  Future<void> _initializeQuizzes() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    _prefs = await SharedPreferences.getInstance();
    final quizzesJson = _prefs.getStringList(_quizzesKey) ?? [];
    _quizzes =
        quizzesJson.map((json) => Quiz.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveQuizzes() async {
    final quizzesJson =
        _quizzes.map((quiz) => jsonEncode(quiz.toJson())).toList();
    await _prefs.setStringList(_quizzesKey, quizzesJson);
  }

  Future<void> loadQuizzes() async {
    try {
      final DataSnapshot snapshot = await _database.child('quizzes').get();
      if (snapshot.value != null) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        _quizzes = data.entries.map((entry) {
          return Quiz.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    try {
      await _database.child('quizzes').child(quiz.id).set(quiz.toJson());
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error adding quiz: $e');
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _database.child('quizzes').child(quiz.id).update(quiz.toJson());
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error updating quiz: $e');
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _database.child('quizzes').child(quizId).remove();
      await loadQuizzes();
    } catch (e) {
      debugPrint('Error deleting quiz: $e');
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
