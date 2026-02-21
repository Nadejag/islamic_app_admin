import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBu99nV7rKHF8UN0iMLXeszcB2Qdrb0MpM',
        appId: '1:846589685394:web:aa1ffd9eb2e242d407404b',
        messagingSenderId: '846589685394',
        projectId: 'ask-islam-b1815',
        authDomain: 'ask-islam-b1815.firebaseapp.com',
        storageBucket: 'ask-islam-b1815.firebasestorage.app',
        measurementId: 'G-KFGX0K0TQ2',
      );
    }
    throw UnsupportedError('DefaultFirebaseOptions are not configured.');
  }
}
