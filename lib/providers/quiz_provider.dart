import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:quizzz/models/quiz.dart';
import 'package:uuid/uuid.dart';
import 'storage_provider.dart';
import 'connectivity_provider.dart';
import 'package:quizzz/providers/sync_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class QuizProvider with ChangeNotifier {
  final DatabaseReference _database =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://quizzz-79fa5-default-rtdb.europe-west1.firebasedatabase.app',
      ).ref();
  final StorageProvider _storageProvider;
  final ConnectivityProvider _connectivityProvider;

  bool _isLoading = false;
  bool _myQuizzesLoading = false;
  bool _allQuizzesLoading = false;
  String? _error;
  List<Quiz> _quizzes = [];
  List<Quiz> _myQuizzes = [];
  Map<String, dynamic>? _currentQuiz;
  List<QuizHistory> _quizHistory = [];
  bool _isSyncing = false;

  QuizProvider(this._storageProvider, this._connectivityProvider);

  bool get isLoading => _isLoading || _myQuizzesLoading || _allQuizzesLoading || _isSyncing;
  bool get isLoadingMyQuizzes => _myQuizzesLoading;
  bool get isLoadingAllQuizzes => _allQuizzesLoading;
  bool get isSyncing => _isSyncing;
  String? get error => _error;
  List<Quiz> get quizzes => List.unmodifiable(_quizzes.where((quiz) => quiz.id.isNotEmpty).toList());
  List<Quiz> get myQuizzes => List.unmodifiable(_myQuizzes.where((quiz) => quiz.id.isNotEmpty).toList());
  Map<String, dynamic>? get currentQuiz => _currentQuiz;
  List<QuizHistory> get quizHistory => List.unmodifiable(_quizHistory.where((history) => history.id.isNotEmpty).toList());

  void _setError(String message) {
    _error = message;
    debugPrint('QuizProvider Error: $message');
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  bool _isValidQuizData(Map<String, dynamic> data) {
    // Ensure required keys exist and have appropriate types
    return data.containsKey('id') &&
        data['id'] is String &&
        data.containsKey('title') &&
        data['title'] is String &&
        data.containsKey('description') &&
        data['description'] is String &&
        data.containsKey('creatorId') &&
        data['creatorId'] is String &&
        data.containsKey('creatorEmail') &&
        data['creatorEmail'] is String &&
        data.containsKey('questions') && // Just check if it exists, can be empty
        data.containsKey('timeLimit') &&
        data['timeLimit'] is num;
  }

  bool _isValidHistoryData(Map<String, dynamic> data) {
    return data.containsKey('id') &&
        data.containsKey('userId') &&
        data.containsKey('quizId') &&
        data.containsKey('quizTitle') &&
        data.containsKey('score') &&
        data.containsKey('totalQuestions') &&
        data.containsKey('completedAt') &&
        data.containsKey('timeSpent');
  }

  // Helper to parse a single quiz from a map
  Quiz? _parseSingleQuiz(Map<String, dynamic> data) {
    if (data == null) {
      debugPrint('Attempted to parse null quiz data');
      return null;
    }

    try {
      // Validate required fields before parsing
      if (!data.containsKey('id') || data['id'] == null) {
        debugPrint('Quiz data missing ID');
        return null;
      }
      if (!data.containsKey('title') || data['title'] == null) {
        debugPrint('Quiz data missing title');
        return null;
      }
      if (!data.containsKey('description') || data['description'] == null) {
        debugPrint('Quiz data missing description');
        return null;
      }
      if (!data.containsKey('creatorId') || data['creatorId'] == null) {
        debugPrint('Quiz data missing creatorId');
        return null;
      }
      if (!data.containsKey('questions')) {
        debugPrint('Quiz data missing questions field');
        data['questions'] = []; // Initialize empty questions array if missing
      }
      if (!data.containsKey('timeLimit')) {
        debugPrint('Quiz data missing timeLimit field');
        data['timeLimit'] = 0; // Set default time limit if missing
      }

      // Use the fromJson method in the Quiz model which handles validation and parsing
      return Quiz.fromJson(data);
    } catch (e) {
      debugPrint('Error parsing quiz: $e, data: $data');
      return null; // Return null if parsing fails
    }
  }

  // Helper to parse a single quiz history entry from a map
  QuizHistory? _parseSingleHistory(Map<String, dynamic> data) {
    if (data == null) {
      debugPrint('Attempted to parse null history data');
      return null;
    }

    try {
      // Validate required fields before parsing
      if (!data.containsKey('id') || data['id'] == null) {
        debugPrint('History data missing ID');
        return null;
      }
      if (!data.containsKey('userId') || data['userId'] == null) {
        debugPrint('History data missing userId');
        return null;
      }
      if (!data.containsKey('quizId') || data['quizId'] == null) {
        debugPrint('History data missing quizId');
        return null;
      }
      if (!data.containsKey('quizTitle') || data['quizTitle'] == null) {
        debugPrint('History data missing quizTitle');
        return null;
      }
      if (!data.containsKey('score') || data['score'] == null) {
        debugPrint('History data missing score');
        return null;
      }
      if (!data.containsKey('totalQuestions') || data['totalQuestions'] == null) {
        debugPrint('History data missing totalQuestions');
        return null;
      }
      if (!data.containsKey('completedAt') || data['completedAt'] == null) {
        debugPrint('History data missing completedAt');
        return null;
      }
      if (!data.containsKey('timeSpent') || data['timeSpent'] == null) {
        debugPrint('History data missing timeSpent');
        return null;
      }

      // Use the fromJson method in the QuizHistory model which handles validation and parsing
      return QuizHistory.fromJson(data);
    } catch (e) {
      debugPrint('Error parsing history entry: $e, data: $data');
      return null; // Return null if parsing fails
    }
  }

  // Parses data from Firebase (Map of Maps) into a list of Quizzes
  List<Quiz> _parseFirebaseQuizData(dynamic data) {
    if (data == null) {
      debugPrint('Firebase quiz data is null');
      return [];
    }
    
    List<Quiz> result = [];
    try {
      if (data is Map) {
        data.forEach((key, value) {
          if (value == null) {
            debugPrint('Firebase quiz value is null for key: $key');
            return; // Skip null values
          }
          
          if (value is Map<String, dynamic>) {
            // Ensure the map has an ID
            if (!value.containsKey('id') || value['id'] == null) {
              debugPrint('Firebase quiz entry missing ID for key: $key');
              return; // Skip entries without ID
            }
            
            final quiz = _parseSingleQuiz(value);
            if (quiz != null) {
              result.add(quiz);
            } else {
              debugPrint('Failed to parse Firebase quiz for key: $key');
            }
          } else {
            debugPrint('Firebase quiz entry is not a map for key: $key, value type: ${value.runtimeType}');
          }
        });
      } else {
        debugPrint('Firebase quiz data is not a Map, type: ${data.runtimeType}');
      }
      return result;
    } catch (e) {
      debugPrint('Error in _parseFirebaseQuizData: $e');
      return [];
    }
  }

   // Parses data from Firebase (Map of Maps) into a list of QuizHistory
  List<QuizHistory> _parseFirebaseHistoryData(dynamic data) {
    if (data == null) return [];
    
    List<QuizHistory> result = [];
    try {
      if (data is Map) {
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) { // Ensure value is a map before casting
            final historyEntry = _parseSingleHistory(value);
            if (historyEntry != null) {
              result.add(historyEntry);
            }
          } else {
             debugPrint('Firebase history entry is not a map: $value');
          }
        });
      } else if (data is List) { // Handle cases where Firebase returns a List
         for (final value in data) {
            if (value is Map<String, dynamic>) { // Ensure value is a map before casting
               final historyEntry = _parseSingleHistory(value);
                if (historyEntry != null) {
                  result.add(historyEntry);
                }
            } else {
               debugPrint('Firebase history entry in list is not a map: $value');
            }
         }
      }
      return result; // Return list of parsed history entries (can be empty)
    } catch (e) {
      debugPrint('Error in _parseFirebaseHistoryData: $e');
      return []; // Return empty list in case of error
    }
  }


  Future<void> loadQuizzes() async {
    if (_allQuizzesLoading) return;

    try {
      _allQuizzesLoading = true;
      _clearError();
      notifyListeners();

      List<Quiz> loadedQuizzes = [];

      // First try to load from Firebase if online
      final connectivityProvider = Provider.of<ConnectivityProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      if (connectivityProvider.isConnected) {
        try {
          debugPrint('Attempting to load quizzes from Firebase...');
          final snapshot = await _database.child('quizzes').get();
          
          if (snapshot.exists && snapshot.value != null) {
            debugPrint('Firebase data received, processing...');
            final data = snapshot.value;
            
            if (data is Map) {
              debugPrint('Processing ${data.length} quizzes from Firebase');
              
              for (final entry in data.entries) {
                try {
                  if (entry.value is Map) {
                    final quizData = Map<String, dynamic>.from(entry.value);
                    
                    // Ensure all required fields exist with defaults
                    quizData['id'] = quizData['id'] ?? entry.key;
                    quizData['questions'] = quizData['questions'] ?? [];
                    quizData['timeLimit'] = quizData['timeLimit'] ?? 0;
                    
                    // Basic validation
                    if (quizData['id'] != null && 
                        quizData['title'] != null && 
                        quizData['description'] != null && 
                        quizData['creatorId'] != null) {
                      
                      final quiz = Quiz.fromJson(quizData);
                      if (quiz != null) {
                        loadedQuizzes.add(quiz);
                        debugPrint('Successfully loaded quiz: ${quiz.id}');
                        
                        // Save to local storage
                        try {
                          await _storageProvider.saveQuiz(quizData);
                          debugPrint('Saved quiz ${quiz.id} to local storage');
                        } catch (e) {
                          debugPrint('Error saving quiz to local storage: $e');
                        }
                      }
                    } else {
                      debugPrint('Skipping invalid quiz data: ${quizData['id']}');
                    }
                  }
                } catch (e) {
                  debugPrint('Error processing quiz entry: $e');
                  continue; // Skip this entry and continue with others
                }
              }
            }
          }
        } catch (e) {
          debugPrint('Error loading from Firebase: $e');
        }
      }

      // If no quizzes loaded from Firebase, try local storage
      if (loadedQuizzes.isEmpty) {
        try {
          debugPrint('Loading quizzes from local storage...');
          final localData = await _storageProvider.getQuizzes();
          
          if (localData != null) {
            for (final item in localData) {
              try {
                if (item is Map<String, dynamic>) {
                  final quiz = Quiz.fromJson(item);
                  if (quiz != null) {
                    loadedQuizzes.add(quiz);
                    debugPrint('Loaded quiz from local storage: ${quiz.id}');
                  }
                }
              } catch (e) {
                debugPrint('Error processing local quiz: $e');
                continue;
              }
            }
          }
        } catch (e) {
          debugPrint('Error loading from local storage: $e');
        }
      }

      // Sort and update the quizzes list
      if (loadedQuizzes.isNotEmpty) {
        loadedQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _quizzes = loadedQuizzes;
        debugPrint('Successfully loaded ${_quizzes.length} quizzes');
      } else {
        debugPrint('No quizzes loaded from either source');
        _quizzes = [];
      }

    } catch (e) {
      debugPrint('Critical error in loadQuizzes: $e');
      _setError('Failed to load quizzes: ${e.toString()}');
      _quizzes = [];
    } finally {
      _allQuizzesLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocalQuizzes() async {
    if (_allQuizzesLoading) return;

    try {
      _allQuizzesLoading = true;
      _clearError();
      notifyListeners();

      debugPrint('Loading quizzes from local storage');
      final localQuizzesData = await _storageProvider.getQuizzes();
      
      final parsedQuizzes = localQuizzesData
          .map((data) { 
             if (data is Map<String, dynamic>) { // Ensure data is map before parsing
               return _parseSingleQuiz(data);
            }
            debugPrint('Local quiz data is not a map: $data');
            return null; // Return null for invalid data format
          })
          .where((quiz) => quiz != null) // Filter out null results from parsing
          .cast<Quiz>()
          .toList();

      debugPrint('Loaded ${parsedQuizzes.length} quizzes from local storage');

      // Sort by newest first
      parsedQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

       // Filter out any potential nulls or quizzes with empty IDs before assigning to _quizzes
      _quizzes = parsedQuizzes.where((quiz) => quiz != null && quiz.id.isNotEmpty).toList();
    } catch (e) {
      _error = "Failed to load local quizzes: ${e.toString()}";
      debugPrint(_error);
    } finally {
      _allQuizzesLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyQuizzes(String userId) async {
    if (_myQuizzesLoading) {
      debugPrint('Skipping loadMyQuizzes - already in progress');
      return;
    }

    try {
      _myQuizzesLoading = true;
      _clearError();
      notifyListeners();

      final connectivityProvider = Provider.of<ConnectivityProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      List<Quiz> loadedQuizzes = [];

      // Get all local quizzes first
      debugPrint('loadMyQuizzes: Loading quizzes from local storage for user: $userId');
      final localQuizzesData = await _storageProvider.getQuizzes();
      debugPrint('loadMyQuizzes: Local storage data fetched: ${localQuizzesData?.length ?? 0} items');

      if (localQuizzesData != null) {
        debugPrint('loadMyQuizzes: Processing local storage data');
        // Filter, validate, and parse local quizzes for current user and not deleted
        final localUserQuizzes = localQuizzesData
            .where((item) => item is Map<String, dynamic>) // Explicitly check if item is a map
            .map((item) { 
               final Map<String, dynamic> data = item as Map<String, dynamic>; // Safe cast after where
               debugPrint('loadMyQuQuizzes: Processing local quiz data entry: ${data['id'] ?? 'No ID'}');
               // Basic validation before parsing
               if (data.containsKey('creatorId') && data['creatorId'] == userId) {
                 try {
                   final quiz = _parseSingleQuiz(data);
                   if (quiz == null) {
                     debugPrint('loadMyQuizzes: Failed to parse local quiz: ${data['id'] ?? 'No ID'}');
                   }
                   return quiz;
                 } catch (e) {
                   debugPrint('loadMyQuizzes: Error parsing local quiz ${data['id'] ?? 'No ID'}: $e');
                   return null;
                 }
               } else {
                 debugPrint('loadMyQuizzes: Skipping local quiz entry for wrong user or missing creatorId: ${data['id'] ?? 'No ID'}');
                 return null;
               }
            }) 
            .where((quiz) => 
                quiz != null && // Check if parsing was successful
                !quiz!.deleted && // Ensure quiz is not marked as deleted (using ! here as quiz is non-null)
                quiz.id.isNotEmpty) // Ensure quiz has a non-empty ID
            .cast<Quiz>() // Safely cast after filtering out nulls
            .toList();

        debugPrint('loadMyQuizzes: Found ${localUserQuizzes.length} valid local quizzes for user $userId');
        loadedQuizzes = localUserQuizzes; // Start with valid local quizzes
        debugPrint('loadMyQuizzes: Initial loadedQuizzes count: ${loadedQuizzes.length}');
      }

      if (connectivityProvider.isConnected) {
        debugPrint('loadMyQuizzes: Connection is online. Loading from Firebase for user: $userId');
        try {
          final snapshot = await _database.child('quizzes').get();
          debugPrint('loadMyQuizzes: Firebase snapshot fetched. Exists: ${snapshot.exists}');
      if (snapshot.exists && snapshot.value != null) {
            final allQuizzesData = snapshot.value;
            debugPrint('loadMyQuizzes: Firebase data type: ${allQuizzesData.runtimeType}');
            if (allQuizzesData is Map) {
              debugPrint('loadMyQuizzes: Processing Firebase data map');
              final allFirebaseQuizzes = allQuizzesData.values
                  .where((value) => value is Map<String, dynamic>) // Ensure value is a map
                  .map((value) => Map<String, dynamic>.from(value))
                  .toList();
              debugPrint('loadMyQuizzes: Filtered Firebase entries count: ${allFirebaseQuizzes.length}');

              // Save all quizzes from Firebase to local storage (this includes others' quizzes, handled by sync)
              debugPrint('loadMyQuizzes: Saving Firebase quizzes to local storage');
              for (final quizData in allFirebaseQuizzes) {
                try {
                  // Mark as synced from Firebase before saving locally
                  quizData['synced'] = true;
                  // Ensure quizData is a valid map before saving
                  if (quizData is Map<String, dynamic>) {
                     // Only save if it has an ID to avoid saving bad data
                     if (quizData.containsKey('id') && quizData['id'] != null && (quizData['id'] as String).isNotEmpty) {
                        await _storageProvider.saveQuiz(quizData);
                        debugPrint('loadMyQuizzes: Saved Firebase quiz ${quizData['id']} locally');
                     } else {
                        debugPrint('loadMyQuizzes: Skipping saving Firebase quiz with missing/empty ID to local storage: $quizData');
                     }
                  } else {
                     debugPrint('loadMyQuizzes: Skipping saving non-map Firebase quiz data to local storage: $quizData');
                  }
                } catch (e) {
                  debugPrint('loadMyQuizzes: Error saving Firebase quiz to local storage: $e');
                }
              }
              debugPrint('loadMyQuizzes: Finished saving Firebase quizzes locally');

              // Filter Firebase quizzes for the current user, validate, and parse
              debugPrint('loadMyQuizzes: Filtering and parsing remote quizzes for user $userId');
              final remoteUserQuizzes = allFirebaseQuizzes
                  .where((item) => item is Map<String, dynamic>) // Explicitly check if item is a map
                  .map((item) {
                     final Map<String, dynamic> data = item as Map<String, dynamic>; // Safe cast after where
                     debugPrint('loadMyQuizzes: Processing remote quiz data entry: ${data['id'] ?? 'No ID'}');
                     // Basic validation before parsing
                     if (data.containsKey('creatorId') && data['creatorId'] == userId) {
                       try {
                         final quiz = _parseSingleQuiz(data);
                         if (quiz == null) {
                           debugPrint('loadMyQuizzes: Failed to parse remote quiz: ${data['id'] ?? 'No ID'}');
                         }
                         return quiz;
                       } catch (e) {
                         debugPrint('loadMyQuizzes: Error parsing remote quiz ${data['id'] ?? 'No ID'}: $e');
                         return null;
                       }
                     } else {
                        debugPrint('loadMyQuizzes: Skipping remote quiz entry for wrong user or missing creatorId: ${data['id'] ?? 'No ID'}');
                       return null;
                     }
                   })
                  .where((quiz) => 
                      quiz != null && // Check for null after parsing
                      !quiz!.deleted && // Ensure quiz is not marked as deleted (using ! here as quiz is non-null)
                      quiz.id.isNotEmpty) // Ensure quiz has a non-empty ID
                  .cast<Quiz>() // Safely cast after filtering out nulls
                  .toList();

              debugPrint('loadMyQuizzes: Found ${remoteUserQuizzes.length} valid remote quizzes for user $userId in Firebase');

              // Merge local and remote quizzes, prioritizing remote if online
              debugPrint('loadMyQuizzes: Merging local and remote quizzes');
              final Map<String, Quiz> mergedQuizzes = {};
                
              // Add local quizzes first
              for (final quiz in loadedQuizzes) {
                // Already validated to have non-empty ID
                debugPrint('loadMyQuizzes: Adding local quiz to merge map: ${quiz.id}');
                mergedQuizzes[quiz.id] = quiz;
              }
              
              // Add remote quizzes (overwriting local if same ID)
              for (final quiz in remoteUserQuizzes) {
                 // Already validated to have non-empty ID
                 debugPrint('loadMyQuizzes: Adding remote quiz to merge map: ${quiz.id}');
                 mergedQuizzes[quiz.id] = quiz;
              }
              
              loadedQuizzes = mergedQuizzes.values.toList();
              debugPrint('loadMyQuizzes: Merged quizzes count: ${loadedQuizzes.length}');
      } else {
               debugPrint('loadMyQuizzes: Firebase quizzes data is not in expected Map format for loadMyQuizzes: ${allQuizzesData.runtimeType}');
            }
          } else {
            debugPrint('loadMyQuizzes: No quizzes found in Firebase for user $userId');
      }
    } catch (e) {
          debugPrint('loadMyQuizzes: Error loading my quizzes from Firebase: $e');
          // Continue with valid local quizzes if Firebase load fails
          debugPrint('loadMyQuizzes: Firebase load failed, using ${loadedQuizzes.length} local quizzes instead');
        }
      } else {
        debugPrint('loadMyQuizzes: Offline: Loading only valid local quizzes for user: $userId. Count: ${loadedQuizzes.length}');
      }

      debugPrint('loadMyQuizzes: Sorting loaded quizzes');
      loadedQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // Assign the list of valid, merged quizzes
      _myQuizzes = loadedQuizzes; // Already filtered and validated above
      debugPrint('loadMyQuizzes: Final _myQuizzes count: ${_myQuizzes.length}');
      
    } catch (e) {
      // Catch any remaining errors during the process
      debugPrint('loadMyQuizzes: Top-level error caught: $e');
      _setError('Failed to load your quizzes: ${e.toString()}');
    } finally {
      _myQuizzesLoading = false;
      debugPrint('loadMyQuizzes: Loading complete. Notifying listeners.');
      notifyListeners();
    }
  }

  Future<void> createQuiz(Quiz quiz) async {
    _isLoading = true;
    _clearError();
    notifyListeners();
    
    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    try {
      final quizData = quiz.toJson();

      if (connectivityProvider.isConnected) {
        debugPrint('Creating quiz in Firebase: ${quiz.id}');
        // Ensure quiz is marked for syncing even if created online
        quizData['synced'] = true;
        await _database.child('quizzes').child(quiz.id).set(quizData);
        // Save to local storage after successful Firebase write
        await _storageProvider.saveQuiz(quizData);
        debugPrint('Quiz created successfully in Firebase and saved locally');

      } else {
        debugPrint('Offline: Saving quiz locally: ${quiz.id}');
        // Mark as not synced for later upload
        quizData['synced'] = false;
        await _storageProvider.saveQuiz(quizData);
        // Add to pending changes for sync
        final syncProvider = Provider.of<SyncProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        await syncProvider.addPendingChange('quizzes/${quiz.id}', quizData);
        debugPrint('Quiz saved locally and added to sync queue');
      }

      // Add the new quiz to the local lists immediately (after ensuring it's a valid quiz)
      if (quiz.id.isNotEmpty) {
         _quizzes.add(quiz);
         _myQuizzes.add(quiz);
         _quizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
         _myQuizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
         notifyListeners();
      } else {
         debugPrint('Created quiz has empty ID, not adding to local lists: ${quiz.title}');
      }

    } catch (e) {
      _setError('Failed to create quiz: ${e.toString()}');
    } finally {
      _isLoading = false;
      // notifyListeners(); // Already notified above if quiz was added
    }
  }

  Future<void> deleteQuiz(String quizId, String userId) async {
      _isLoading = true;
    _clearError();
      notifyListeners();

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    try {
      // Mark as deleted locally first
      final localQuizzesData = await _storageProvider.getQuizzes();
      final quizToDeleteDataIndex = localQuizzesData.indexWhere(
        (quiz) => quiz is Map<String, dynamic> && quiz['id'] == quizId && quiz['creatorId'] == userId
      );

      Map<String, dynamic> quizToDeleteData;

      if (quizToDeleteDataIndex != -1) {
        // Create a mutable map copy
        quizToDeleteData = Map<String, dynamic>.from(localQuizzesData[quizToDeleteDataIndex]);
      } else {
         // If not found locally, create a minimal record to mark for deletion during sync
         quizToDeleteData = { 'id': quizId, 'creatorId': userId, 'deleted': true, 'synced': false };
      }

      // Ensure 'deleted' is true and 'synced' is false for sync
      quizToDeleteData['deleted'] = true;
      quizToDeleteData['synced'] = false;
      await _storageProvider.saveQuiz(quizToDeleteData);
      debugPrint('Quiz marked as deleted locally: $quizId');

      // Remove from local lists
      _quizzes.removeWhere((quiz) => quiz.id == quizId);
      _myQuizzes.removeWhere((quiz) => quiz.id == quizId);
      notifyListeners(); // Notify to update UI immediately

      // Add to pending changes for sync
      final syncProvider = Provider.of<SyncProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      // Use null as data to indicate deletion in Firebase
      await syncProvider.addPendingChange('quizzes/$quizId', null);
      debugPrint('Delete action added to sync queue for quiz: $quizId');

      // If online, attempt immediate Firebase deletion (fire-and-forget for responsiveness)
      if (connectivityProvider.isConnected) {
        debugPrint('Attempting immediate Firebase deletion for quiz: $quizId');
        _database.child('quizzes').child(quizId).remove().then((_) {
          debugPrint('Quiz deleted from Firebase: $quizId');
          // No need to remove from local storage here, sync will handle it
        }).catchError((e) {
          debugPrint('Error deleting quiz from Firebase: $e. Will sync later.');
          // SyncProvider will handle retries
        });
      }

    } catch (e) {
      _setError('Failed to delete quiz: ${e.toString()}');
    } finally {
      _isLoading = false;
      // notifyListeners(); // Already notified when removing from local lists
    }
  }

  Future<void> loadQuizHistory(String userId) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    try {
      List<QuizHistory> loadedHistory = [];

      // Load from local storage
      debugPrint('Loading history from local storage for user: $userId');
      final localHistoryData = await _storageProvider.getHistory();
      loadedHistory = localHistoryData
          .map((data) { 
            if (data is Map<String, dynamic>) { // Ensure data is map before parsing
               return _parseSingleHistory(data);
            }
            debugPrint('Local history data is not a map: $data');
            return null; // Return null for invalid data format
          })
          .where((history) => history != null) // Filter out null results from parsing
          .cast<QuizHistory>()
          .toList();
      debugPrint('Loaded ${loadedHistory.length} history entries from local storage');

      if (connectivityProvider.isConnected) {
        debugPrint('Loading quiz history from Firebase for user: $userId');
        try {
          final snapshot = await _database.child('history').child(userId).get();
          if (snapshot.exists && snapshot.value != null) {
            final historyData = snapshot.value;
            if (historyData is Map) {
              final remoteHistoryEntries = historyData.values
                  .where((value) => value is Map<String, dynamic>) // Ensure value is a map
                  .map((value) => Map<String, dynamic>.from(value))
                   .map((data) { 
                      if (data is Map<String, dynamic>) { // Ensure data is map before parsing
                         return _parseSingleHistory(data);
                      }
                       debugPrint('Remote history data is not a map: $data');
                       return null; // Return null for invalid data format
                   })
                  .where((history) => history != null) // Filter out null results from parsing
                  .cast<QuizHistory>()
                  .toList();

              // Merge local and remote history, prioritizing remote
              final Map<String, QuizHistory> mergedHistory = {};
                
              for (final entry in loadedHistory) {
                 if (entry.id.isNotEmpty) { // Ensure entry has a valid ID before merging
                    mergedHistory[entry.id] = entry;
                 } else {
                     debugPrint('Skipping local history entry with empty ID during merge');
                 }
              }
              
              for (final entry in remoteHistoryEntries) {
                 if (entry.id.isNotEmpty) { // Ensure entry has a valid ID before merging
                    mergedHistory[entry.id] = entry;
                     // Save remote history entries to local storage, marking them as synced
                    final dataToSave = entry.toJson();
                    dataToSave['synced'] = true;
                    await _storageProvider.saveHistory(dataToSave);
                 } else {
                     debugPrint('Skipping remote history entry with empty ID during merge');
                 }
              }
              
              loadedHistory = mergedHistory.values.toList();
               debugPrint('Loaded and merged ${loadedHistory.length} history entries from Firebase and local storage');

            } else {
              debugPrint('Firebase history data is not in expected Map format');
            }
          } else {
            debugPrint('No quiz history found in Firebase for user $userId');
          }
        } catch (e) {
          debugPrint('Error loading quiz history from Firebase: $e');
          // Continue with local history if Firebase load fails
           debugPrint('Firebase load failed, using ${loadedHistory.length} local history entries instead');
        }
      } else {
        debugPrint('Offline: Loading only local quiz history for user: $userId');
      }

      loadedHistory.sort((a, b) => b.completedAt.compareTo(a.completedAt));
       // Filter out any potential nulls or history entries with empty IDs before assigning to _quizHistory
      _quizHistory = loadedHistory.where((history) => history.id.isNotEmpty).toList();

    } catch (e) {
      _setError('Failed to load quiz history: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveQuizResult(QuizHistory result, String userId) async {
     _isLoading = true;
    _clearError();
    notifyListeners();

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    try {
       // Save to local storage first
      final historyData = result.toJson();
      historyData['synced'] = false; // Mark as not synced initially
      await _storageProvider.saveHistory(historyData);
       debugPrint('Quiz result saved locally: ${result.id}');

      // Add to local history list immediately (after ensuring it's a valid history entry)
      if (result.id.isNotEmpty && result.userId.isNotEmpty) {
         _quizHistory.add(result);
         _quizHistory.sort((a, b) => b.completedAt.compareTo(a.completedAt));
         notifyListeners(); // Notify to update UI
      } else {
         debugPrint('Saved history entry has empty ID or UserId, not adding to local list: ${result.id}, ${result.userId}');
      }

      // Add to pending changes for sync
      final syncProvider = Provider.of<SyncProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
      await syncProvider.addPendingChange('history/$userId/${result.id}', historyData);
      debugPrint('Quiz result added to sync queue: ${result.id}');


      // If online, attempt immediate Firebase save (fire-and-forget)
      if (connectivityProvider.isConnected) {
        debugPrint('Attempting immediate Firebase save for quiz result: ${result.id}');
         // Mark as synced before sending to Firebase
        historyData['synced'] = true;
         _database.child('history').child(userId).child(result.id).set(historyData).then((_) {
          debugPrint('Quiz result saved to Firebase: ${result.id}');
          // No need to update local storage here, sync will handle it
        }).catchError((e) {
          debugPrint('Error saving quiz result to Firebase: $e. Will sync later.');
          // SyncProvider will handle retries
        });
      }

    } catch (e) {
      _setError('Error saving quiz results: ${e.toString()}');
    } finally {
       _isLoading = false;
      // notifyListeners(); // Already notified when adding to local history list if entry was added
    }
  }

  // Sync unsynced local quizzes to Firebase
  Future<void> syncUnsyncedQuizzes() async {
    if (_isSyncing) return;

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    if (!connectivityProvider.isConnected) {
      debugPrint('Cannot sync: Offline');
      return;
    }

    _isSyncing = true;
    notifyListeners();

    debugPrint('Starting sync of unsynced local quizzes');
    try {
      final localQuizzesData = await _storageProvider.getQuizzes();
      final unsyncedQuizzes = localQuizzesData
          .where((quiz) => 
              quiz is Map<String, dynamic> && // Ensure it's a map
              !(quiz['synced'] ?? true) && 
              _isValidQuizData(quiz) &&
              (quiz['id'] is String && (quiz['id'] as String).isNotEmpty) // Ensure it has a valid ID
           )
          .toList();

      debugPrint('Found ${unsyncedQuizzes.length} unsynced local quizzes');

      for (final quizData in unsyncedQuizzes) {
        // Ensure quizData is map before processing
        if (quizData is Map<String, dynamic>) {
           final quizId = quizData['id'] as String?;
            if (quizId != null && quizId.isNotEmpty) {
              try {
                if (quizData['deleted'] ?? false) {
                  // If marked for deletion, remove from Firebase
                  await _database.child('quizzes').child(quizId).remove();
                  debugPrint('Deleted quiz $quizId from Firebase during sync');
                  // Remove from local storage after successful Firebase deletion
                  await _storageProvider.deleteQuiz(quizId);
                   debugPrint('Deleted quiz $quizId from local storage after sync');

                } else {
                  // Otherwise, save/update in Firebase
                  // Ensure the synced flag is true before sending
                  quizData['synced'] = true;
                  await _database.child('quizzes').child(quizId).set(quizData);
                  debugPrint('Synced quiz $quizId to Firebase');
                  // Update local storage to mark as synced
                  await _storageProvider.saveQuiz(quizData);
                   debugPrint('Updated local storage for quiz $quizId after sync');
                }
        } catch (e) {
                debugPrint('Error syncing quiz $quizId: $e. Will retry later.');
                // If Firebase operation fails, keep unsynced flag as false to retry
                quizData['synced'] = false;
                await _storageProvider.saveQuiz(quizData);
                 debugPrint('Marked quiz $quizId for retry after sync error');
              }
            } else {
               debugPrint('Unsynced quiz data missing ID: $quizData');
            }
        } else {
           debugPrint('Unsynced quiz data is not a map: $quizData');
        }
      }

      debugPrint('Sync of unsynced local quizzes completed');

    } catch (e) {
      debugPrint('Error during syncUnsyncedQuizzes: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

   Future<void> syncUnsyncedHistory() async {
     if (_isSyncing) return; // Avoid concurrent syncs

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    if (!connectivityProvider.isConnected) {
      debugPrint('Cannot sync history: Offline');
      return;
    }

    _isSyncing = true;
      notifyListeners();
    debugPrint('Starting sync of unsynced local history');

    try {
      final localHistoryData = await _storageProvider.getHistory();
       // Filter for unsynced entries. Assume history entries are not deleted via sync.
      final unsyncedHistory = localHistoryData
          .where((entry) => 
              entry is Map<String, dynamic> && // Ensure it's a map
              !(entry['synced'] ?? true) && 
              _isValidHistoryData(entry) &&
              (entry['id'] is String && (entry['id'] as String).isNotEmpty) && // Ensure it has a valid ID
              (entry['userId'] is String && (entry['userId'] as String).isNotEmpty) // Ensure it has a valid User ID
          )
          .toList();

       debugPrint('Found ${unsyncedHistory.length} unsynced local history entries');

       for (final entryData in unsyncedHistory) {
         // Ensure entryData is map before processing
         if (entryData is Map<String, dynamic>) {
            final entryId = entryData['id'] as String?;
            final userId = entryData['userId'] as String?; // Assuming userId is part of history data

             if (entryId != null && entryId.isNotEmpty && userId != null && userId.isNotEmpty) {
                try {
                   // Save/update in Firebase
                  // Ensure the synced flag is true before sending
                  entryData['synced'] = true;
                  await _database.child('history').child(userId).child(entryId).set(entryData);
                  debugPrint('Synced history entry $entryId to Firebase for user $userId');
                  // Update local storage to mark as synced
                  await _storageProvider.saveHistory(entryData);
                  debugPrint('Updated local storage for history entry $entryId after sync');

    } catch (e) {
                  debugPrint('Error syncing history entry $entryId: $e. Will retry later.');
                  // If Firebase operation fails, keep unsynced flag as false to retry
                  entryData['synced'] = false;
                  await _storageProvider.saveHistory(entryData);
                   debugPrint('Marked history entry $entryId for retry after sync error');
                }
             } else {
                debugPrint('Unsynced history data missing ID or UserId: $entryData');
             }
         } else {
            debugPrint('Unsynced history data is not a map: $entryData');
         }
      }
       debugPrint('Sync of unsynced local history completed');

    } catch (e) {
       debugPrint('Error during syncUnsyncedHistory: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Method to trigger sync for both quizzes and history
  Future<void> syncAllData() async {
    if (_isSyncing) return;
    await syncUnsyncedQuizzes();
    await syncUnsyncedHistory();
  }

  // Method to fetch a single quiz by ID
  Future<Quiz?> getQuizById(String quizId) async {
    // Try fetching from the currently loaded quizzes first
    try {
      for (final quiz in _quizzes) {
        if (quiz.id == quizId) {
          debugPrint('Found quiz $quizId in loaded quizzes');
          return quiz;
        }
      }
    } catch (e) {
      debugPrint('Error searching loaded quizzes: $e');
      // Continue even if searching loaded quizzes fails
    }

    // Try fetching from local storage
    try {
      final localQuizzesData = await _storageProvider.getQuizzes();
      for (final dynamic data in localQuizzesData) {
        if (data is Map<String, dynamic> && data['id'] == quizId) {
          final quiz = _parseSingleQuiz(data);
          if (quiz != null) {
             debugPrint('Found quiz $quizId in local storage and parsed successfully');
             return quiz;
          } else {
            debugPrint('Failed to parse local quiz data for ID $quizId: $data');
          }
        }
      }
    } catch (e) {
       debugPrint('Error fetching from local storage: $e');
       // Continue even if local storage fetch fails
    }

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    // Try fetching from Firebase if connected
    if (connectivityProvider.isConnected) {
      try {
        debugPrint('Fetching quiz $quizId from Firebase');
        final snapshot = await _database.child('quizzes').child(quizId).get();
        if (snapshot.exists && snapshot.value != null) {
          final dynamicValue = snapshot.value;
           if (dynamicValue is Map<String, dynamic>) { // Ensure value is a map
             final quiz = _parseSingleQuiz(dynamicValue);
             if (quiz != null) {
               debugPrint('Found and parsed quiz $quizId from Firebase');
               // Save to local storage after fetching from Firebase
               final dataToSave = quiz.toJson();
               dataToSave['synced'] = true; // Mark as synced
               await _storageProvider.saveQuiz(dataToSave);
               debugPrint('Saved fetched quiz $quizId to local storage');
               return quiz;
             } else {
               debugPrint('Firebase quiz data found for ID $quizId is invalid or could not be parsed');
             }
           } else {
             debugPrint('Firebase quiz data found for ID $quizId is not a map: $dynamicValue');
           }
        }
      } catch (e) {
        debugPrint('Error fetching quiz $quizId from Firebase: $e');
      }
    }

    // Quiz not found anywhere
    debugPrint('Quiz $quizId not found locally or remotely');
    return null;
  }

  // Method to fetch a single quiz history entry by ID
  Future<QuizHistory?> getQuizHistoryEntryById(String entryId, String userId) async {
     // Try fetching from the currently loaded history first
     try {
      for (final entry in _quizHistory) {
        if (entry.id == entryId && entry.userId == userId) {
          debugPrint('Found history entry $entryId in loaded history');
          return entry;
        }
      }
    } catch (e) {
       debugPrint('Error searching loaded history: $e');
        // Continue even if searching loaded history fails
    }

    // Try fetching from local storage
    try {
      final localHistoryData = await _storageProvider.getHistory();
      for (final dynamic data in localHistoryData) {
        if (data is Map<String, dynamic> && data['id'] == entryId && data['userId'] == userId) {
          final entry = _parseSingleHistory(data);
          if (entry != null) {
             debugPrint('Found history entry $entryId in local storage and parsed successfully');
             return entry;
          } else {
            debugPrint('Failed to parse local history data for ID $entryId: $data');
          }
        }
      }
    } catch (e) {
       debugPrint('Error fetching from local history: $e');
        // Continue even if local storage fetch fails
    }

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    // Try fetching from Firebase if connected
    if (connectivityProvider.isConnected) {
      try {
        debugPrint('Fetching history entry $entryId from Firebase for user $userId');
        final snapshot = await _database.child('history').child(userId).child(entryId).get();
        if (snapshot.exists && snapshot.value != null) {
          final dynamicValue = snapshot.value;
           if (dynamicValue is Map<String, dynamic>) { // Ensure value is a map
             final entry = _parseSingleHistory(dynamicValue);
             if (entry != null) {
                debugPrint('Found and parsed history entry $entryId from Firebase');
                // Save to local storage after fetching from Firebase
               final dataToSave = entry.toJson();
               dataToSave['synced'] = true; // Mark as synced
               await _storageProvider.saveHistory(dataToSave);
                debugPrint('Saved fetched history entry $entryId to local storage');
               return entry;
             } else {
                debugPrint('Firebase history data found for ID $entryId is invalid or could not be parsed');
             }
           } else {
             debugPrint('Firebase history data found for ID $entryId is not a map: $dynamicValue');
           }
        }
      } catch (e) {
        debugPrint('Error fetching history entry $entryId from Firebase for user $userId: $e');
      }
    }

    // Entry not found anywhere
     debugPrint('History entry $entryId not found locally or remotely');
    return null;
  }

  // Method to fetch a single quiz by ID from local storage
  Future<Quiz?> getQuizByIdLocally(String quizId) async {
    try {
      final localQuizzesData = await _storageProvider.getQuizzes();
      for (final dynamic data in localQuizzesData) {
        if (data is Map<String, dynamic> && data['id'] == quizId) {
          final quiz = _parseSingleQuiz(data);
           if (quiz != null) {
              debugPrint('Found quiz $quizId in local storage and parsed successfully');
              return quiz;
           } else {
              debugPrint('Failed to parse local quiz data for ID $quizId: $data');
           }
        }
      }
    } catch (e) {
      debugPrint('Error fetching quiz by ID locally: $e');
    }
     // Quiz not found locally
     debugPrint('Quiz $quizId not found locally');
    return null; // Quiz not found locally or invalid data
  }

  // Method to fetch a single quiz history entry by ID from local storage
  Future<QuizHistory?> getQuizHistoryEntryLocally(String historyId) async {
    try {
      final localHistoryData = await _storageProvider.getHistory();
      for (final dynamic data in localHistoryData) {
        if (data is Map<String, dynamic> && data['id'] == historyId) {
          final entry = _parseSingleHistory(data);
          if (entry != null) {
             debugPrint('Found history entry $historyId in local storage and parsed successfully');
             return entry;
          } else {
             debugPrint('Failed to parse local history data for ID $historyId: $data');
          }
        }
      }
    } catch (e) {
       debugPrint('Error fetching history entry by ID locally: $e');
    }
    // History entry not found locally
    debugPrint('History entry $historyId not found locally');
    return null; // History entry not found locally or invalid data
  }

  // Method to update a quiz (local and sync) - Re-added this method
  Future<void> updateQuiz(Quiz updatedQuiz) async {
    _isLoading = true;
    _clearError();
      notifyListeners();

    final connectivityProvider = Provider.of<ConnectivityProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    try {
      final quizData = updatedQuiz.toJson();
      quizData['synced'] = false; // Mark as not synced initially
      await _storageProvider.saveQuiz(quizData);
      debugPrint('Quiz updated locally: ${updatedQuiz.id}');

      // Update local lists
      final index = _quizzes.indexWhere((q) => q.id == updatedQuiz.id);
      if (index != -1) {
        _quizzes[index] = updatedQuiz;
      }
      final myIndex = _myQuizzes.indexWhere((q) => q.id == updatedQuiz.id);
      if (myIndex != -1) {
        _myQuizzes[myIndex] = updatedQuiz;
      }
      notifyListeners();

      // Add to pending changes for sync
      final syncProvider = Provider.of<SyncProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      await syncProvider.addPendingChange('quizzes/${updatedQuiz.id}', quizData);
      debugPrint('Update action added to sync queue for quiz: ${updatedQuiz.id}');

      // If online, attempt immediate Firebase update (fire-and-forget)
      if (connectivityProvider.isConnected) {
        debugPrint('Attempting immediate Firebase update for quiz: ${updatedQuiz.id}');
        // Mark as synced before sending
        quizData['synced'] = true;
        _database.child('quizzes').child(updatedQuiz.id).set(quizData).then((_) {
          debugPrint('Quiz updated in Firebase: ${updatedQuiz.id}');
          // No need to update local storage here, sync will handle it
        }).catchError((e) {
          debugPrint('Error updating quiz in Firebase: $e. Will sync later.');
          // SyncProvider will handle retries
        });
      }

    } catch (e) {
      _setError('Failed to update quiz: ${e.toString()}');
    } finally {
      _isLoading = false;
      // notifyListeners(); // Already notified when updating local lists
    }
  }
}
