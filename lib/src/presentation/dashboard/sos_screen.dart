import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the emergency number. 
/// Currently returns a static value, but can easily be wired to Firebase Remote Config.
final emergencyNumberProvider = Provider<String>((ref) => '+77001234567');

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _callLawyer() async {
    HapticFeedback.mediumImpact();
    final l = AppLocalizations.of(context)!;
    final number = ref.read(emergencyNumberProvider);
    final uri = Uri.parse('tel:$number');
    try {
      if (!await launchUrl(uri)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.sosDialerError)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.sosCallError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const crimsonRed = Color(0xFFE50914);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    // Darker variant for background override
    final darkCrimsonBackground = const Color(0xFF0F0000);

    return Scaffold(
      backgroundColor: darkCrimsonBackground,
      appBar: AppBar(
        title: Text(l.sosTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: _callLawyer,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: crimsonRed.withValues(alpha: 0.15),
                            boxShadow: [
                              BoxShadow(
                                color: crimsonRed.withValues(alpha: 0.6),
                                blurRadius: 40,
                                spreadRadius: _pulseAnimation.value * 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: crimsonRed,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFFFF3B30),
                                    Color(0xFFB30000),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 15,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.perm_phone_msg_rounded, size: 64, color: Colors.white),
                                  const SizedBox(height: 8),
                                  Text(
                                    l.sosButton,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                l.sosOfflineHeader,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: crimsonRed.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 16)),
          SliverList(
            delegate: SliverChildListDelegate([
              _OfflineRuleCard(
                title: l.sosRule1Title,
                content: l.sosRule1Content,
                icon: Icons.gavel_rounded,
                color: crimsonRed,
              ),
              _OfflineRuleCard(
                title: l.sosRule2Title,
                content: l.sosRule2Content,
                icon: Icons.car_crash_rounded,
                color: crimsonRed,
              ),
              _OfflineRuleCard(
                title: l.sosRule3Title,
                content: l.sosRule3Content,
                icon: Icons.local_police_rounded,
                color: crimsonRed,
              ),
              const SizedBox(height: 48),
            ]),
          ),
        ],
      ),
    );
  }
}

class _OfflineRuleCard extends StatelessWidget {
  const _OfflineRuleCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  final String title;
  final String content;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
