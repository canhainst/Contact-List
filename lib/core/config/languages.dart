import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, dynamic>? _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'lib/core/resources/languages/${locale.languageCode}.json',
    );
    _localizedStrings = json.decode(jsonString);
    return true;
  }

  String translate(String key, {Map<String, String>? args}) {
    if (_localizedStrings == null) return key;

    final keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        if (kDebugMode) {
          debugPrint('Missing translation: $key');
          MissingTranslationTracker.instance.addMissing(
            key,
            locale.languageCode,
          );
        }
        return key;
      }
    }

    var result = value.toString();

    if (args != null) {
      args.forEach((k, v) {
        result = result.replaceAll('{$k}', v);
      });
    }

    return result;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

/// Debug tool to track missing translations during development
class MissingTranslationTracker {
  MissingTranslationTracker._();

  static final MissingTranslationTracker instance =
      MissingTranslationTracker._();

  final Map<String, Set<String>> _missingTranslations = {};

  /// Add a missing translation
  void addMissing(String key, String languageCode) {
    _missingTranslations.putIfAbsent(languageCode, () => {}).add(key);
  }

  /// Get all missing translations for a specific language
  Set<String> getMissingForLanguage(String languageCode) {
    return Set<String>.from(_missingTranslations[languageCode] ?? {});
  }

  /// Get all missing translations grouped by language
  Map<String, Set<String>> getAllMissing() {
    return Map<String, Set<String>>.from(_missingTranslations);
  }

  /// Clear all tracked missing translations
  void clear() {
    _missingTranslations.clear();
  }

  /// Export missing translations as JSON format for easy addition to language files
  String exportAsJson(String languageCode) {
    final missing = getMissingForLanguage(languageCode);
    if (missing.isEmpty) return '{}';

    Map<String, dynamic> result = {};

    for (String key in missing) {
      final parts = key.split('.');
      Map<String, dynamic> current = result;

      for (int i = 0; i < parts.length - 1; i++) {
        current.putIfAbsent(parts[i], () => {});
        current = current[parts[i]] as Map<String, dynamic>;
      }

      current[parts.last] = key; // Use the key as placeholder value
    }

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(result);
  }

  /// Print summary of all missing translations
  void printSummary() {
    if (_missingTranslations.isEmpty) {
      debugPrint('No missing translations found.');
      return;
    }

    debugPrint('=== Missing Translations Summary ===');
    for (var entry in _missingTranslations.entries) {
      debugPrint('\n${entry.key.toUpperCase()}: ${entry.value.length} missing');
      for (var key in entry.value) {
        debugPrint('  - $key');
      }
    }
    debugPrint('\n=== End of Summary ===');
  }
}
