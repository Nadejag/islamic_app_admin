import 'app_role.dart';

class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.displayName,
  });

  final String uid;
  final String email;
  final AppRole role;
  final String displayName;
}
