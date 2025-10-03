import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple theme controller using a ValueNotifier to switch between light and dark modes.
/// Also handles basic auth state for startup routing.
class ThemeController {
  ThemeController._();

  /// Holds the current theme mode. Defaults to system.
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);
  
  /// Simple auth state for demo purposes
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  /// Simple user display name for welcome banner
  static final ValueNotifier<String> userName = ValueNotifier<String>('User');
  
  /// Initialize auth state from SharedPreferences
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('is_logged_in') ?? false;
    userName.value = prefs.getString('user_name') ?? 'User';
  }
  
  /// Set login state
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', value);
    isLoggedIn.value = value;
  }

  /// Set user display name
  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    userName.value = name;
  }

  /// Toggle between light and dark theme. If system, it will switch to dark first.
  static void toggle() {
    final current = themeMode.value;
    if (current == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }

  /// Set an explicit theme mode.
  static void set(ThemeMode mode) {
    themeMode.value = mode;
  }
}
