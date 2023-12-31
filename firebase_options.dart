// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPLtnYhCLbhEB_ghq5EpMEH6qwoC3y8kU',
    appId: '1:937627572683:web:3bc27494c8bd05428b3e4e',
    messagingSenderId: '937627572683',
    projectId: 'barter-ff957',
    authDomain: 'barter-ff957.firebaseapp.com',
    storageBucket: 'barter-ff957.appspot.com',
    measurementId: 'G-6PDY488GN6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp0oe5jkIAr1bLDMQnNDsseNMMALMG_2Q',
    appId: '1:937627572683:android:2ab27351aee4e95c8b3e4e',
    messagingSenderId: '937627572683',
    projectId: 'barter-ff957',
    storageBucket: 'barter-ff957.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ-q9OxPhSvhTbkbbCmqVa6HLBPZGf2ig',
    appId: '1:937627572683:ios:8dda3427f6d5bc6c8b3e4e',
    messagingSenderId: '937627572683',
    projectId: 'barter-ff957',
    storageBucket: 'barter-ff957.appspot.com',
    iosBundleId: 'com.miumg.barter',
  );
}
