import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

/// Admin Panel — restricted to authorized admin emails.
///
/// Allows managing user subscription plans via Firestore Admin SDK path.
/// Deep Black background with red/gold warning aesthetics.
class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  final _uidController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _assignPlan(String plan) async {
    final uid = _uidController.text.trim();
    if (uid.isEmpty) {
      setState(() {
        _statusMessage = 'Введите User ID';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final limits = {
        'free': 10,
        'pro': 999999,
        'business': 999999,
      };

      await FirebaseFirestore.instance
          .doc('users/$uid/subscription/status')
          .set({
        'plan': plan,
        'usedQueries': 0,
        'maxQueries': limits[plan] ?? 10,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        _statusMessage = '✅ План "$plan" назначен для $uid';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Ошибка: $e';
        _isError = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.redAccent.shade100),
            const SizedBox(width: 8),
            const Text('Зона Администратора'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Warning banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.redAccent, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Административная панель. Все действия логируются.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.redAccent.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Glassmorphic content card
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withValues(alpha: 0.04),
                      border: Border.all(
                        color: gold.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Управление подпиской пользователя',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // UID input
                        TextField(
                          controller: _uidController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'User ID (из Firebase Auth)',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            prefixIcon: Icon(Icons.person_outline,
                                color: gold.withValues(alpha: 0.7)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: gold.withValues(alpha: 0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: gold.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: gold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Plan buttons
                        if (_isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(gold),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: _PlanButton(
                                  label: 'FREE',
                                  color: Colors.grey,
                                  onPressed: () => _assignPlan('free'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _PlanButton(
                                  label: 'PRO',
                                  color: gold,
                                  onPressed: () => _assignPlan('pro'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _PlanButton(
                                  label: 'BIZ',
                                  color: Colors.deepPurple,
                                  onPressed: () => _assignPlan('business'),
                                ),
                              ),
                            ],
                          ),

                        // Status feedback
                        if (_statusMessage != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _isError
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : Colors.green.withValues(alpha: 0.1),
                              border: Border.all(
                                color: _isError
                                    ? Colors.redAccent.withValues(alpha: 0.3)
                                    : Colors.greenAccent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _statusMessage!,
                              style: TextStyle(
                                color: _isError
                                    ? Colors.redAccent.shade100
                                    : Colors.greenAccent.shade100,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: color.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
