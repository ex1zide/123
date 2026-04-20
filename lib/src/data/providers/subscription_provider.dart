import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_provider.g.dart';

/// Subscription tiers for LegalHelp KZ monetization.
enum SubscriptionPlan { free, pro, business }

/// Holds the user's subscription state and AI query limits.
class SubscriptionState {
  const SubscriptionState({
    required this.plan,
    required this.usedQueries,
    required this.maxQueries,
  });

  final SubscriptionPlan plan;
  final int usedQueries;
  final int maxQueries;

  /// How many queries remain.
  int get remaining => (maxQueries - usedQueries).clamp(0, maxQueries);

  /// Whether the user has exhausted their free queries.
  bool get isLimitReached => plan == SubscriptionPlan.free && remaining <= 0;

  /// Whether the user has an active paid subscription.
  bool get isPaid => plan != SubscriptionPlan.free;

  /// Factory constructor from Firestore document data.
  factory SubscriptionState.fromFirestore(Map<String, dynamic> data) {
    final planStr = (data['plan'] as String?) ?? 'free';
    final plan = SubscriptionPlan.values.firstWhere(
      (p) => p.name == planStr,
      orElse: () => SubscriptionPlan.free,
    );
    return SubscriptionState(
      plan: plan,
      usedQueries: (data['usedQueries'] as int?) ?? 0,
      maxQueries: (data['maxQueries'] as int?) ?? 10,
    );
  }

  /// Default state for unauthenticated or new users.
  factory SubscriptionState.free() => const SubscriptionState(
        plan: SubscriptionPlan.free,
        usedQueries: 0,
        maxQueries: 10,
      );
}

/// Riverpod provider that streams the user's subscription from Firestore.
///
/// Source of truth: `/users/{uid}/subscription/status`
/// The Cloud Function `askAI` increments `usedQueries` server-side,
/// and this stream reactively updates the UI in real-time.
@Riverpod(keepAlive: true)
Stream<SubscriptionState> subscriptionController(SubscriptionControllerRef ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(SubscriptionState.free());
  }

  return FirebaseFirestore.instance
      .doc('users/${user.uid}/subscription/status')
      .snapshots()
      .map((snap) {
    if (!snap.exists) {
      return SubscriptionState.free();
    }
    return SubscriptionState.fromFirestore(snap.data()!);
  });
}
