part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final CustomTheme light;
  final CustomTheme dark;

  const ThemeState({
    required this.themeMode,
    required this.light,
    required this.dark,
  });

  ThemeData get theme => light.data;
  ThemeData get darkTheme => dark.data;

  ThemeState copyWith({
    ThemeMode? themeMode,
    CustomTheme? light,
    CustomTheme? dark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  @override
  List<Object?> get props => [themeMode, light, dark];
}


