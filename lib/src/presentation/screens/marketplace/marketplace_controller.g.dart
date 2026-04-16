// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketplaceLawyersHash() =>
    r'90e2498e7253e8ffbaf27fdf04b8ea4b45f6f42d';

/// Provider for connecting to the Firestore `lawyers` collection.
/// Watch this to get real-time marketplace updates.
///
/// Copied from [marketplaceLawyers].
@ProviderFor(marketplaceLawyers)
final marketplaceLawyersProvider =
    AutoDisposeStreamProvider<List<LawyerProfile>>.internal(
      marketplaceLawyers,
      name: r'marketplaceLawyersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketplaceLawyersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketplaceLawyersRef =
    AutoDisposeStreamProviderRef<List<LawyerProfile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
