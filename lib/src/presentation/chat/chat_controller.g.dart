// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatControllerHash() => r'8d5446e26118cf05f558f71b663c2e58392aac28';

/// Controls the chat state as an AsyncValue list of messages.
///
/// All rate limiting and subscription checks are now handled SERVER-SIDE
/// by the Cloud Function `askAI`. If the server returns 429,
/// [ChatRepository] throws [PaywallRequiredException] which the UI catches.
///
/// Copied from [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      ChatController,
      List<ChatMessage>
    >.internal(
      ChatController.new,
      name: r'chatControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChatController = AutoDisposeAsyncNotifier<List<ChatMessage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
