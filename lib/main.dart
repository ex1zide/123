
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/presentation/routing/app_router.dart';
import 'src/presentation/theme/theme.dart';
import 'src/data/providers/locale_provider.dart';
import 'package:app/l10n/app_localizations.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: LegalHelpApp()));
}

/// Root widget for LegalHelp KZ.
class LegalHelpApp extends ConsumerWidget {
  const LegalHelpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LegalHelp KZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: ref.watch(localeControllerProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: child,
          ),
        );
      },
    );
  }
}
