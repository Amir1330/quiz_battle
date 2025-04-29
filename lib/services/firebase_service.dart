import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/quiz.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
    }
  }

  Future<void> importDefaultQuizzes(List<Quiz> quizzes) async {
    try {
      final batch = _database.child('quizzes').batch();
      for (var quiz in quizzes) {
        batch.set(quiz.id, quiz.toJson());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error importing default quizzes: $e');
    }
  }

  Stream<List<Quiz>> quizzesStream() {
    return _database.child('quizzes').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) {
        return Quiz.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    });
  }
}