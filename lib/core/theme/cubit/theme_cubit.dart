import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:prime_top_front/core/theme/custom_theme.dart';
import 'package:prime_top_front/core/theme/themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          themeMode: ThemeMode.light,
          light: Themes.light,
          dark: Themes.dark,
        ));

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void toggleThemeMode() {
    emit(state.copyWith(
      themeMode: state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    ));
  }
}
