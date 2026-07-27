import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXk9SpM46qSoJVm18vtwyxqN75D2RpAZg',
    appId: '1:274620698968:android:7fb53ccd5a95c098e5552d',
    messagingSenderId: '274620698968',
    projectId: 'fir-791ec',
    storageBucket: 'fir-791ec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXk9SpM46qSoJVm18vtwyxqN75D2RpAZg',
    appId: '1:274620698968:ios:placeholder',
    messagingSenderId: '274620698968',
    projectId: 'fir-791ec',
    storageBucket: 'fir-791ec.firebasestorage.app',
    iosBundleId: 'com.voiceclub.rumour',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAXk9SpM46qSoJVm18vtwyxqN75D2RpAZg',
    appId: '1:274620698968:web:placeholder',
    messagingSenderId: '274620698968',
    projectId: 'fir-791ec',
    storageBucket: 'fir-791ec.firebasestorage.app',
  );
}
