import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer skeleton placeholder — used during async Firebase calls
/// to keep perceived latency < 400 ms (Doherty Threshold).
class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  /// Creates a card-sized shimmer block.
  const ShimmerPlaceholder.card({super.key})
      : width = double.infinity,
        height = 120,
        borderRadius = 16;

  /// Creates a circular shimmer (avatar / icon).
  const ShimmerPlaceholder.circle({
    super.key,
    this.width = 48,
    this.height = 48,
  }) : borderRadius = 999;

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainer,
      highlightColor: theme.colorScheme.surfaceContainerHigh,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A list of skeleton rows — useful as a drop-in for loading lists.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const _ShimmerRow(),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShimmerPlaceholder.circle(),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPlaceholder(height: 14, width: 180),
              SizedBox(height: 8),
              ShimmerPlaceholder(height: 12, width: 120),
            ],
          ),
        ),
      ],
    );
  }
}
