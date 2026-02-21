import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_role.dart';
import 'auth_user.dart';

class AuthService {
  AuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      // Role-free mode: any authenticated account can access admin panel.
      // If a role doc exists, it can still be read; otherwise defaults to super_admin.
      final adminDoc = await _firestore.collection('admins').doc(user.uid).get();
      final role = AppRole.fromString(adminDoc.data()?['role'] as String?) ??
          AppRole.superAdmin;
      return AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        role: role,
        displayName: user.displayName ?? 'Admin',
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (name.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(name.trim());
    }
  }

  Future<void> sendResetLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
