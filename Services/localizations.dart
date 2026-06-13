import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MyLocalizations {
  final Locale? locale;
  static Map<String, Map<String, String>> _localizedValues = {};

  // Constructor
  MyLocalizations({required this.locale});

  // Delegate instance
  static LocalizationsDelegate<MyLocalizations> delegate = _MyLocalizationsDelegate();

  // Instance getter for easy access
  static MyLocalizations? getInstance({required BuildContext context}) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  // Synchronously load JSON files into memory (Call this at app startup)
  static Future<void> init() async {
    try {
      _localizedValues['en'] = await _loadJsonFile('en');
      _localizedValues['ar'] = await _loadJsonFile('ar');
    } catch (e) {
      debugPrint("Error loading localization files: $e");
      _localizedValues = {"en": {}, "ar": {}};
    }
  }

  // Private method to load a single JSON file and return its parsed content
  static Future<Map<String, String>> _loadJsonFile(String languageCode) async {
    String jsonSource = await rootBundle.loadString("assets/lang/$languageCode.json");
    Map<String, dynamic> jsonDecoded = jsonDecode(jsonSource);
    return jsonDecoded.map((key, value) => MapEntry(key, value.toString()));
  }

  // Get value from the preloaded JSON data (Sync)
  String getValue(String key) {
    return _localizedValues[locale?.languageCode]?[key] ?? "empty";
  }

  // Get a localized value from a specific language file (Sync)
  static String getValueFromLanguage(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? "empty";
  }
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ["en", "ar"].contains(locale.languageCode);
  }

  @override
  Future<MyLocalizations> load(Locale locale) async {
    return MyLocalizations(locale: locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<MyLocalizations> old) {
    return false;
  }
}
