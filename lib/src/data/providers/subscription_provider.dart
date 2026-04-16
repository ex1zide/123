import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  SubscriptionState copyWith({
    SubscriptionPlan? plan,
    int? usedQueries,
    int? maxQueries,
  }) {
    return SubscriptionState(
      plan: plan ?? this.plan,
      usedQueries: usedQueries ?? this.usedQueries,
      maxQueries: maxQueries ?? this.maxQueries,
    );
  }
}

/// Riverpod controller for subscription state.
/// Persists query count to SharedPreferences.
@Riverpod(keepAlive: true)
class SubscriptionController extends _$SubscriptionController {
  static const _planKey = 'subscription_plan';
  static const _usedKey = 'subscription_used_queries';

  static const _planLimits = {
    SubscriptionPlan.free: 10,
    SubscriptionPlan.pro: 999999, // Unlimited
    SubscriptionPlan.business: 999999,
  };

  @override
  FutureOr<SubscriptionState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final planStr = prefs.getString(_planKey) ?? 'free';
    final used = prefs.getInt(_usedKey) ?? 0;

    final plan = SubscriptionPlan.values.firstWhere(
      (p) => p.name == planStr,
      orElse: () => SubscriptionPlan.free,
    );

    return SubscriptionState(
      plan: plan,
      usedQueries: used,
      maxQueries: _planLimits[plan]!,
    );
  }

  /// Increments the query counter. Returns `false` if limit reached.
  Future<bool> consumeQuery() async {
    final current = state.value;
    if (current == null) return false;

    if (current.isLimitReached) return false;

    final updated = current.copyWith(usedQueries: current.usedQueries + 1);
    state = AsyncData(updated);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usedKey, updated.usedQueries);

    return true;
  }

  /// Upgrades the user's plan (call after successful payment).
  Future<void> upgradePlan(SubscriptionPlan newPlan) async {
    final current = state.value;
    if (current == null) return;

    final updated = current.copyWith(
      plan: newPlan,
      maxQueries: _planLimits[newPlan]!,
      usedQueries: 0, // Reset counter on upgrade
    );
    state = AsyncData(updated);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, newPlan.name);
    await prefs.setInt(_usedKey, 0);
  }
}
