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
    apiKey: 'AIzaSyBO75WlQWXYDkeAaTg4DRLFI6cBUN8nrAE',
    appId: '1:809524140464:android:8df83616798acf9069de75',
    messagingSenderId: '809524140464',
    projectId: 'biomatricapp-6bd17',
    databaseURL: 'https://biomatricapp-6bd17-default-rtdb.firebaseio.com',
    storageBucket: 'biomatricapp-6bd17.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJNc129UyIN1ownnOZiJhM049dCg7GJ00',
    appId: '1:809524140464:ios:5b01a428169c689669de75',
    messagingSenderId: '809524140464',
    projectId: 'biomatricapp-6bd17',
    databaseURL: 'https://biomatricapp-6bd17-default-rtdb.firebaseio.com',
    storageBucket: 'biomatricapp-6bd17.firebasestorage.app',
    iosBundleId: 'com.app.app',
  );
}
