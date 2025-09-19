import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeMode _mode = ThemeMode.light;

  ThemeCubit() : super(AppThemes.lightTheme);

  ThemeMode get mode => _mode;

  void toggleTheme() {
    if (_mode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  void setThemeMode(ThemeMode mode) {
    _mode = mode;

    if (mode == ThemeMode.system) {
      // Choose theme based on platform brightness
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        emit(AppThemes.darkTheme);
      } else {
        emit(AppThemes.lightTheme);
      }
    } else if (mode == ThemeMode.dark) {
      emit(AppThemes.darkTheme);
    } else {
      emit(AppThemes.lightTheme);
    }
  }
}
