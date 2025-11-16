import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle mediumM;
  final TextStyle mediumS;
  final TextStyle mediumXS;
  final TextStyle mediumXSS;
  final TextStyle regularM;
  final TextStyle regularS;
  final TextStyle regularXS;
  final TextStyle regularXXS;

  const ThemeTextStyles({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.mediumM,
    required this.mediumS,
    required this.mediumXS,
    required this.mediumXSS,
    required this.regularM,
    required this.regularS,
    required this.regularXS,
    required this.regularXXS,
  });

  @override
  ThemeExtension<ThemeTextStyles> copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? mediumM,
    TextStyle? mediumS,
    TextStyle? mediumXS,
    TextStyle? mediumXSS,
    TextStyle? regularM,
    TextStyle? regularS,
    TextStyle? regularXS,
    TextStyle? regularXXS,
  }) {
    return ThemeTextStyles(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      mediumM: mediumM ?? this.mediumM,
      mediumS: mediumS ?? this.mediumS,
      mediumXS: mediumXS ?? this.mediumXS,
      mediumXSS: mediumXSS ?? this.mediumXSS,
      regularM: regularM ?? this.regularM,
      regularS: regularS ?? this.regularS,
      regularXS: regularXS ?? this.regularXS,
      regularXXS: regularXXS ?? this.regularXXS,
    );
  }

  @override
  ThemeExtension<ThemeTextStyles> lerp(ThemeExtension<ThemeTextStyles>? other, double t) {
    if (other is! ThemeTextStyles) return this;
    return ThemeTextStyles(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      mediumM: TextStyle.lerp(mediumM, other.mediumM, t)!,
      mediumS: TextStyle.lerp(mediumS, other.mediumS, t)!,
      mediumXS: TextStyle.lerp(mediumXS, other.mediumXS, t)!,
      mediumXSS: TextStyle.lerp(mediumXSS, other.mediumXSS, t)!,
      regularM: TextStyle.lerp(regularM, other.regularM, t)!,
      regularS: TextStyle.lerp(regularS, other.regularS, t)!,
      regularXS: TextStyle.lerp(regularXS, other.regularXS, t)!,
      regularXXS: TextStyle.lerp(regularXXS, other.regularXXS, t)!,
    );
  }

  static ThemeTextStyles light = ThemeTextStyles(
    h1: const TextStyle(
      fontSize: 28,
      height: 1.2,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w700,
      fontFamily: 'Roboto',
    ),
    h2: const TextStyle(
      fontSize: 24,
      height: 1.2,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    h3: const TextStyle(
      fontSize: 20,
      height: 1.2,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    h4: const TextStyle(
      fontSize: 16,
      height: 1.2,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    h5: const TextStyle(
      fontSize: 14,
      height: 1.2,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    mediumM: const TextStyle(
      fontSize: 16,
      height: 1.4,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    mediumS: const TextStyle(
      fontSize: 14,
      height: 1.4,
      letterSpacing: 0,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    mediumXS: const TextStyle(
      fontSize: 12,
      height: 1.25,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    mediumXSS: const TextStyle(
      fontSize: 10,
      height: 1.25,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    regularM: const TextStyle(
      fontSize: 16,
      height: 1.4,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    regularS: const TextStyle(
      fontSize: 14,
      height: 1.4,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    regularXS: const TextStyle(
      fontSize: 12,
      height: 1.25,
      letterSpacing: 0,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    regularXXS: const TextStyle(
      fontSize: 10,
      height: 1.4,
      letterSpacing: 0.1,
      color: ColorName.textPrimary,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
  );

  static ThemeTextStyles dark = ThemeTextStyles(
    h1: light.h1.copyWith(color: ColorName.darkThemeTextPrimary),
    h2: light.h2.copyWith(color: ColorName.darkThemeTextPrimary),
    h3: light.h3.copyWith(color: ColorName.darkThemeTextPrimary),
    h4: light.h4.copyWith(color: ColorName.darkThemeTextPrimary),
    h5: light.h5.copyWith(color: ColorName.darkThemeTextPrimary),
    mediumM: light.mediumM.copyWith(color: ColorName.darkThemeTextPrimary),
    mediumS: light.mediumS.copyWith(color: ColorName.darkThemeTextPrimary),
    mediumXS: light.mediumXS.copyWith(color: ColorName.darkThemeTextPrimary),
    mediumXSS: light.mediumXSS.copyWith(color: ColorName.darkThemeTextPrimary),
    regularM: light.regularM.copyWith(color: ColorName.darkThemeTextPrimary),
    regularS: light.regularS.copyWith(color: ColorName.darkThemeTextPrimary),
    regularXS: light.regularXS.copyWith(color: ColorName.darkThemeTextPrimary),
    regularXXS: light.regularXXS.copyWith(color: ColorName.darkThemeTextPrimary),
  );
}


