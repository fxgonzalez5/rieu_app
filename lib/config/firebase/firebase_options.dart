// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_sZxBq4vVxGPWs9MqdeV6GAPhvwdGiz0',
    appId: '1:752767528985:android:8905e9f8b572f26d28fa88',
    messagingSenderId: '752767528985',
    projectId: 'app-liid-9ede6',
    storageBucket: 'app-liid-9ede6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-N8Zn0wSq2h78CFRGJMwb6kvvQ_LHP18',
    appId: '1:752767528985:ios:45fca2b41e894d2c28fa88',
    messagingSenderId: '752767528985',
    projectId: 'app-liid-9ede6',
    storageBucket: 'app-liid-9ede6.appspot.com',
    androidClientId: '752767528985-d9l186mufrqj8ekgckhdtju5rohua0ui.apps.googleusercontent.com',
    iosClientId: '752767528985-7dkaj9li1v6fh1c6mu32u2p33scprvo0.apps.googleusercontent.com',
    iosBundleId: 'com.utpl.rieu',
  );

}