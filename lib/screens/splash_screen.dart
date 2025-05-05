import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizzz/providers/auth_provider.dart';
import 'package:quizzz/screens/home_screen.dart';
import 'package:quizzz/screens/auth/login_screen.dart';
import 'package:quizzz/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start checking auth state immediately
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    debugPrint('Checking authentication state...');
    
    // Check for saved login state first (fast path)
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      debugPrint('Last saved auth state: ${wasLoggedIn ? 'Logged in' : 'Not logged in'}');
    } catch (e) {
      debugPrint('Error reading saved auth state: $e');
    }
    
    // Wait a bit to ensure Firebase has time to initialize
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Continuously check auth state until it's initialized (max 10 seconds)
    int attempts = 0;
    while (!authProvider.isInitialized && attempts < 10) {
      debugPrint('Auth provider not yet initialized, waiting... (attempt ${attempts + 1})');
      await Future.delayed(const Duration(seconds: 1));
      attempts++;
      if (!mounted) return;
    }
    
    // Debug log to help troubleshoot auth issues
    debugPrint('Auth state: isAuthenticated=${authProvider.isAuthenticated}, user=${authProvider.user?.email}');
    
    if (authProvider.isAuthenticated) {
      debugPrint('User is authenticated, navigating to HomeScreen');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      debugPrint('User is not authenticated, navigating to LoginScreen');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
} 