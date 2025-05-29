import 'package:hive/hive.dart';

part 'quiz_data.g.dart';

@HiveType(typeId: 0)
class QuizData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final int correctAnswer;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int difficulty;

  QuizData({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'] as int,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'category': category,
      'difficulty': difficulty,
    };
  }
}
