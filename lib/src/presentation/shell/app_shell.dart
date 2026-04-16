import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

/// AppShell wraps the main application routes and provides a persistent
/// bottom navigation bar.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      extendBody: true, // Needed for glassmorphism nav bar
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
              border: Border(
                top: BorderSide(
                  color: gold.withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              backgroundColor: Colors.transparent,
              indicatorColor: gold.withValues(alpha: 0.2),
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_filled, color: gold),
                  label: l.navHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.smart_toy_outlined),
                  selectedIcon: Icon(Icons.smart_toy_rounded, color: gold),
                  label: l.navAiLawyer,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.gavel_outlined),
                  selectedIcon: Icon(Icons.gavel_rounded, color: gold),
                  label: l.navLawyers,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded, color: gold),
                  label: l.navProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
