import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../firebase_options.dart';

part 'app_startup_provider.g.dart';

/// Provider handling global async initialization (Firebase, App Check, etc.).
/// UI stays responsive (Splash) until this resolves.
@Riverpod(keepAlive: true)
FutureOr<void> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    // Ensuring this provider is strictly bound to the app lifecycle
  });
  
  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Firebase App Check — Enterprise-grade bot protection.
  // Wrapped in try-catch: App Check may not be configured yet in Firebase Console.
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webProvider: ReCaptchaEnterpriseProvider('YOUR_RECAPTCHA_SITE_KEY'),
      // For production, use:
      // androidProvider: AndroidProvider.playIntegrity,
      // appleProvider: AppleProvider.appAttest,
    );
  } catch (_) {
    // App Check not configured — skip silently, app continues without protection
  }

  // 3. Smooth startup delay for splash animation
  await Future.delayed(const Duration(milliseconds: 1000));
}
