import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../chat/chat_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/scanner_screen.dart';
import '../dashboard/advice_detail_screen.dart';
import '../screens/marketplace/marketplace_screen.dart';
import '../dashboard/sos_screen.dart';
import '../screens/profile/documents_screen.dart';
import '../screens/profile/history_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/subscription_screen.dart';
import '../screens/profile/support_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../shell/app_shell.dart';
import '../../data/providers/app_startup_provider.dart';

part 'app_router.g.dart';

// ────────────────────── Route Paths ──────────────────────

abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String dashboard = '/app/dashboard';
  static const String chat = '/app/chat';
  static const String marketplace = '/app/marketplace';
  static const String profile = '/app/profile';
  static const String settings = '/app/profile/settings';
  static const String documents = '/app/profile/documents';
  static const String history = '/app/profile/history';
  static const String subscription = '/subscription';
  static const String support = '/app/profile/support';
  static const String scanner = '/app/dashboard/scanner';
  static const String sos = '/app/dashboard/sos';
}

// ────────────────────── GoRouter Provider ──────────────────────

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final startupState = ref.watch(appStartupProvider);

  if (startupState.isLoading || startupState.hasError) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
      ],
    );
  }

  final authRepo = ref.read(authRepositoryProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges()),
    redirect: (BuildContext context, GoRouterState state) {
      final isSplashRoute = state.matchedLocation == AppRoutes.splash;
      final isAuthenticated = authRepo.isAuthenticated;
      final isAuthRoute = state.matchedLocation == AppRoutes.auth;

      if (isSplashRoute) {
        return isAuthenticated ? AppRoutes.dashboard : AppRoutes.auth;
      }

      // If user is NOT logged in and trying to access anything other than auth, redirect to auth.
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.auth;
      }
      
      // If user IS logged in and trying to see auth, send them to dashboard.
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.dashboard;
      }
      
      return null;
    },
    routes: [

      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      // Full-screen subscription (outside ShellRoute — no BottomNav)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'scanner',
                    builder: (context, state) => const ScannerScreen(),
                  ),
                  GoRoute(
                    path: 'sos',
                    builder: (context, state) => const SosScreen(),
                  ),
                  GoRoute(
                    path: 'advice/:id',
                    builder: (context, state) {
                      final tip = state.extra as Map<String, dynamic>;
                      return AdviceDetailScreen(
                        id: state.pathParameters['id']!,
                        title: tip['title'] as String,
                        subtitle: tip['subtitle'] as String,
                        icon: tip['icon'] as IconData,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: AI Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chat,
                name: 'chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          // Branch 2: Marketplace
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.marketplace,
                name: 'marketplace',
                builder: (context, state) => const MarketplaceScreen(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'documents',
                    builder: (context, state) => const DocumentsScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const HistoryScreen(),
                  ),

                  GoRoute(
                    path: 'support',
                    builder: (context, state) => const SupportScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ────────────────────── Refresh Stream ──────────────────────

/// Converts a [Stream] into a [ChangeNotifier] so it can be passed to [GoRouter.refreshListenable].
/// This ensures the router automatically redirects whenever the Firebase auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
