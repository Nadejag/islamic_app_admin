import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC2CcDqcCWTZ1TXMr_GmktL3m9p4WjwiFU',
    appId: '1:439965580981:web:e50fa7bcdb8dc5ee2148fc',
    messagingSenderId: '439965580981',
    projectId: 'ask-islam-admin',
    authDomain: 'ask-islam-admin.firebaseapp.com',
    storageBucket: 'ask-islam-admin.firebasestorage.app',
  );
}
