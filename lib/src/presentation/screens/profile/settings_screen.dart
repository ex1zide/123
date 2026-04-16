import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

import '../../../data/providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushEnabled = true;
  final bool _darkModeEnabled = true; // Locked



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final l = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeControllerProvider).languageCode;
    final languageName = currentLocale == 'kk' ? 'Қазақша' : 'Русский';

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // ── Основные ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l.settingsSectionMain,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SwitchListTile(
            title: Text(l.settingsPushTitle),
            subtitle: Text(
              l.settingsPushSubtitle,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            value: _pushEnabled,
            activeTrackColor: gold,
            onChanged: (val) => setState(() => _pushEnabled = val),
            secondary: Icon(Icons.notifications_active_rounded, color: gold),
          ),
          ListTile(
            title: Text(l.settingsLanguageTitle),
            leading: Icon(Icons.language_rounded, color: gold),
            trailing: DropdownButton<String>(
              value: currentLocale, // stricly 'ru' or 'kk'
              icon: const Icon(Icons.arrow_drop_down_rounded),
              underline: const SizedBox(),
              dropdownColor: theme.colorScheme.surfaceContainerHigh,
              items: const [
                DropdownMenuItem(
                  value: 'ru',
                  child: Text('Русский', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                DropdownMenuItem(
                  value: 'kk',
                  child: Text('Қазақша', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(localeControllerProvider.notifier).changeLocale(Locale(newValue));
                }
              },
            ),
          ),
          
          const Divider(height: 32, indent: 16, endIndent: 16),

          // ── Оформление ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l.settingsSectionDesign,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SwitchListTile(
            title: Text(l.settingsDarkThemeTitle),
            subtitle: Text(
              l.settingsDarkThemeSubtitle,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            value: _darkModeEnabled,
            activeTrackColor: gold,
            onChanged: null, // Locked
            secondary: Icon(Icons.dark_mode_rounded, color: gold),
          ),

          const Divider(height: 32, indent: 16, endIndent: 16),

          // ── Информация ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l.settingsSectionInfo,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            title: Text(l.settingsPrivacy),
            leading: Icon(Icons.privacy_tip_rounded, color: theme.colorScheme.onSurfaceVariant),
            trailing: Icon(Icons.open_in_new_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
            onTap: () {
              // Open web link
            },
          ),
          ListTile(
            title: Text(l.settingsTerms),
            leading: Icon(Icons.article_rounded, color: theme.colorScheme.onSurfaceVariant),
            trailing: Icon(Icons.open_in_new_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
