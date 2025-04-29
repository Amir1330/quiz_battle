import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS platform is not configured');
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJt86W_SorGP9pyJYJKYOfI6rhPsHdsd0',
    appId: '1:107586422279:android:6a7da759c4922af9a60ca2',
    messagingSenderId: '107586422279',
    projectId: 'quizbattle-578b8',
    storageBucket: 'quizbattle-578b8.firebasestorage.app',
  );
}
