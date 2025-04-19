import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  static const _themeKey = 'isDarkTheme';

  ThemeCubit() : super(false) {
    _loadTheme();
  }

  /// Toggle theme and persist the value
  Future<void> toggleTheme() async {
    final newTheme = !state;
    emit(newTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newTheme);
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    emit(isDark);
  }
}
