import 'package:uuid/uuid.dart';

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    String? id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final String language;
  final bool isDefault;

  Quiz({
    String? id,
    required this.title,
    required this.description,
    required this.questions,
    required this.language,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'language': language,
      'isDefault': isDefault,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      language: json['language'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Quiz copyWith({
    String? title,
    String? description,
    List<Question>? questions,
    String? language,
    bool? isDefault,
  }) {
    return Quiz(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      language: language ?? this.language,
      isDefault: isDefault ?? this.isDefault,
    );
  }
} 