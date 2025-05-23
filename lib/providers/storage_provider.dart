import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PendingChange {
  final String path;
  final dynamic data;
  final DateTime timestamp;

  PendingChange({
    required this.path,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'path': path,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PendingChange.fromJson(Map<String, dynamic> json) => PendingChange(
    path: json['path'],
    data: json['data'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class StorageProvider {
  static const String _pendingChangesBoxName = 'pending_changes';
  static const String _quizzesBoxName = 'quizzes';
  static const String _userDataBoxName = 'user_data';
  static const String _settingsBoxName = 'settings';
  static const String _historyBoxName = 'history';

  static late Box<dynamic> _pendingChangesBox;
  static late Box<dynamic> _quizzesBox;
  static late Box<dynamic> _userDataBox;
  static late Box<dynamic> _settingsBox;
  static late Box<dynamic> _historyBox;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(PendingChangeAdapter());
    
    // Open boxes
    _pendingChangesBox = await Hive.openBox(_pendingChangesBoxName);
    _quizzesBox = await Hive.openBox(_quizzesBoxName);
    _userDataBox = await Hive.openBox(_userDataBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _historyBox = await Hive.openBox(_historyBoxName);
  }

  // Pending Changes
  Future<List<PendingChange>> getPendingChanges() async {
    final changes = _pendingChangesBox.values
        .map((e) => PendingChange.fromJson(jsonDecode(e)))
        .toList();
    changes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return changes;
  }

  Future<void> addPendingChange(String path, dynamic data) async {
    final change = PendingChange(path: path, data: data);
    await _pendingChangesBox.add(jsonEncode(change.toJson()));
  }

  Future<void> clearPendingChanges() async {
    await _pendingChangesBox.clear();
  }

  // Quizzes
  Future<List<Map<String, dynamic>>> getQuizzes() async {
    return _quizzesBox.values
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }

  Future<void> saveQuiz(Map<String, dynamic> quiz) async {
    await _quizzesBox.put(quiz['id'], jsonEncode(quiz));
  }

  Future<void> deleteQuiz(String id) async {
    await _quizzesBox.delete(id);
  }

  // User Data
  Future<Map<String, dynamic>?> getUserData() async {
    final data = _userDataBox.get('current_user');
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userDataBox.put('current_user', jsonEncode(userData));
  }

  Future<void> clearUserData() async {
    await _userDataBox.clear();
  }

  // Settings
  Future<Map<String, dynamic>?> getSettings() async {
    final data = _settingsBox.get('settings');
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _settingsBox.put('settings', jsonEncode(settings));
  }

  // History
  Future<List<Map<String, dynamic>>> getHistory() async {
    return _historyBox.values
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }

  Future<void> saveHistory(Map<String, dynamic> history) async {
    await _historyBox.put(history['id'], jsonEncode(history));
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  // Clear all data
  Future<void> clearAll() async {
    await Future.wait<void>([
      _pendingChangesBox.clear(),
      _quizzesBox.clear(),
      _userDataBox.clear(),
      _settingsBox.clear(),
      _historyBox.clear(),
    ]);
  }

  // Helper method to validate quiz data
  bool _isValidQuiz(Map<String, dynamic> quiz) {
    return quiz['id'] != null &&
           quiz['id'].toString().isNotEmpty &&
           quiz['title'] != null &&
           quiz['title'].toString().isNotEmpty &&
           quiz['creatorId'] != null &&
           quiz['creatorId'].toString().isNotEmpty;
  }

  // Helper method to validate history data
  bool _isValidHistory(Map<String, dynamic> history) {
    return history['id'] != null &&
           history['id'].toString().isNotEmpty &&
           history['userId'] != null &&
           history['userId'].toString().isNotEmpty &&
           history['quizId'] != null &&
           history['quizId'].toString().isNotEmpty;
  }

  // Recovery methods
  Future<void> recoverCorruptedData() async {
    try {
      // Try to recover quizzes
      final quizBox = await Hive.openBox(_quizzesBoxName);
      final corruptedQuizzes = quizBox.values
          .where((e) => e is! Map<String, dynamic> || !_isValidQuiz(e))
          .toList();
      
      for (final quiz in corruptedQuizzes) {
        await quizBox.delete(quiz);
      }

      // Try to recover history
      final historyBox = await Hive.openBox(_historyBoxName);
      final corruptedHistory = historyBox.values
          .where((e) => e is! Map<String, dynamic> || !_isValidHistory(e))
          .toList();
      
      for (final history in corruptedHistory) {
        await historyBox.delete(history);
      }
    } catch (e) {
      debugPrint('Error recovering corrupted data: $e');
    }
  }
}

class PendingChangeAdapter extends TypeAdapter<PendingChange> {
  @override
  final int typeId = 0;

  @override
  PendingChange read(BinaryReader reader) {
    final json = jsonDecode(reader.readString());
    return PendingChange.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, PendingChange obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
} 