import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'app_themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppThemes.lightTheme);

  void toggleTheme() {
    if (state.brightness == Brightness.light) {
      emit(AppThemes.darkTheme);
    } else {
      emit(AppThemes.lightTheme);
    }
  }
}
