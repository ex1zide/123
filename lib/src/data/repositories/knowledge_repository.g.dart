// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$knowledgeRepositoryHash() =>
    r'b7a7559cfa6075c1c8bab0dec9b5516a753ca2f6';

/// RAG (Retrieval-Augmented Generation) Knowledge Repository.
///
/// Searches the Firestore `knowledge_base` collection for articles
/// relevant to the user's legal question, then builds a context string
/// for the Gemini AI to ground its answer in real Kazakh legislation.
///
/// Copied from [knowledgeRepository].
@ProviderFor(knowledgeRepository)
final knowledgeRepositoryProvider = Provider<KnowledgeRepository>.internal(
  knowledgeRepository,
  name: r'knowledgeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$knowledgeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KnowledgeRepositoryRef = ProviderRef<KnowledgeRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
