part of 'auth_bloc.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  const AuthState.authenticated({required User user})
      : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({String? errorMessage})
      : this(
          status: AuthStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

