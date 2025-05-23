class Quiz {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final String creatorEmail;
  final List<Question> questions;
  final DateTime createdAt;
  final int timeLimit; // in seconds, 0 means no time limit
  final bool isPublic;
  final bool deleted; // Add deleted field
  final bool synced;

  Quiz({
    required this.id,
    required this.title,
    this.description = '',
    required this.creatorId,
    required this.creatorEmail,
    required this.questions,
    required this.createdAt,
    this.timeLimit = 0,
    this.isPublic = false,
    this.deleted = false, // Default to false
    this.synced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'creatorEmail': creatorEmail,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'timeLimit': timeLimit,
      'isPublic': isPublic,
      'deleted': deleted, // Include deleted field
      'synced': synced,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    try {
      // Parse questions safely with null checks
      List<Question> questionsList = [];
      if (json['questions'] != null) {
        final questionsData = json['questions'];
        if (questionsData is List) {
          for (var item in questionsData) {
            try {
              if (item is Map) {
                // Convert to Map<String, dynamic> safely
                final questionData = Map<String, dynamic>.fromEntries(
                  item.entries.map((e) => MapEntry(e.key.toString(), e.value))
                );
                final question = Question.fromJson(questionData);
                // Only add valid questions
                if (question.question.isNotEmpty && question.options.isNotEmpty) {
                  questionsList.add(question);
                } else {
                  print('Skipping invalid question: empty question or options');
                }
              } else {
                print('Invalid question data format: $item');
              }
            } catch (e) {
              print('Error parsing question: $e');
            }
          }
        } else {
          print('Questions data is not a list: $questionsData');
        }
      } else {
        print('No questions data found in quiz');
      }

      // Ensure we have at least one valid question
      if (questionsList.isEmpty) {
        print('No valid questions found in quiz data');
        throw FormatException('Quiz must have at least one valid question');
      }

      // Validate required fields
      if (json['id'] == null || json['id'].toString().isEmpty) {
        throw FormatException('Quiz ID is required');
      }
      if (json['title'] == null || json['title'].toString().isEmpty) {
        throw FormatException('Quiz title is required');
      }
      if (json['creatorId'] == null || json['creatorId'].toString().isEmpty) {
        throw FormatException('Creator ID is required');
      }
      if (json['creatorEmail'] == null || json['creatorEmail'].toString().isEmpty) {
        throw FormatException('Creator email is required');
      }

      return Quiz(
        id: json['id'].toString(),
        title: json['title'].toString(),
        description: json['description']?.toString() ?? '',
        creatorId: json['creatorId'].toString(),
        creatorEmail: json['creatorEmail'].toString(),
        questions: questionsList,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'].toString()) 
            : DateTime.now(),
        timeLimit: json['timeLimit'] is int ? json['timeLimit'] : 0,
        isPublic: json['isPublic'] is bool ? json['isPublic'] : false,
        deleted: json['deleted'] is bool ? json['deleted'] : false,
        synced: json['synced'] is bool ? json['synced'] : false,
      );
    } catch (e) {
      print('Error creating Quiz from JSON: $e');
      // Instead of returning a default quiz, throw the error
      throw FormatException('Invalid quiz data: $e');
    }
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['question'] == null || json['question'].toString().isEmpty) {
        throw FormatException('Question text is required');
      }

      // Handle options safely with null checks
      List<String> optionsList = [];
      if (json['options'] != null) {
        final optionsData = json['options'];
        if (optionsData is List) {
          optionsList = optionsData
              .map((item) => item?.toString() ?? '')
              .where((item) => item.isNotEmpty) // Filter out empty options
              .toList();
        } else {
          throw FormatException('Options data is not a list: $optionsData');
        }
      } else {
        throw FormatException('Options are required');
      }

      // Ensure we have at least 2 options
      if (optionsList.length < 2) {
        throw FormatException('Question must have at least 2 options');
      }

      // Validate correctOptionIndex
      if (!json.containsKey('correctOptionIndex')) {
        throw FormatException('Correct option index is required');
      }
      
      final correctIndex = json['correctOptionIndex'] is int 
          ? json['correctOptionIndex'] 
          : int.tryParse(json['correctOptionIndex'].toString());
          
      if (correctIndex == null) {
        throw FormatException('Invalid correct option index format');
      }
      
      if (correctIndex < 0 || correctIndex >= optionsList.length) {
        throw FormatException('Correct option index out of range: $correctIndex');
      }

      return Question(
        question: json['question'].toString(),
        options: optionsList,
        correctOptionIndex: correctIndex,
      );
    } catch (e) {
      print('Error creating Question from JSON: $e');
      // Instead of returning a default question, throw the error
      throw FormatException('Invalid question data: $e');
    }
  }
}

class QuizHistory {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final int timeSpent;
  final bool synced;

  QuizHistory({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.timeSpent,
    this.synced = false,
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
      'synced': synced,
    };
  }

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['id'] == null || json['id'].toString().isEmpty) {
        throw FormatException('History ID is required');
      }
      if (json['userId'] == null || json['userId'].toString().isEmpty) {
        throw FormatException('User ID is required');
      }
      if (json['quizId'] == null || json['quizId'].toString().isEmpty) {
        throw FormatException('Quiz ID is required');
      }
      if (json['quizTitle'] == null || json['quizTitle'].toString().isEmpty) {
        throw FormatException('Quiz title is required');
      }
      if (!json.containsKey('score')) {
        throw FormatException('Score is required');
      }
      if (!json.containsKey('totalQuestions')) {
        throw FormatException('Total questions is required');
      }
      if (json['completedAt'] == null) {
        throw FormatException('Completion time is required');
      }
      if (!json.containsKey('timeSpent')) {
        throw FormatException('Time spent is required');
      }

      // Parse and validate numeric fields
      final score = json['score'] is int ? json['score'] : int.tryParse(json['score'].toString());
      if (score == null) {
        throw FormatException('Invalid score format');
      }

      final totalQuestions = json['totalQuestions'] is int 
          ? json['totalQuestions'] 
          : int.tryParse(json['totalQuestions'].toString());
      if (totalQuestions == null) {
        throw FormatException('Invalid total questions format');
      }

      final timeSpent = json['timeSpent'] is int 
          ? json['timeSpent'] 
          : int.tryParse(json['timeSpent'].toString());
      if (timeSpent == null) {
        throw FormatException('Invalid time spent format');
      }

      // Parse date
      DateTime completedAt;
      try {
        completedAt = DateTime.parse(json['completedAt'].toString());
      } catch (e) {
        throw FormatException('Invalid completion time format');
      }

      return QuizHistory(
        id: json['id'].toString(),
        userId: json['userId'].toString(),
        quizId: json['quizId'].toString(),
        quizTitle: json['quizTitle'].toString(),
        score: score,
        totalQuestions: totalQuestions,
        completedAt: completedAt,
        timeSpent: timeSpent,
        synced: json['synced'] is bool ? json['synced'] : false,
      );
    } catch (e) {
      print('Error creating QuizHistory from JSON: $e');
      // Instead of returning a default history, throw the error
      throw FormatException('Invalid history data: $e');
    }
  }
} 