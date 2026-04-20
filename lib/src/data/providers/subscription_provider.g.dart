// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionControllerHash() =>
    r'c6737d5234e73e3c6cadcfeb4fdf24832d7a90cf';

/// Riverpod provider that streams the user's subscription from Firestore.
///
/// Source of truth: `/users/{uid}/subscription/status`
/// The Cloud Function `askAI` increments `usedQueries` server-side,
/// and this stream reactively updates the UI in real-time.
///
/// Copied from [subscriptionController].
@ProviderFor(subscriptionController)
final subscriptionControllerProvider =
    StreamProvider<SubscriptionState>.internal(
      subscriptionController,
      name: r'subscriptionControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionControllerRef = StreamProviderRef<SubscriptionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
