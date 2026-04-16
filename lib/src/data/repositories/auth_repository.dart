import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// Provides the singleton [FirebaseAuth] instance.
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

/// Provides a live [Stream] of [User?] changes.
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

/// Repository that wraps all Firebase Auth operations.
///
/// Exposed as a Riverpod provider so every layer can depend on it
/// without tight coupling. All methods are `Future`-based and propagate
/// [FirebaseAuthException] on failure — callers decide how to handle errors.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  // ─────────────────────── Queries ───────────────────────

  /// The currently signed-in user, or `null`.
  User? get currentUser => _auth.currentUser;

  /// Whether a user is currently signed in.
  bool get isAuthenticated => currentUser != null;

  /// A broadcast stream of authentication state changes.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // ─────────────────── Email / Password ───────────────────

  /// Creates a new user with [email] and [password].
  ///
  /// Returns the [UserCredential] upon success.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs in an existing user with [email] and [password].
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs in using Google OAuth via Firebase SDK natively for all platforms.
  Future<UserCredential> signInWithGoogle() async {
    // Note: To successfully redirect, Firebase configuration requires Google Sign-In enabled.
    return _auth.signInWithProvider(GoogleAuthProvider());
  }

  // ──────────────────── Password Reset ────────────────────

  /// Sends a password-reset email to [email].
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ───────────────────── Sign Out ─────────────────────────

  /// Signs the current user out of all auth providers.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
