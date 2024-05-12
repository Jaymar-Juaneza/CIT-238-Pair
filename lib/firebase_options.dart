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
    apiKey: 'AIzaSyBd_iPNhGRZxJBj65Cdz7jQ0D6fXrlue2Q',
    appId: '1:761329386028:android:c803b230ae1a30b997c789',
    messagingSenderId: '761329386028',
    projectId: 'wvsu-locator',
    databaseURL: 'https://wvsu-locator-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wvsu-locator.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgxAXq8oOxyRiTV_ipIWjLy04xX0Mntgc',
    appId: '1:761329386028:ios:a223e126969b1c9897c789',
    messagingSenderId: '761329386028',
    projectId: 'wvsu-locator',
    databaseURL: 'https://wvsu-locator-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wvsu-locator.appspot.com',
    iosBundleId: 'com.example.googleMapApp',
  );
}
