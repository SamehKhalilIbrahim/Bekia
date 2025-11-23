import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_preference.dart';

// State
class ThemeState {
  final bool isDark;

  const ThemeState({required this.isDark});

  ThemeState copyWith({bool? isDark}) {
    return ThemeState(isDark: isDark ?? this.isDark);
  }
}

// Cubit
class ThemeCubit extends Cubit<ThemeState> {
  final ThemePreferences _preferences;

  ThemeCubit()
    : _preferences = ThemePreferences(),
      super(const ThemeState(isDark: false)) {
    _loadTheme();
  }

  // Load theme from preferences
  Future<void> _loadTheme() async {
    final isDark = await _preferences.getTheme();
    emit(ThemeState(isDark: isDark));
  }

  // Toggle theme
  void toggleTheme() {
    final newValue = !state.isDark;
    _preferences.setTheme(newValue);
    emit(ThemeState(isDark: newValue));
  }

  // Set theme directly
  void setTheme(bool isDark) {
    _preferences.setTheme(isDark);
    emit(ThemeState(isDark: isDark));
  }
}
