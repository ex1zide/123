import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:app/l10n/app_localizations.dart';

import '../../../data/providers/subscription_provider.dart';

/// Premium Subscription Management Screen.
///
/// Deep Black + Gold + Glassmorphism design.
/// Reads and writes subscription state via [SubscriptionController].
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;
    final subState = ref.watch(subscriptionControllerProvider);

    final currentPlan = subState.value?.plan ?? SubscriptionPlan.free;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.subTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── PRO Badge ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    gold.withValues(alpha: 0.3),
                    gold.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(Icons.workspace_premium_rounded, size: 60, color: gold),
            ),
            const SizedBox(height: 16),

            Text(
              l.subChoosePlan,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.subDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // ── Free Plan ──
            _PlanCard(
              title: 'Free',
              price: '0 ₸',
              period: l.subPerMonth,
              features: [
                l.subFreeFeat1,
                l.subFreeFeat2,
                l.subFreeFeat3,
              ],
              isActive: currentPlan == SubscriptionPlan.free,
              isPro: false,
              onPressed: () {},
            ),
            const SizedBox(height: 16),

            // ── Pro Plan ──
            _PlanCard(
              title: 'Pro',
              price: '4 990 ₸',
              period: l.subPerMonth,
              features: [
                l.subProFeat1,
                l.subProFeat2,
                l.subProFeat3,
                l.subProFeat4,
              ],
              isActive: currentPlan == SubscriptionPlan.pro,
              isPro: true,
              onPressed: () async {
                // Call server-side upgrade (payment gateway placeholder)
                try {
                  final callable = FirebaseFunctions.instance.httpsCallable('upgradePlan');
                  await callable.call({'plan': 'pro'});
                } catch (_) {
                  // Payment gateway not yet configured
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.subPaymentInDev)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // ── Business Plan ──
            _PlanCard(
              title: 'Business',
              price: '29 990 ₸',
              period: l.subPerMonth,
              features: [
                l.subBizFeat1,
                l.subBizFeat2,
                l.subBizFeat3,
                l.subBizFeat4,
              ],
              isActive: currentPlan == SubscriptionPlan.business,
              isPro: false,
              isBusiness: true,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.subB2bInDev)),
                );
              },
            ),
            const SizedBox(height: 40), // Extra bottom padding for safe scrolling
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isActive,
    required this.isPro,
    this.isBusiness = false,
    required this.onPressed,
  });

  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isActive;
  final bool isPro;
  final bool isBusiness;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isPro
                ? const Color(0xFF0D0D0D)
                : isBusiness
                    ? const Color(0xFF1A1A1A)
                    : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPro ? gold : Colors.white.withValues(alpha: 0.1),
              width: isPro ? 2 : 1,
            ),
            boxShadow: isPro
                ? [
                    BoxShadow(
                      color: gold.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 4,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isPro || isBusiness ? gold : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (isPro)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.subRecommended,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      period,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Features list
              ...features.map((feat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 18,
                      color: isPro || isBusiness ? gold : Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feat,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isPro ? Colors.grey[300] : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              
              // Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive
                        ? Colors.white.withValues(alpha: 0.1)
                        : (isPro ? gold : Colors.white.withValues(alpha: 0.05)),
                    foregroundColor: isActive
                        ? theme.colorScheme.onSurfaceVariant
                        : (isPro ? const Color(0xFF1A1400) : theme.colorScheme.onSurface),
                    elevation: isPro && !isActive ? 8 : 0,
                    shadowColor: gold.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isActive
                            ? Colors.transparent
                            : (isPro ? gold : Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                  onPressed: isActive ? null : onPressed,
                  child: Text(
                    isActive ? l.subCurrentPlan : l.subUpgrade,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
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
