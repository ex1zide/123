// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionControllerHash() =>
    r'2fd4e6d1525b523e7be11eeaf3adb95e11aafd1c';

/// Riverpod controller for subscription state.
/// Persists query count to SharedPreferences.
///
/// Copied from [SubscriptionController].
@ProviderFor(SubscriptionController)
final subscriptionControllerProvider =
    AsyncNotifierProvider<SubscriptionController, SubscriptionState>.internal(
      SubscriptionController.new,
      name: r'subscriptionControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubscriptionController = AsyncNotifier<SubscriptionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
