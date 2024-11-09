import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const _key = 'theme_mode';

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_key) ?? false;
      if (mounted) {
        state = isDark ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      // Fallback to default light theme if there's an error
      if (mounted) {
        state = ThemeMode.light;
      }
    }
  }

  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      await prefs.setBool(_key, state == ThemeMode.dark);
    } catch (e) {
      // At least toggle the theme even if we can't persist it
      state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
  }
} 