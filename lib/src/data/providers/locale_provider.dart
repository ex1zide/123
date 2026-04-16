import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  static const _localeKey = 'legalhelp_kz_locale';

  @override
  Locale build() {
    // Initial synchronously returned default locale 'ru'.
    // Async loader validates the storage in parallel.
    _loadFromCache();
    return const Locale('ru');
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);
    if (savedCode != null) {
      state = Locale(savedCode);
    }
  }

  Future<void> changeLocale(Locale newLocale) async {
    if (state.languageCode == newLocale.languageCode) return;
    
    // Save locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    
    // Update State natively
    state = newLocale;
  }
}
