import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

/// Premium paywall bottom sheet with blur background.
///
/// Call [PaywallSheet.show] when the user hits the free-tier limit.
/// The sheet presents a "Pro-план" offer with a CTA button.
class PaywallSheet extends StatelessWidget {
  const PaywallSheet({super.key});

  /// Shows the paywall as a modal bottom sheet with blur scrim.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) => const PaywallSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.85),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: gold.withValues(alpha: 0.3), width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle ──
              const _SheetHandle(),
              const SizedBox(height: 24),

              // ── Crown icon ──
              _CrownBadge(gold: gold),
              const SizedBox(height: 20),

              // ── Title ──
              Text(
                l.paywallTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              // ── Subtitle ──
              Text(
                l.paywallSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // ── Benefits ──
              _BenefitRow(
                icon: Icons.all_inclusive,
                text: l.paywallBenefit1,
              ),
              const SizedBox(height: 10),
              _BenefitRow(
                icon: Icons.speed_rounded,
                text: l.paywallBenefit2,
              ),
              const SizedBox(height: 10),
              _BenefitRow(
                icon: Icons.workspace_premium_outlined,
                text: l.paywallBenefit3,
              ),
              const SizedBox(height: 28),

              // ── CTA button ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to subscription screen in future.
                  },
                  child: Text(l.paywallCta),
                ),
              ),
              const SizedBox(height: 12),

              // ── Dismiss ──
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.paywallDismiss),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────── Sub-widgets ────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .onSurfaceVariant
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _CrownBadge extends StatelessWidget {
  const _CrownBadge({required this.gold});

  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gold, gold.withValues(alpha: 0.6)],
        ),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        size: 36,
        color: Color(0xFF1A1400),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 20, color: gold),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
