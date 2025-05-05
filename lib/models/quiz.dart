class Quiz {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final String creatorEmail;
  final List<Question> questions;
  final DateTime createdAt;
  final int timeLimit; // in seconds, 0 means no time limit

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.creatorEmail,
    required this.questions,
    required this.createdAt,
    this.timeLimit = 0,
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
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    try {
      // Parse questions safely
      List<Question> questionsList = [];
      if (json['questions'] != null) {
        final questionsData = json['questions'];
        if (questionsData is List) {
          for (var item in questionsData) {
            try {
              if (item is Map) {
                // Convert to Map<String, dynamic>
                final questionData = Map<String, dynamic>.fromEntries(
                  item.entries.map((e) => MapEntry(e.key.toString(), e.value))
                );
                questionsList.add(Question.fromJson(questionData));
              }
            } catch (e) {
              print('Error parsing question: $e');
            }
          }
        }
      }

      return Quiz(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        creatorId: json['creatorId']?.toString() ?? '',
        creatorEmail: json['creatorEmail']?.toString() ?? '',
        questions: questionsList,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'].toString()) 
            : DateTime.now(),
        timeLimit: json['timeLimit'] is int ? json['timeLimit'] : 0,
      );
    } catch (e) {
      print('Error creating Quiz from JSON: $e');
      // Return a default quiz if parsing fails
      return Quiz(
        id: '',
        title: 'Error Loading Quiz',
        description: 'There was an error loading this quiz.',
        creatorId: '',
        creatorEmail: '',
        questions: [],
        createdAt: DateTime.now(),
        timeLimit: 0,
      );
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
      // Handle options safely
      List<String> optionsList = [];
      if (json['options'] != null) {
        final optionsData = json['options'];
        if (optionsData is List) {
          optionsList = optionsData
              .map((item) => item?.toString() ?? '')
              .toList();
        }
      }

      return Question(
        question: json['question']?.toString() ?? '',
        options: optionsList,
        correctOptionIndex: json['correctOptionIndex'] is int 
            ? json['correctOptionIndex'] 
            : 0,
      );
    } catch (e) {
      print('Error creating Question from JSON: $e');
      // Return a default question if parsing fails
      return Question(
        question: 'Error loading question',
        options: ['Option 1', 'Option 2'],
        correctOptionIndex: 0,
      );
    }
  }
} 