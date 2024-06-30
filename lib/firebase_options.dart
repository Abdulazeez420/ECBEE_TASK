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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDtPv4-jSGOp6L8HDIcVetFP92ZXSpi4Co',
    appId: '1:682673718229:web:ef4d1f2fa0a74c8b18735c',
    messagingSenderId: '682673718229',
    projectId: 'ecbeetest',
    authDomain: 'ecbeetest.firebaseapp.com',
    storageBucket: 'ecbeetest.appspot.com',
    measurementId: 'G-YZTQRVGEQQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLmDqHSSUf7otpxSicZTno8ANUU2c3Cuk',
    appId: '1:682673718229:android:801edb1f0b91e63918735c',
    messagingSenderId: '682673718229',
    projectId: 'ecbeetest',
    storageBucket: 'ecbeetest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKbFD8Nyr-kWFlACAAXod33EZvHh9422E',
    appId: '1:682673718229:ios:c97d1b57a30604b418735c',
    messagingSenderId: '682673718229',
    projectId: 'ecbeetest',
    storageBucket: 'ecbeetest.appspot.com',
    iosBundleId: 'com.example.ecbeeTestApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKbFD8Nyr-kWFlACAAXod33EZvHh9422E',
    appId: '1:682673718229:ios:c97d1b57a30604b418735c',
    messagingSenderId: '682673718229',
    projectId: 'ecbeetest',
    storageBucket: 'ecbeetest.appspot.com',
    iosBundleId: 'com.example.ecbeeTestApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDtPv4-jSGOp6L8HDIcVetFP92ZXSpi4Co',
    appId: '1:682673718229:web:f3f85b9b85459f5918735c',
    messagingSenderId: '682673718229',
    projectId: 'ecbeetest',
    authDomain: 'ecbeetest.firebaseapp.com',
    storageBucket: 'ecbeetest.appspot.com',
    measurementId: 'G-WH0SQDXS2L',
  );
}
