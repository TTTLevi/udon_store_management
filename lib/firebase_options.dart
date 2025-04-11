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
    apiKey: 'AIzaSyBVU2TNVRl1qGo3Y21mr5NHBWmhjOPQENk',
    appId: '1:369059237530:web:b496ef9e9cd6faff6a5923',
    messagingSenderId: '369059237530',
    projectId: 'udon-9d68c',
    authDomain: 'udon-9d68c.firebaseapp.com',
    storageBucket: 'udon-9d68c.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsSxp5gYUNwy35MSkpJzaVErI9W2kkx3Y',
    appId: '1:369059237530:android:f37e39ddc09cdcdb6a5923',
    messagingSenderId: '369059237530',
    projectId: 'udon-9d68c',
    storageBucket: 'udon-9d68c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClEOHM7U53u_df_PiT47o2UO8vobTlscQ',
    appId: '1:369059237530:ios:851f5a4e7c75b2bb6a5923',
    messagingSenderId: '369059237530',
    projectId: 'udon-9d68c',
    storageBucket: 'udon-9d68c.firebasestorage.app',
    iosBundleId: 'com.example.doAnCk',
  );
}
