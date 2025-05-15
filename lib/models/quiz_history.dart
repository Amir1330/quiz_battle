import 'package:firebase_database/firebase_database.dart';

class QuizHistory {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final int timeSpent; // в секундах

  QuizHistory({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.timeSpent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'quizTitle': quizTitle,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(),
      'timeSpent': timeSpent,
    };
  }

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    try {
      return QuizHistory(
        id: json['id']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        quizId: json['quizId']?.toString() ?? '',
        quizTitle: json['quizTitle']?.toString() ?? '',
        score: json['score'] is int ? json['score'] : 0,
        totalQuestions:
            json['totalQuestions'] is int ? json['totalQuestions'] : 0,
        completedAt:
            json['completedAt'] != null
                ? DateTime.parse(json['completedAt'].toString())
                : DateTime.now(),
        timeSpent: json['timeSpent'] is int ? json['timeSpent'] : 0,
      );
    } catch (e) {
      print('Error creating QuizHistory from JSON: $e');
      // Return a default history if parsing fails
      return QuizHistory(
        id: '',
        userId: '',
        quizId: '',
        quizTitle: 'Error Loading History',
        score: 0,
        totalQuestions: 0,
        completedAt: DateTime.now(),
        timeSpent: 0,
      );
    }
  }
}
