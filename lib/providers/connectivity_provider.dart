import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz_provider.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;
  bool _isCheckingConnectivity = false;
  int _syncRetryCount = 0;
  static const int maxSyncRetries = 3;

  ConnectivityProvider() {
    _init();
  }

  bool get isConnected => _isConnected;
  bool get isOnline => _isConnected; // Alias for backward compatibility
  bool get isCheckingConnectivity => _isCheckingConnectivity;

  void _init() {
    // Initial connectivity check
    _checkConnectivity();
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _syncUnsyncedQuizzes() async {
    if (_syncRetryCount >= maxSyncRetries) {
      debugPrint('Max sync retries reached');
      _syncRetryCount = 0;
      return;
    }

    try {
      _syncRetryCount++;
      debugPrint('Attempting to sync quizzes (attempt $_syncRetryCount)');

      final quizProvider = Provider.of<QuizProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      await quizProvider.syncUnsyncedQuizzes();
      
      // Reset retry count on success
      _syncRetryCount = 0;
    } catch (e) {
      debugPrint('Error syncing quizzes (attempt $_syncRetryCount): $e');
      
      // Retry after delay if not at max retries
      if (_syncRetryCount < maxSyncRetries) {
        await Future.delayed(Duration(seconds: _syncRetryCount * 2));
        await _syncUnsyncedQuizzes();
      }
    }
  }

  // Manual sync trigger
  Future<void> forceSync() async {
    _syncRetryCount = 0;
    await _syncUnsyncedQuizzes();
  }
} 