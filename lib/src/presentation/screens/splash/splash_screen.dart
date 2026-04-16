import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/app_startup_provider.dart';

/// Instantly rendered completely Sync UI screen shielding heavy Async initializations.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    // Continuous smooth breathing animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    final startupState = ref.watch(appStartupProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Deep Black
      body: Center(
        child: startupState.hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 64),
                  const SizedBox(height: 24),
                  Text(
                    'Сбой инициализации',
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      startupState.error.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: const Color(0xFF0F0F0F),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Перезапустить платформу'),
                    onPressed: () {
                      ref.invalidate(appStartupProvider);
                    },
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            // Breathing Logo
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold.withValues(alpha: 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: gold.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: _pulseAnim.value * 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.balance_rounded, size: 80, color: gold),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // Text
            Text(
              'LEGALHELP KZ',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ваш карманный адвокат 24/7',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: gold.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 64),
            // Tiny loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
