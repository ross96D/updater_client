import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff68548e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffebddff),
      onPrimaryContainer: Color(0xff4f3d74),
      secondary: Color(0xff635b70),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe9def8),
      onSecondaryContainer: Color(0xff4b4358),
      tertiary: Color(0xff7e525d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e1),
      onTertiaryContainer: Color(0xff643b46),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      background: Color(0xfffef7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff1d1b20),
      surfaceVariant: Color(0xfff2ecf4),
      onSurfaceVariant: Color(0xff49454e),
      outline: Color(0xff7a757f),
      outlineVariant: Color(0xffcbc4cf),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      onInverseSurface: Color(0xfff5eff7),
      inversePrimary: Color(0xffd3bcfd),
      surfaceTint: Color(0xff68548e),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3e2c62),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff77639d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3a3346),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff72697f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff512a36),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8f606c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffef7ff),
      onBackground: Color(0xff121016),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff121016),
      surfaceVariant: Color(0xfff2ecf4),
      onSurfaceVariant: Color(0xff38353d),
      outline: Color(0xff55515a),
      outlineVariant: Color(0xff706b75),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      onInverseSurface: Color(0xfff5eff7),
      inversePrimary: Color(0xffd3bcfd),
      surfaceTint: Color(0xff68548e),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff342157),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff523f77),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff30293c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4d465a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff45212c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff673d48),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffef7ff),
      onBackground: Color(0xff000000),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xfff2ecf4),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2e2b33),
      outlineVariant: Color(0xff4c4751),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      onInverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xfff6ecff),
      surfaceTint: Color(0xff68548e),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd3bcfd),
      onPrimary: Color(0xff38265c),
      primaryContainer: Color(0xff4f3d74),
      onPrimaryContainer: Color(0xffebddff),
      secondary: Color(0xffcdc2db),
      onSecondary: Color(0xff342d40),
      secondaryContainer: Color(0xff4b4358),
      onSecondaryContainer: Color(0xffe9def8),
      tertiary: Color(0xfff0b7c5),
      onTertiary: Color(0xff4a2530),
      tertiaryContainer: Color(0xff643b46),
      onTertiaryContainer: Color(0xffffd9e1),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff151218),
      onBackground: Color(0xffe7e0e8),
      surface: Color(0xff151218),
      onSurface: Color(0xffe7e0e8),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xffcbc4cf),
      outline: Color(0xff948f99),
      outlineVariant: Color(0xff49454e),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      onInverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xff68548e),
      surfaceTint: Color(0xffd3bcfd),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe5d5ff),
      onPrimary: Color(0xff2d1a50),
      primaryContainer: Color(0xff9b86c4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe3d8f1),
      onSecondary: Color(0xff292235),
      secondaryContainer: Color(0xff968da4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd0db),
      onTertiary: Color(0xff3e1a25),
      tertiaryContainer: Color(0xffb68390),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff151218),
      onBackground: Color(0xffe7e0e8),
      surface: Color(0xff151218),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xffe1dae5),
      outline: Color(0xffb6b0ba),
      outlineVariant: Color(0xff948e98),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      onInverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xff513e75),
      surfaceTint: Color(0xffd3bcfd),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff6ecff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffcfb8f9),
      onPrimaryContainer: Color(0xff110031),
      secondary: Color(0xfff6ecff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc9bed7),
      onSecondaryContainer: Color(0xff0e0819),
      tertiary: Color(0xffffebee),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffecb4c1),
      onTertiaryContainer: Color(0xff1d020b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      background: Color(0xff151218),
      onBackground: Color(0xffe7e0e8),
      surface: Color(0xff151218),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff5edf9),
      outlineVariant: Color(0xfff5edf9),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      onInverseSurface: Color(0xff000000),
      inversePrimary: Color(0xff513e75),
      surfaceTint: Color(0xffd3bcfd),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
