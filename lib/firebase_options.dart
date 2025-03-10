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
    apiKey: 'AIzaSyBn4XjPC1iySa2ghVTHJ1vwro9b0UWnhBI',
    appId: '1:278173759000:web:9b9c0a8824a0a02c26356d',
    messagingSenderId: '278173759000',
    projectId: 'instagram-408cf',
    authDomain: 'instagram-408cf.firebaseapp.com',
    storageBucket: 'instagram-408cf.firebasestorage.app',
    measurementId: 'G-K1T18STLEX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXs4iwCSzbbisVdR_mD-2ca8wNhum0wfQ',
    appId: '1:278173759000:android:a09cfc83147ea37c26356d',
    messagingSenderId: '278173759000',
    projectId: 'instagram-408cf',
    storageBucket: 'instagram-408cf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5lLnFLqvt2RWu1KGO-jtwTXgpAf5zX10',
    appId: '1:278173759000:ios:d2bba97a7855489a26356d',
    messagingSenderId: '278173759000',
    projectId: 'instagram-408cf',
    storageBucket: 'instagram-408cf.firebasestorage.app',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5lLnFLqvt2RWu1KGO-jtwTXgpAf5zX10',
    appId: '1:278173759000:ios:d2bba97a7855489a26356d',
    messagingSenderId: '278173759000',
    projectId: 'instagram-408cf',
    storageBucket: 'instagram-408cf.firebasestorage.app',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBn4XjPC1iySa2ghVTHJ1vwro9b0UWnhBI',
    appId: '1:278173759000:web:67a25ea4deb5bab926356d',
    messagingSenderId: '278173759000',
    projectId: 'instagram-408cf',
    authDomain: 'instagram-408cf.firebaseapp.com',
    storageBucket: 'instagram-408cf.firebasestorage.app',
    measurementId: 'G-86N79JBCNP',
  );
}
