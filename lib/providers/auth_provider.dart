import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_board/services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false,this.errorMessage});
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> signUp(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await ref.read(authServiceProvider).signUp(email, password);
      state = AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await ref.read(authServiceProvider).signIn(email, password);
      state = AuthState();
    } on FirebaseAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

// Access to Auth Service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth service auth state watch
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
