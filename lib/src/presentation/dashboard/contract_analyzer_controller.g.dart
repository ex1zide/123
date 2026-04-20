// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_analyzer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contractAnalyzerControllerHash() =>
    r'a8f681daa600e738f9280e6f9f42a38cddaf9e13';

/// Manages the contract analyzer lifecycle:
/// 1. Pick file (PDF/Image)
/// 2. Extract text (ML Kit for images, raw bytes for PDF)
/// 3. Send to Cloud Function `analyzeContract`
/// 4. Return structured AI analysis
///
/// Copied from [ContractAnalyzerController].
@ProviderFor(ContractAnalyzerController)
final contractAnalyzerControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      ContractAnalyzerController,
      ContractAnalysisResult?
    >.internal(
      ContractAnalyzerController.new,
      name: r'contractAnalyzerControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contractAnalyzerControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ContractAnalyzerController =
    AutoDisposeAsyncNotifier<ContractAnalysisResult?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
