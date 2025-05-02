import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';
import '../models/quiz.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static DatabaseReference? _databaseRef;
  static bool _initialized = false;
  static bool _isSupported = true;

  FirebaseService._();

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  static bool get isInitialized => _initialized;
  static bool get isSupported => _isSupported;
  static DatabaseReference? get database => _databaseRef;

  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      debugPrint('🔥 Initializing Firebase...');
      
      // Skip Firebase initialization on Linux
      if (Platform.isLinux) {
        debugPrint('⚠️ Firebase not supported on Linux platform');
        _isSupported = false;
        _initialized = true; // Mark as initialized so we don't try again
        return false;
      }

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Enable persistence
      try {
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        debugPrint('Firebase persistence enabled');
      } catch (e) {
        debugPrint('Could not enable Firebase persistence: $e');
        // Continue anyway
      }
      
      // Get database reference
      _databaseRef = FirebaseDatabase.instance.ref();
      
      // Test connection
      try {
        final connectionRef = FirebaseDatabase.instance.ref('.info/connected');
        final snapshot = await connectionRef.get();
        final isConnected = snapshot.value == true;
        
        if (isConnected) {
          debugPrint('✅ Firebase connected successfully');
        } else {
          debugPrint('⚠️ Firebase connection test failed, but initialization completed');
        }
      } catch (e) {
        debugPrint('⚠️ Could not test Firebase connection: $e');
        // Continue anyway
      }
      
      _initialized = true;
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing Firebase: $e');
      debugPrint('Stack trace: $stackTrace');
      _isSupported = false;
      _initialized = true; // Mark as initialized to prevent retries
      return false;
    }
  }

  // Quiz-related methods
  DatabaseReference? getQuizzesRef() {
    if (!isSupported || !_initialized || _databaseRef == null) return null;
    return _databaseRef!.child('quizzes');
  }

  // Data manipulation methods
  Future<bool> saveData(String path, Map<String, dynamic> data) async {
    if (!isSupported || !_initialized || _databaseRef == null) return false;
    
    try {
      await _databaseRef!.child(path).set(data);
      return true;
    } catch (e) {
      debugPrint('Error saving data to $path: $e');
      return false;
    }
  }

  Future<bool> updateData(String path, Map<String, dynamic> data) async {
    if (!isSupported || !_initialized || _databaseRef == null) return false;
    
    try {
      await _databaseRef!.child(path).update(data);
      return true;
    } catch (e) {
      debugPrint('Error updating data at $path: $e');
      return false;
    }
  }

  Future<DataSnapshot?> getData(String path) async {
    if (!isSupported || !_initialized || _databaseRef == null) return null;
    
    try {
      return await _databaseRef!.child(path).get();
    } catch (e) {
      debugPrint('Error getting data from $path: $e');
      return null;
    }
  }

  Future<bool> deleteData(String path) async {
    if (!isSupported || !_initialized || _databaseRef == null) return false;
    
    try {
      await _databaseRef!.child(path).remove();
      return true;
    } catch (e) {
      debugPrint('Error deleting data at $path: $e');
      return false;
    }
  }

  Future<void> importDefaultQuizzes(List<Quiz> quizzes) async {
    if (!isSupported || !_initialized || _databaseRef == null) return;
    
    try {
      final Map<String, dynamic> updates = {};
      for (var quiz in quizzes) {
        updates['/quizzes/${quiz.id}'] = quiz.toJson();
      }
      await _databaseRef!.update(updates);
    } catch (e) {
      debugPrint('Error importing default quizzes: $e');
    }
  }

  Stream<List<Quiz>> quizzesStream() {
    if (!isSupported || !_initialized || _databaseRef == null) {
      return Stream.value([]);
    }
    
    return _databaseRef!.child('quizzes').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      try {
        return data.entries.map((entry) {
          return Quiz.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();
      } catch (e) {
        debugPrint('Error parsing quizzes from stream: $e');
        return <Quiz>[];
      }
    });
  }
}