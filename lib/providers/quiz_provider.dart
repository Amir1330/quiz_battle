import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';

class QuizProvider with ChangeNotifier {
  static const String _quizzesKey = 'quizzes';
  late SharedPreferences _prefs;
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
          question: 'What is 5 x 5?',
          options: ['20', '25', '30', '35'],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Quiz(
      title: 'Basic Science',
      description: 'Test your basic science knowledge',
      language: 'en',
      isDefault: true,
      questions: [
        Question(
          question: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctOptionIndex: 2,
        ),
        Question(
          question: 'Which planet is known as the Red Planet?',
          options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
          correctOptionIndex: 1,
        ),
      ],
    ),
  ];

  List<Quiz> get quizzes => _quizzes;
  List<Quiz> get defaultQuizzes => _defaultQuizzes;

  QuizProvider() {
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    _prefs = await SharedPreferences.getInstance();
    final quizzesJson = _prefs.getStringList(_quizzesKey) ?? [];
    _quizzes = quizzesJson
        .map((json) => Quiz.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveQuizzes() async {
    final quizzesJson = _quizzes
        .map((quiz) => jsonEncode(quiz.toJson()))
        .toList();
    await _prefs.setStringList(_quizzesKey, quizzesJson);
  }

  Future<void> addQuiz(Quiz quiz) async {
    _quizzes.add(quiz);
    await _saveQuizzes();
    notifyListeners();
  }

  Future<void> updateQuiz(Quiz quiz) async {
    final index = _quizzes.indexWhere((q) => q.id == quiz.id);
    if (index != -1) {
      _quizzes[index] = quiz;
      await _saveQuizzes();
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    await _saveQuizzes();
    notifyListeners();
  }

  List<Quiz> getQuizzesByLanguage(String language) {
    return _quizzes.where((quiz) => quiz.language == language).toList();
  }
} 