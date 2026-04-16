import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../chat/chat_controller.dart';

part 'dashboard_controller.g.dart';

/// Time-of-day period for localized greetings.
enum GreetingPeriod { night, morning, afternoon, evening }

/// Immutable snapshot of the dashboard's UI state.
class DashboardState {
  const DashboardState({
    required this.greetingPeriod,
    required this.displayName,
    required this.isOnline,
    required this.usedAiQueries,
    required this.maxAiQueries,
  });

  /// Period of day — resolved to a localized string in the UI layer.
  final GreetingPeriod greetingPeriod;

  /// The user's display name or email prefix.
  final String displayName;

  /// Whether the device currently has internet access.
  final bool isOnline;

  /// Number of AI queries used by the user.
  final int usedAiQueries;

  /// Maximum AI queries allowed on the free plan.
  final int maxAiQueries;
}

/// Manages the state of the Dashboard screen.
@riverpod
class DashboardController extends _$DashboardController {
  @override
  FutureOr<DashboardState> build() async {
    final isOnline = await _checkConnectivity();
    final greetingPeriod = _resolveGreetingPeriod();

    final user = ref.read(firebaseAuthProvider).currentUser;
    final displayName = _resolveDisplayName(user);

    // Watch the chat state to dynamically update query limits
    final chatState = ref.watch(chatControllerProvider);
    final maxQueries = ref.read(chatRepositoryProvider).maxFreeMessages;

    return DashboardState(
      greetingPeriod: greetingPeriod,
      displayName: displayName,
      isOnline: isOnline,
      usedAiQueries: (chatState.value ?? []).where((m) => m.isUser).length,
      maxAiQueries: maxQueries,
    );
  }

  /// Re-fetches the dashboard state (e.g. on pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final isOnline = await _checkConnectivity();
      final greetingPeriod = _resolveGreetingPeriod();

      final user = ref.read(firebaseAuthProvider).currentUser;
      final displayName = _resolveDisplayName(user);

      final chatState = ref.read(chatControllerProvider);
      final maxQueries = ref.read(chatRepositoryProvider).maxFreeMessages;

      return DashboardState(
        greetingPeriod: greetingPeriod,
        displayName: displayName,
        isOnline: isOnline,
        usedAiQueries: (chatState.value ?? []).where((m) => m.isUser).length,
        maxAiQueries: maxQueries,
      );
    });
  }

  // ────────────────── Private Helpers ──────────────────

  Future<bool> _checkConnectivity() async {
    if (kIsWeb) return true; // dart:io InternetAddress is unsupported on Web.

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 300));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  GreetingPeriod _resolveGreetingPeriod() {
    final hour = DateTime.now().hour;
    if (hour < 6) return GreetingPeriod.night;
    if (hour < 12) return GreetingPeriod.morning;
    if (hour < 18) return GreetingPeriod.afternoon;
    return GreetingPeriod.evening;
  }

  /// Extracts a user-friendly display name (no l10n — pure data).
  String _resolveDisplayName(User? user) {
    if (user == null) return '';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    // Fallback: email prefix before '@'.
    final email = user.email ?? '';
    final atIndex = email.indexOf('@');
    return atIndex > 0 ? email.substring(0, atIndex) : '';
  }
}
