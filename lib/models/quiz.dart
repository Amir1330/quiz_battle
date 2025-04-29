import 'package:uuid/uuid.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final String language;
  final List<Question> questions;
  final bool isDefault;

  Quiz({
    String? id,
    required this.title,
    required this.description,
    required this.language,
    required this.questions,
    this.isDefault = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(Map<String, dynamic>.from(q)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'isDefault': isDefault,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}