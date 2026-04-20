import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/providers/subscription_provider.dart';

/// Admin emails with God Mode access.
const kAdminEmails = ['bimanovaliser@gmail.com'];

/// User Profile screen.
/// Premium UI utilizing Deep Black / Gold theme & Glassmorphism.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Current user from Firebase
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final isGuest = user == null;

    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.profileTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/app/profile/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          // ── Avatar & Info ──
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: gold.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gold.withValues(alpha: 0.2),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                          isGuest ? l.profileGuestInitial : (user.displayName?.isNotEmpty == true ? user.displayName![0] : 'U'),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: gold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? (isGuest ? l.profileGuest : l.profileUser),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? l.profileGuestEmail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── Reactive Subscription Card ──
          _SubscriptionCard(ref: ref, gold: gold, theme: theme, l: l),
          const SizedBox(height: 32),

          // ── Menu Items Group ──
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.folder_shared_outlined,
                  title: l.profileMyDocuments,
                  onTap: () => context.push('/app/profile/documents'),
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _MenuTile(
                  icon: Icons.history_rounded,
                  title: l.profileHistory,
                  onTap: () => context.push('/app/profile/history'),
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _MenuTile(
                  icon: Icons.payment_rounded,
                  title: l.profileSubscription,
                  onTap: () => context.push('/subscription'),
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _MenuTile(
                  icon: Icons.help_outline_rounded,
                  title: l.profileSupport,
                  onTap: () => context.push('/app/profile/support'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Admin Panel (God Mode) ──
          if (!isGuest && kAdminEmails.contains(user.email)) ...[
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                ),
              ),
              child: _MenuTile(
                icon: Icons.admin_panel_settings,
                title: 'Панель управления',
                iconColor: Colors.redAccent,
                onTap: () => context.push('/admin'),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // ── Auth Action Button ──
          if (isGuest)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: gold,
                foregroundColor: const Color(0xFF1A1400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.login_rounded),
              label: Text(
                l.profileLogin,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () => context.go('/auth'),
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l.profileLogout),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
            ),
            
          const SizedBox(height: 100), // Spacing for BottomNav
        ],
      ),
    );
  }
}

// ────────────────────── Components ──────────────────────

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.ref,
    required this.gold,
    required this.theme,
    required this.l,
  });

  final WidgetRef ref;
  final Color gold;
  final ThemeData theme;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionControllerProvider);
    final sub = subAsync.value;
    final isPaid = sub?.isPaid ?? false;

    final planLabel = switch (sub?.plan) {
      SubscriptionPlan.pro => 'PRO',
      SubscriptionPlan.business => 'BUSINESS',
      _ => l.profileBasicPlan,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isPaid
                  ? [
                      gold.withValues(alpha: 0.15),
                      gold.withValues(alpha: 0.05),
                    ]
                  : [
                      theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
                      theme.colorScheme.surfaceContainer.withValues(alpha: 0.6),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: gold.withValues(alpha: isPaid ? 0.6 : 0.3),
              width: isPaid ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.workspace_premium_rounded, size: 40, color: gold),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isPaid ? gold : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (!isPaid && sub != null)
                      Text(
                        'Осталось запросов: ${sub.remaining} из ${sub.maxQueries}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (isPaid)
                      Text(
                        'Безлимитный доступ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isPaid)
                GestureDetector(
                  onTap: () => context.push('/subscription'),
                  child: _PulsingGoldButton(label: l.profileUpgrade),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

class _PulsingGoldButton extends StatefulWidget {
  const _PulsingGoldButton({required this.label});
  final String label;

  @override
  State<_PulsingGoldButton> createState() => _PulsingGoldButtonState();
}

class _PulsingGoldButtonState extends State<_PulsingGoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {},
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xFF1A1400),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
