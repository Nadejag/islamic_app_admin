# ASK ISLAM Admin Panel (Flutter Web + Firebase)

Production-oriented admin dashboard scaffold for the ASK ISLAM ecosystem.

## Stack
- Flutter Web
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Cloud Functions (TypeScript)
- Firebase Hosting

## Quick Start
```bash
flutter pub get
flutter run -d chrome
```

## Firebase Setup
1. Create a Firebase project.
2. Enable Email/Password sign-in.
3. Add a Web app and generate `lib/firebase_options.dart` using FlutterFire CLI.
4. Deploy rules:
```bash
firebase deploy --only firestore:rules,storage:rules
```
5. Deploy functions:
```bash
cd firebase/functions
npm install
npm run build
firebase deploy --only functions
```

## Project Layout
- `lib/` Flutter app source
- `docs/` Firestore schema and architecture notes
- `firebase/` Rules, indexes, and cloud functions
