import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

import '../../widgets/shimmer_placeholder.dart';
import 'marketplace_controller.dart';

/// Lawyer Marketplace screen.
///
/// Displays real-time updates from Firebase Firestore.
/// Employs Glassmorphism and Deep Gold premium designs.
class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  String _selectedFilter = 'all';

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final theme = Theme.of(context);
            final gold = theme.colorScheme.primary;
            final filters = <String, String>{
              'all': 'Все',
              'criminal': 'Уголовные дела',
              'business': 'Бизнес',
              'family': 'Семейное',
              'tax': 'Налоги',
              'labor': 'Трудовые споры',
              'civil': 'Гражданские',
            };

            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(color: gold.withValues(alpha: 0.2), width: 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Специализация',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: gold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filters.entries.map((entry) {
                          final isSelected = _selectedFilter == entry.key;
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: isSelected,
                            selectedColor: gold,
                            backgroundColor: theme.colorScheme.surfaceContainerHigh,
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFF1A1400) : Colors.white70,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            side: BorderSide(
                              color: isSelected ? gold : Colors.white12,
                            ),
                            onSelected: (selected) {
                              setSheetState(() {
                                _selectedFilter = entry.key;
                              });
                              setState(() {}); // Update parent
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lawyersAsync = ref.watch(marketplaceLawyersProvider);
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.marketplaceTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _selectedFilter != 'all',
              smallSize: 8,
              backgroundColor: gold,
              child: const Icon(Icons.filter_list_rounded),
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: switch (lawyersAsync) {
        AsyncData(:final value) => value.isEmpty
            ? _MarketplaceEmptyState(gold: gold, onRefresh: () {
                ref.invalidate(marketplaceLawyersProvider);
              })
            : RefreshIndicator(
                color: gold,
                onRefresh: () async {
                  ref.invalidate(marketplaceLawyersProvider);
                },
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: value.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _LawyerCard(lawyer: value[index]);
                  },
                ),
              ),
        AsyncError(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    l.marketplaceError(error.toString()),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => ref.invalidate(marketplaceLawyersProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Обновить'),
                  ),
                ],
              ),
            ),
          ),
        _ => const _MarketplaceLoading(),
      },
    );
  }
}

class _MarketplaceEmptyState extends StatelessWidget {
  const _MarketplaceEmptyState({required this.gold, required this.onRefresh});
  final Color gold;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_search_rounded, size: 60, color: gold),
            ),
            const SizedBox(height: 24),
            Text(
              l.marketplaceEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  const _LawyerCard({required this.lawyer});

  final LawyerProfile lawyer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: gold.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                backgroundImage: lawyer.imageUrl != null
                    ? NetworkImage(lawyer.imageUrl!)
                    : null,
                child: lawyer.imageUrl == null
                    ? Icon(Icons.person, color: gold, size: 36)
                    : null,
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lawyer.specialization,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: gold, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          lawyer.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: gold,
                          ),
                        ),
                        Text(
                          ' ${l.marketplaceReviews(lawyer.reviewsCount)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Rate & Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l.marketplaceRate(lawyer.hourlyRate),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l.marketplaceContact,
                            style: const TextStyle(
                              color: Color(0xFF1A1400),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketplaceLoading extends StatelessWidget {
  const _MarketplaceLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const ShimmerPlaceholder(
        height: 140,
        borderRadius: 20,
      ),
    );
  }
}
