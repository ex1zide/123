// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityStreamHash() =>
    r'2d56c3ed7933038de9f9a0b4f782c4a6fb195220';

/// Provides a global reactive stream of network connection states.
/// Returns a [List<ConnectivityResult>] mapping current active connections.
///
/// Copied from [connectivityStream].
@ProviderFor(connectivityStream)
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>.internal(
      connectivityStream,
      name: r'connectivityStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectivityStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityStreamRef = StreamProviderRef<List<ConnectivityResult>>;
String _$networkStatusHash() => r'3801a6c7caa65294b1f4f994033fc5f23a56fd42';

/// A simplified synchronous provider mapping [ConnectivityResult] to a boolean.
/// Evaluates true if network is online (WiFi, Mobile, Vpn, Ethernet), false if entirely none.
///
/// Copied from [NetworkStatus].
@ProviderFor(NetworkStatus)
final networkStatusProvider = NotifierProvider<NetworkStatus, bool>.internal(
  NetworkStatus.new,
  name: r'networkStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkStatus = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
