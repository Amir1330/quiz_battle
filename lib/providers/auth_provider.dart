import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://quizzz-79fa5-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();
  User? _user;
  bool _isLoading = false;
  bool _initialized = false;

  User? get user => _auth.currentUser ?? _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _auth.currentUser != null;
  bool get isInitialized => _initialized;

  AuthProvider() {
    _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    debugPrint('Initializing AuthProvider...');
    
    try {
      // Set persistence to LOCAL to keep user logged in across app restarts
      await _auth.setPersistence(Persistence.LOCAL);
      
      // Check if a user is already signed in
      _user = _auth.currentUser;
      debugPrint('Initial auth state: ${_user != null ? 'Logged in as ${_user!.email}' : 'Not logged in'}');
      
      // Listen for auth state changes
      _auth.authStateChanges().listen((User? user) {
        debugPrint('Auth state changed: ${user != null ? 'Logged in as ${user.email}' : 'Not logged in'}');
        _user = user;
        _saveAuthState(user != null);
        notifyListeners();
      });
      
      // Force an extra check to ensure we have the latest auth state
      Future.delayed(const Duration(seconds: 1), () {
        final currentUser = _auth.currentUser;
        if (currentUser != null && (_user == null || currentUser.uid != _user!.uid)) {
          debugPrint('Auth state corrected: Logged in as ${currentUser.email}');
          _user = currentUser;
          _saveAuthState(true);
          notifyListeners();
        }
      });
      
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }
  
  // Helper method to save authentication state
  Future<void> _saveAuthState(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', isLoggedIn);
      debugPrint('Saved auth state: $isLoggedIn');
    } catch (e) {
      debugPrint('Error saving auth state: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        try {
          // Create user data in Realtime Database
          await _database.child('users/${userCredential.user!.uid}').set({
            'email': email,
            'createdAt': ServerValue.timestamp,
          });
          
          // Save auth state
          await _saveAuthState(true);
        } catch (dbError) {
          // If database operation fails, delete the created user
          await userCredential.user?.delete();
          throw 'Failed to create user profile. Please try again.';
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        default:
          message = 'An error occurred during registration: ${e.message}';
      }
      throw message;
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      debugPrint('Signing in user with email: $email');
      
      // Sign in user
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('Sign in successful for user: ${userCredential.user?.email}');

      // Verify user data exists in database
      if (userCredential.user != null) {
        final userData = await _database
            .child('users/${userCredential.user!.uid}')
            .get();
        
        if (!userData.exists) {
          // If user data doesn't exist, create it
          await _database.child('users/${userCredential.user!.uid}').set({
            'email': email,
            'createdAt': ServerValue.timestamp,
          });
        }
        
        // Save auth state
        await _saveAuthState(true);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase auth exception during sign in: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
        default:
          message = 'An error occurred during sign in: ${e.message}';
      }
      throw message;
    } catch (e) {
      debugPrint('Unexpected error during sign in: $e');
      throw 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _saveAuthState(false);
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error signing out: $e');
      throw 'An error occurred while signing out: $e';
    }
  }
} 