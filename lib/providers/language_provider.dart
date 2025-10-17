import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN'); // Default: Tiếng Việt
  static const String _languageCodeKey = 'language_code';

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode, languageCode == 'vi' ? 'VN' : 'US');
      notifyListeners();
    }
  }

  Future<void> setLanguage(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'vi') {
      setLanguage(const Locale('en', 'US'));
    } else {
      setLanguage(const Locale('vi', 'VN'));
    }
  }

  String get currentLanguageName {
    return _locale.languageCode == 'vi' ? 'Tiếng Việt' : 'English';
  }

  String get otherLanguageName {
    return _locale.languageCode == 'vi' ? 'English' : 'Tiếng Việt';
  }

  IconData get languageIcon {
    return _locale.languageCode == 'vi' 
        ? Icons.language 
        : Icons.translate;
  }

  String get languageFlag {
    return _locale.languageCode == 'vi' ? '🇻🇳' : '🇺🇸';
  }
}
