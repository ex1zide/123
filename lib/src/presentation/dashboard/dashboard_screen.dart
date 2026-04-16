import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

import '../widgets/shimmer_placeholder.dart';
import 'dashboard_controller.dart';
import 'widgets/ai_search_bar.dart';
import 'widgets/quick_actions_grid.dart';
import '../../data/providers/network_provider.dart';

/// Main Dashboard screen.
/// Designed for high performance (sub-400ms loading) using Slivers
/// and Material 3 Expressive aesthetics.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      body: switch (dashboardState) {
        AsyncData(:final value) => _DashboardBody(state: value),
        AsyncError(:final error, :final stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SelectableText(
                'Ошибка загрузки!\n\nДетали: $error\n\nСтек трассировки:\n$stackTrace',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          ),
        _ => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary, // Gold color
            ),
          ),
      },
    );
  }
}



// Re-write _DashboardBody as ConsumerWidget to support RefreshIndicator
class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.state});
  final DashboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(networkStatusProvider);
    final l = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(l.dashboardTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isOnline
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[900]?.withValues(alpha: 0.9),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.red[400]!.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l.dashboardOfflineBanner,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: _GreetingSection(
              greetingPeriod: state.greetingPeriod,
              displayName: state.displayName,
              usedQueries: state.usedAiQueries,
              maxQueries: state.maxAiQueries,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: AiSearchBar(
              onTap: () => context.go('/app/chat'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l.dashboardSectionUrgent,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: QuickActionsGrid()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l.dashboardSectionAdvice,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: _AdviceCarousel()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l.dashboardSectionActivity,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const _RecentActivityList(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ────────────────────── Components ──────────────────────

/// Resolves [GreetingPeriod] enum to a localized greeting string.
String _resolveGreeting(AppLocalizations l, GreetingPeriod period) {
  switch (period) {
    case GreetingPeriod.night:
      return l.dashboardGreetingNight;
    case GreetingPeriod.morning:
      return l.dashboardGreetingMorning;
    case GreetingPeriod.afternoon:
      return l.dashboardGreetingAfternoon;
    case GreetingPeriod.evening:
      return l.dashboardGreetingEvening;
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({
    required this.greetingPeriod,
    required this.displayName,
    required this.usedQueries,
    required this.maxQueries,
  });

  final GreetingPeriod greetingPeriod;
  final String displayName;
  final int usedQueries;
  final int maxQueries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;
    final int available = (maxQueries - usedQueries).clamp(0, maxQueries);
    final double progress = available / maxQueries;
    final name = displayName.isEmpty ? l.dashboardUser : displayName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resolveGreeting(l, greetingPeriod),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.dashboardSubtitle(name),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          // AI Plan stats wrapper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: gold.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 18, color: gold),
                        const SizedBox(width: 8),
                        Text(
                          l.dashboardFreePlan,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: gold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      l.dashboardAvailable(available, maxQueries),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(gold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceCarousel extends StatelessWidget {
  const _AdviceCarousel();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final tips = [
      {
        'title': l.adviceTitle1,
        'subtitle': l.adviceSubtitle1,
        'icon': Icons.edit_document,
      },
      {
        'title': l.adviceTitle2,
        'subtitle': l.adviceSubtitle2,
        'icon': Icons.directions_car_rounded,
      },
      {
        'title': l.adviceTitle3,
        'subtitle': l.adviceSubtitle3,
        'icon': Icons.shopping_bag_rounded,
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final tip = tips[index];
          final theme = Theme.of(context);
          final gold = theme.colorScheme.primary;

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
                      theme.colorScheme.surface.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: gold.withValues(alpha: 0.1),
                    highlightColor: gold.withValues(alpha: 0.05),
                    onTap: () => context.push('/app/dashboard/advice/$index', extra: tip),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'icon_advice_$index',
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                tip['icon'] as IconData,
                                color: gold,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Hero(
                            tag: 'title_advice_$index',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                tip['title'] as String,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tip['subtitle'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // Using SliverList directly avoids nesting list view in sliver list builder.
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Mock dynamic items
            final isCompleted = index % 2 == 0;
            return _ActivityTile(
              title: index == 0 ? l.activityConsultation : l.activityContractAnalysis,
              date: index == 0 ? l.activityToday : l.activityYesterday,
              isCompleted: isCompleted,
              onTap: () => context.go(index == 0 ? '/app/marketplace' : '/app/chat'),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.date,
    required this.isCompleted,
    required this.onTap,
  });

  final String title;
  final String date;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                    color: isCompleted ? Colors.greenAccent[400] : Colors.orangeAccent[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardLoadingSkeleton extends StatelessWidget {
  const _DashboardLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 60),
          ShimmerPlaceholder(height: 30, width: 200),
          SizedBox(height: 16),
          ShimmerPlaceholder(height: 100, borderRadius: 16),
          SizedBox(height: 32),
          ShimmerPlaceholder(height: 60, borderRadius: 30),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: ShimmerPlaceholder(height: 120, borderRadius: 20)),
              SizedBox(width: 16),
              Expanded(child: ShimmerPlaceholder(height: 120, borderRadius: 20)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            const SizedBox(height: 16),
            Text(
              l.dashboardErrorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {}, // Handled by Riverpod refresh outside
              icon: const Icon(Icons.refresh),
              label: Text(l.dashboardRetry),
            ),
          ],
        ),
      ),
    );
  }
}
