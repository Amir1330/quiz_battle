import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/quiz_data.dart';

class StorageService {
  static const String quizBox = 'quizBox';
  static const String settingsBox = 'settingsBox';

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuizDataAdapter());
    await Hive.openBox<QuizData>(quizBox);
    await Hive.openBox(settingsBox);
  }

  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> saveQuizData(List<QuizData> quizzes) async {
    final box = await Hive.openBox<QuizData>(quizBox);
    await box.clear();
    await box.addAll(quizzes);
  }

  Future<List<QuizData>> getLocalQuizData() async {
    final box = await Hive.openBox<QuizData>(quizBox);
    return box.values.toList();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final box = await Hive.openBox(settingsBox);
    await box.putAll(settings);
  }

  Future<Map<String, dynamic>> getSettings() async {
    final box = await Hive.openBox(settingsBox);
    return Map<String, dynamic>.from(box.toMap());
  }

  Future<void> clearLocalData() async {
    final quizBox = await Hive.openBox<QuizData>(StorageService.quizBox);
    await quizBox.clear();
  }
}
