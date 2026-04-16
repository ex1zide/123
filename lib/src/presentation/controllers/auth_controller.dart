import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

/// Manages the authentication lifecycle (sign-in, sign-up, sign-out).
///
/// Exposed as an [AsyncNotifier] so the UI can react to three states:
/// - **loading** → show shimmer / spinner (Doherty Threshold compliance).
/// - **data**    → operation succeeded, navigate away.
/// - **error**   → display localised error message.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // No-op: initial state is `AsyncData<void>(null)`.
  }

  // ────────────────── Public Commands ──────────────────

  /// Sign in with email & password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
    });
  }

  /// Create a new account with email & password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
            email: email,
            password: password,
          );
    });
  }

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    });
  }

  /// Send a password-reset email.
  Future<void> sendPasswordResetEmail({required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .sendPasswordResetEmail(email: email);
    });
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }

  // ────────────────── Helpers ──────────────────

  /// Formats a [FirebaseAuthException] into a user-friendly message.
  static String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'email-already-in-use' => 'Этот email уже зарегистрирован.',
        'invalid-email' => 'Некорректный формат email.',
        'user-not-found' => 'Пользователь не найден. Пожалуйста, зарегистрируйтесь.',
        'invalid-credential' => 'Неверный пароль.',
        'wrong-password' => 'Неверный пароль.',
        'weak-password' => 'Пароль слишком простой.',
        'too-many-requests' => 'Слишком много попыток. Попробуйте позже.',
        'network-request-failed' => 'Проверьте подключение к интернету.',
        _ => error.message ?? 'Произошла ошибка авторизации.',
      };
    }
    return 'Неизвестная ошибка. Повторите попытку.';
  }
}
