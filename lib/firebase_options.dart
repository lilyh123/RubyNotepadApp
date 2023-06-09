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
    apiKey: 'AIzaSyBXrVoA7gml9drYkIjaiyfd6ymanwFsn74',
    appId: '1:6928825508:web:05e9f7b238dfb7361e7a31',
    messagingSenderId: '6928825508',
    projectId: 'ruby-a6706',
    authDomain: 'ruby-a6706.firebaseapp.com',
    storageBucket: 'ruby-a6706.appspot.com',
    measurementId: 'G-2XF39WPNTX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAG8vfJzkUk4NISNss2Nzoo-Dh-FetA6EY',
    appId: '1:6928825508:android:528d28e9a1f088b41e7a31',
    messagingSenderId: '6928825508',
    projectId: 'ruby-a6706',
    storageBucket: 'ruby-a6706.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDI9f-HSVbTuVZEYSClAI5FpBvaNirHXxM',
    appId: '1:6928825508:ios:7216d3d8f79998341e7a31',
    messagingSenderId: '6928825508',
    projectId: 'ruby-a6706',
    storageBucket: 'ruby-a6706.appspot.com',
    iosClientId: '6928825508-pq0cmuafaujm1gr17k5jsq29vjasj8qf.apps.googleusercontent.com',
    iosBundleId: 'com.example.myAppFlutter',
  );
}
