import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/theme/custom_theme.dart';
import 'package:prime_top_front/core/theme/theme_text_styles.dart';

class Themes {
  static List<CustomTheme> themes = [light, dark];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [ColorName.primary, ColorName.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static CustomTheme light = CustomTheme(
    name: 'Light',
    data: ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      canvasColor: ColorName.background,
      primaryColor: ColorName.primary,
      scaffoldBackgroundColor: ColorName.background,
      colorScheme: ColorScheme.light(
        primary: ColorName.primary,
        secondary: ColorName.secondary,
        surface: ColorName.cardBackground,
        background: ColorName.background,
        onBackground: ColorName.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        foregroundColor: ColorName.textSecondary,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorName.borderSoft,
      ),
      cardColor: ColorName.cardBackground,
      extensions: [
        ThemeTextStyles.light,
      ],
    ),
  );

  static CustomTheme dark = CustomTheme(
    name: 'Dark',
    data: ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,
      canvasColor: ColorName.darkThemeBackground,
      primaryColor: ColorName.darkThemePrimary,
      scaffoldBackgroundColor: ColorName.darkThemeBackground,
      colorScheme: ColorScheme.dark(
        primary: ColorName.darkThemePrimary,
        secondary: ColorName.darkThemeSecondary,
        surface: ColorName.darkThemeCardBackground,
        background: ColorName.darkThemeBackground,
        onBackground: ColorName.darkThemeTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        foregroundColor: ColorName.darkThemeTextSecondary,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorName.darkThemeBorderSoft,
      ),
      cardColor: ColorName.darkThemeCardBackground,
      extensions: [
        ThemeTextStyles.dark,
      ],
    ),
  );
}


