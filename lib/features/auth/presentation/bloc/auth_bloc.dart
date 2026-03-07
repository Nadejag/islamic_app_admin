import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  final AuthRepository _repository;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    await emit.forEach<AuthState>(
      _repository.authStateChanges().asyncMap(_resolveAuthState),
      onData: (nextState) => nextState,
      onError: (error, stackTrace) => const AuthState.unauthenticated(
        errorMessage: 'Unable to verify session. Please sign in again.',
      ),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.email.trim().isEmpty || event.password.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Email and password are required.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _repository.signIn(email: event.email, password: event.password);
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: _repository.mapAuthError(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Unable to sign in right now. Please try again.',
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.signOut();
    emit(const AuthState.unauthenticated());
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    if (state.errorMessage == null) return;
    emit(state.copyWith(errorMessage: null));
  }

  Future<AuthState> _resolveAuthState(User? user) async {
    if (user == null) {
      return const AuthState.unauthenticated();
    }

    final admin = await _repository.isAdmin(user.uid);
    if (admin) {
      return AuthState.authenticated(user: user);
    }

    await _repository.signOut();
    return const AuthState.unauthenticated(
      errorMessage: 'Your account is not authorized for admin access.',
    );
  }
}

