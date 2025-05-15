import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:quizzz/models/quiz_history.dart';
import 'package:uuid/uuid.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class QuizProvider with ChangeNotifier {
  final DatabaseReference _database =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://quizzz-79fa5-default-rtdb.europe-west1.firebasedatabase.app',
      ).ref();

  bool _isLoading = false;
  bool _myQuizzesLoading = false;
  bool _allQuizzesLoading = false;
  String? _error;
  List<Quiz> _quizzes = [];
  List<Quiz> _myQuizzes = [];
  Map<String, dynamic>? _currentQuiz;
  List<QuizHistory> _quizHistory = [];

  bool get isLoading => _isLoading || _myQuizzesLoading || _allQuizzesLoading;
  bool get isLoadingMyQuizzes => _myQuizzesLoading;
  bool get isLoadingAllQuizzes => _allQuizzesLoading;
  String? get error => _error;
  List<Quiz> get quizzes => _quizzes;
  Map<String, dynamic>? get currentQuiz => _currentQuiz;
  List<QuizHistory> get quizHistory => _quizHistory;

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

      debugPrint(
        'Loaded all quizzes snapshot, exists: ${snapshot.exists}, hasChildren: ${snapshot.children.isNotEmpty}',
      );

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
        final filteredQuizzes =
            allQuizzes.where((quiz) => quiz.creatorId == userId).toList();
        debugPrint(
          'Filtered to ${filteredQuizzes.length} quizzes for user $userId',
        );

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

  Future<void> createQuiz(
    BuildContext context,
    Map<String, dynamic> quizData,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isGuest) {
      throw 'Гости не могут создавать квизы. Пожалуйста, зарегистрируйтесь.';
    }

    if (!authProvider.canCreateQuiz) {
      throw 'Только авторизованные пользователи могут создавать квизы';
    }

    try {
      _isLoading = true;
      notifyListeners();

      final user = authProvider.user;
      if (user == null) throw 'Пользователь не авторизован';

      // Add creator info to quiz data
      quizData['creatorId'] = user.uid;
      quizData['creatorEmail'] = user.email;
      quizData['createdAt'] = ServerValue.timestamp;

      // Save quiz to database
      final quizRef = _database.child('quizzes').push();
      await quizRef.set(quizData);

      // Add to local list
      quizData['id'] = quizRef.key;
      _quizzes.add(Quiz.fromJson(quizData));

      notifyListeners();
    } catch (e) {
      debugPrint('Error creating quiz: $e');
      throw 'Ошибка при создании квиза: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuiz(BuildContext context, String quizId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.canCreateQuiz) {
      throw 'Только авторизованные пользователи могут удалять квизы';
    }

    try {
      _isLoading = true;
      notifyListeners();

      final user = authProvider.user;
      if (user == null) throw 'Пользователь не авторизован';

      // Get quiz to check ownership
      final quizSnapshot = await _database.child('quizzes/$quizId').get();
      if (!quizSnapshot.exists) {
        throw 'Квиз не найден';
      }

      final quizData = Map<String, dynamic>.from(quizSnapshot.value as Map);
      if (quizData['creatorId'] != user.uid) {
        throw 'У вас нет прав на удаление этого квиза';
      }

      // Delete from database
      await _database.child('quizzes/$quizId').remove();

      // Remove from local list
      _quizzes.removeWhere((quiz) => quiz.id == quizId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting quiz: $e');
      throw 'Ошибка при удалении квиза: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<QuizHistory>> getUserQuizHistory(String userId) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw 'Не удалось получить контекст приложения';
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isGuest) {
      throw 'Гости не имеют доступа к истории квизов. Пожалуйста, зарегистрируйтесь.';
    }

    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final snapshot =
          await _database
              .child('quiz_history')
              .orderByChild('userId')
              .equalTo(userId)
              .get();

      if (!snapshot.exists) {
        return [];
      }

      final List<QuizHistory> history = [];
      for (var child in snapshot.children) {
        try {
          final data = Map<String, dynamic>.from(child.value as Map);
          history.add(QuizHistory.fromJson(data));
        } catch (e) {
          debugPrint('Error parsing quiz history: $e');
        }
      }

      // Sort by completion date, newest first
      history.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return history;
    } catch (e) {
      _error = "Failed to load quiz history: ${e.toString()}";
      debugPrint(_error);
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveQuizResult({
    required String quizId,
    required String userId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required int timeSpent,
  }) async {
    try {
      _isLoading = true;
      _clearError();
      notifyListeners();

      final history = QuizHistory(
        id: const Uuid().v4(),
        quizId: quizId,
        userId: userId,
        quizTitle: quizTitle,
        score: score,
        totalQuestions: totalQuestions,
        completedAt: DateTime.now(),
        timeSpent: timeSpent,
      );

      await _database.child('quiz_history/${history.id}').set(history.toJson());
      _quizHistory.add(history);
      notifyListeners();
    } catch (e) {
      _error = "Failed to save quiz result: ${e.toString()}";
      debugPrint(_error);
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addQuizHistory(BuildContext context, QuizHistory history) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;

      await _database.child('quiz_history/${history.id}').set(history.toJson());
      _quizHistory.add(history);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding quiz history: $e');
      rethrow;
    }
  }

  Future<void> loadQuizHistory(BuildContext context) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;

      final snapshot =
          await _database
              .child('quiz_history')
              .orderByChild('userId')
              .equalTo(user.uid)
              .get();

      if (!snapshot.exists) {
        _quizHistory = [];
        notifyListeners();
        return;
      }

      _quizHistory =
          snapshot.children
              .map(
                (child) => QuizHistory.fromJson(
                  Map<String, dynamic>.from(child.value as Map),
                ),
              )
              .toList();

      // Sort by completion date, newest first
      _quizHistory.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading quiz history: $e');
      rethrow;
    }
  }

  Future<void> deleteQuizHistory(BuildContext context, String historyId) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;

      await _database.child('quiz_history/$historyId').remove();
      _quizHistory.removeWhere((history) => history.id == historyId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting quiz history: $e');
      rethrow;
    }
  }
}
