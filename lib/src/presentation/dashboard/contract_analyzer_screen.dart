import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

import '../widgets/shimmer_placeholder.dart';
import 'contract_analyzer_controller.dart';

/// Premium Contract Analyzer Screen.
///
/// Deep Black (#0A0A0A) background with gold radial glow.
/// Central glassmorphic container floats above background.
/// Supports: Image OCR → AI Audit, PDF → AI Audit.
class ContractAnalyzerScreen extends ConsumerWidget {
  const ContractAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;

    // Listen for errors
    ref.listen<AsyncValue<ContractAnalysisResult?>>(
      contractAnalyzerControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          final errorText = state.error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorText),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );

    final analyzerState = ref.watch(contractAnalyzerControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l.contractAnalyzerTitle),
      ),
      body: Stack(
        children: [
          // ── Premium Background: Gold radial glow ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    gold.withValues(alpha: 0.07),
                    gold.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // ── Glassmorphic Content Container ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.04),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: switch (analyzerState) {
                      AsyncLoading() => _LoadingState(gold: gold, l: l),
                      AsyncData(:final value) => value == null
                          ? _UploadState(ref: ref, gold: gold, theme: theme, l: l)
                          : value.isClean
                              ? _CleanResultState(result: value, ref: ref, gold: gold, theme: theme, l: l)
                              : _RisksResultState(result: value, ref: ref, gold: gold, theme: theme, l: l),
                      AsyncError() => _UploadState(ref: ref, gold: gold, theme: theme, l: l),
                      _ => _UploadState(ref: ref, gold: gold, theme: theme, l: l),
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// STATE: Upload (Initial)
// ══════════════════════════════════════════════════════════

class _UploadState extends StatelessWidget {
  const _UploadState({
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
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gold shield icon with glow
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold.withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: gold.withValues(alpha: 0.15),
                  blurRadius: 50,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: Icon(
              Icons.security_rounded,
              size: 64,
              color: gold,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l.contractAnalyzerUploadTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l.contractAnalyzerUploadDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Upload buttons
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: const Color(0xFF1A1400),
                elevation: 10,
                shadowColor: gold.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.photo_library_rounded),
              label: Text(
                l.contractAnalyzerPickImage,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              onPressed: () => ref
                  .read(contractAnalyzerControllerProvider.notifier)
                  .pickImageAndAnalyze(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: gold,
                side: BorderSide(color: gold.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: Text(
                l.contractAnalyzerPickPdf,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              onPressed: () => ref
                  .read(contractAnalyzerControllerProvider.notifier)
                  .pickPdfAndAnalyze(),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// STATE: Loading (AI Analyzing)
// ══════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.gold, required this.l});

  final Color gold;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(gold),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l.contractAnalyzerLoading,
            style: TextStyle(
              color: gold,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Shimmer skeleton for document lines
          ...List.generate(8, (i) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: 14,
                right: i % 2 == 0 ? 0 : 50,
              ),
              child: ShimmerPlaceholder(
                height: i % 3 == 0 ? 18 : 12,
                borderRadius: 4,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// STATE: Clean (No Risks)
// ══════════════════════════════════════════════════════════

class _CleanResultState extends StatelessWidget {
  const _CleanResultState({
    required this.result,
    required this.ref,
    required this.gold,
    required this.theme,
    required this.l,
  });

  final ContractAnalysisResult result;
  final WidgetRef ref;
  final Color gold;
  final ThemeData theme;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Golden glowing checkmark
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gold.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: gold.withValues(alpha: 0.3),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: gold,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l.contractAnalyzerCleanTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: gold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l.contractAnalyzerCleanDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          if (result.summary.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: gold.withValues(alpha: 0.06),
                border: Border.all(color: gold.withValues(alpha: 0.15)),
              ),
              child: Text(
                result.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          _ResetButton(ref: ref, l: l),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// STATE: Risks Found
// ══════════════════════════════════════════════════════════

class _RisksResultState extends StatelessWidget {
  const _RisksResultState({
    required this.result,
    required this.ref,
    required this.gold,
    required this.theme,
    required this.l,
  });

  final ContractAnalysisResult result;
  final WidgetRef ref;
  final Color gold;
  final ThemeData theme;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final dangerColor = Colors.redAccent.shade100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: dangerColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.contractAnalyzerRisksTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: dangerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${l.contractAnalyzerRisksFound}: ${result.risks.length}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),

          // Risk cards
          ...result.risks.asMap().entries.map((entry) {
            final index = entry.key;
            final risk = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: dangerColor.withValues(alpha: 0.08),
                  border: Border.all(
                    color: dangerColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dangerColor.withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: dangerColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        risk,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Full summary
          if (result.summary.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                result.summary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          _ResetButton(ref: ref, l: l),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Shared: Reset Button
// ══════════════════════════════════════════════════════════

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.ref, required this.l});

  final WidgetRef ref;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          side: BorderSide(color: gold.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded),
        label: Text(
          l.contractAnalyzerNewScan,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () =>
            ref.read(contractAnalyzerControllerProvider.notifier).reset(),
      ),
    );
  }
}
