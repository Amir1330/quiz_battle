import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quizzz/providers/connectivity_provider.dart';
import 'package:quizzz/providers/storage_provider.dart';
import 'package:quizzz/l10n/app_localizations.dart';
import 'quiz_provider.dart';

class SyncProvider with ChangeNotifier {
  final StorageProvider _storage;
  final ConnectivityProvider _connectivity;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final QuizProvider _quizProvider;
  
  bool _isSyncing = false;
  String? _lastSyncError;
  int _syncRetryCount = 0;
  static const int maxSyncRetries = 3;
  
  SyncProvider(this._storage, this._connectivity, this._quizProvider) {
    _init();
  }

  bool get isSyncing => _isSyncing;
  String? get lastSyncError => _lastSyncError;
  bool get hasPendingChanges => _syncRetryCount > 0;

  void _init() {
    // Listen to connectivity changes
    _connectivity.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    if (_connectivity.isConnected) {
      syncData();
    }
  }

  Future<void> syncData() async {
    if (_isSyncing) return;
    if (!_connectivity.isConnected) {
      _lastSyncError = 'No internet connection';
      notifyListeners();
      return;
    }

    try {
      _isSyncing = true;
      _lastSyncError = null;
      notifyListeners();

      final pendingChanges = await _storage.getPendingChanges();
      if (pendingChanges.isEmpty) {
        _isSyncing = false;
        notifyListeners();
        return;
      }

      for (final change in pendingChanges) {
        try {
          await _database.child(change.path).set(change.data);
          await _storage.clearPendingChanges();
        } catch (e) {
          _lastSyncError = e.toString();
          _syncRetryCount++;
          if (_syncRetryCount >= maxSyncRetries) {
            _syncRetryCount = 0;
          }
          notifyListeners();
          return;
        }
      }

      _syncRetryCount = 0;
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _lastSyncError = e.toString();
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> addPendingChange(String path, dynamic data) async {
    await _storage.addPendingChange(path, data);
    _syncRetryCount++;
    notifyListeners();
    
    if (_connectivity.isConnected) {
      await syncData();
    }
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
} 