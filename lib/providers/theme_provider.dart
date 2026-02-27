import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeModeOption _themeMode = ThemeModeOption.system;
  
  ThemeModeOption get themeModeOption => _themeMode;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  ThemeMode get themeMode {
    switch (_themeMode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }
  
  bool get isDarkMode => _themeMode == ThemeModeOption.dark;
  bool get isLightMode => _themeMode == ThemeModeOption.light;
  bool get isSystemMode => _themeMode == ThemeModeOption.system;
  
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      _themeMode = ThemeModeOption.values[themeIndex];
      notifyListeners();
    }
  }
  
  Future<void> setTheme(ThemeModeOption mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeModeOption.light : ThemeModeOption.dark;
    await setTheme(newMode);
  }
}
