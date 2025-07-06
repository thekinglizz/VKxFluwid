import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0058bf),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff006fef),
      onPrimaryContainer: Color(0xfffefcff),
      secondary: Color(0xff405d98),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa1beff),
      onSecondaryContainer: Color(0xff2e4c85),
      tertiary: Color(0xff8e2ab3),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffaa48ce),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff181b23),
      onSurfaceVariant: Color(0xff414755),
      outline: Color(0xff727786),
      outlineVariant: Color(0xffc1c6d7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3039),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a42),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff004396),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff001a42),
      secondaryFixedDim: Color(0xffaec6ff),
      onSecondaryFixedVariant: Color(0xff27457e),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff330045),
      tertiaryFixedDim: Color(0xffeeb1ff),
      onTertiaryFixedVariant: Color(0xff76029b),
      surfaceDim: Color(0xffd8d9e5),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3ff),
      surfaceContainer: Color(0xffecedf9),
      surfaceContainerHigh: Color(0xffe6e7f3),
      surfaceContainerHighest: Color(0xffe0e2ed),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003376),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0068e0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff12346c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4f6ca7),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5c007b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa13fc6),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0e1119),
      onSurfaceVariant: Color(0xff313644),
      outline: Color(0xff4d5261),
      outlineVariant: Color(0xff676d7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3039),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff0068e0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0051b1),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4f6ca7),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff36548d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffa13fc6),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff8620ab),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c6d1),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f3ff),
      surfaceContainer: Color(0xffe6e7f3),
      surfaceContainerHigh: Color(0xffdadce8),
      surfaceContainerHighest: Color(0xffcfd1dc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002a62),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00469a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff012a62),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff294881),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4c0066),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff78099e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272c39),
      outlineVariant: Color(0xff444957),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3039),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff00469a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00306f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff294881),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff0c3169),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff78099e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff570074),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6b8c3),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef0fc),
      surfaceContainer: Color(0xffe0e2ed),
      surfaceContainerHigh: Color(0xffd2d4df),
      surfaceContainerHighest: Color(0xffc4c6d1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaec6ff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002e6a),
      primaryContainer: Color(0xff4f8eff),
      onPrimaryContainer: Color(0xff001130),
      secondary: Color(0xffaec6ff),
      onSecondary: Color(0xff082e66),
      secondaryContainer: Color(0xff27457e),
      onSecondaryContainer: Color(0xff98b5f5),
      tertiary: Color(0xffeeb1ff),
      onTertiary: Color(0xff53006f),
      tertiaryContainer: Color(0xffc966ed),
      onTertiaryContainer: Color(0xff240032),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff10131b),
      onSurface: Color(0xffe0e2ed),
      onSurfaceVariant: Color(0xffc1c6d7),
      outline: Color(0xff8b90a1),
      outlineVariant: Color(0xff414755),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ed),
      inversePrimary: Color(0xff005ac4),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a42),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff004396),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff001a42),
      secondaryFixedDim: Color(0xffaec6ff),
      onSecondaryFixedVariant: Color(0xff27457e),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff330045),
      tertiaryFixedDim: Color(0xffeeb1ff),
      onTertiaryFixedVariant: Color(0xff76029b),
      surfaceDim: Color(0xff10131b),
      surfaceBright: Color(0xff363942),
      surfaceContainerLowest: Color(0xff0b0e16),
      surfaceContainerLow: Color(0xff181b23),
      surfaceContainer: Color(0xff1c1f28),
      surfaceContainerHigh: Color(0xff272a32),
      surfaceContainerHighest: Color(0xff32353d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfdcff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002356),
      primaryContainer: Color(0xff4f8eff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcfdcff),
      onSecondary: Color(0xff002356),
      secondaryContainer: Color(0xff7490ce),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff7cfff),
      onTertiary: Color(0xff420059),
      tertiaryContainer: Color(0xffc966ed),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10131b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dcee),
      outline: Color(0xffadb1c2),
      outlineVariant: Color(0xff8b90a0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ed),
      inversePrimary: Color(0xff004498),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff00102e),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff003376),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff00102e),
      secondaryFixedDim: Color(0xffaec6ff),
      onSecondaryFixedVariant: Color(0xff12346c),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff220030),
      tertiaryFixedDim: Color(0xffeeb1ff),
      onTertiaryFixedVariant: Color(0xff5c007b),
      surfaceDim: Color(0xff10131b),
      surfaceBright: Color(0xff41444d),
      surfaceContainerLowest: Color(0xff05070e),
      surfaceContainerLow: Color(0xff1a1d26),
      surfaceContainer: Color(0xff252830),
      surfaceContainerHigh: Color(0xff2f323b),
      surfaceContainerHighest: Color(0xff3a3d46),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecefff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa8c2ff),
      onPrimaryContainer: Color(0xff000a23),
      secondary: Color(0xffecefff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa8c2ff),
      onSecondaryContainer: Color(0xff000a23),
      tertiary: Color(0xfffeeaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffecabff),
      onTertiaryContainer: Color(0xff190024),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff10131b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecefff),
      outlineVariant: Color(0xffbdc2d3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2ed),
      inversePrimary: Color(0xff004498),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff00102e),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffaec6ff),
      onSecondaryFixedVariant: Color(0xff00102e),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffeeb1ff),
      onTertiaryFixedVariant: Color(0xff220030),
      surfaceDim: Color(0xff10131b),
      surfaceBright: Color(0xff4d5059),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c1f28),
      surfaceContainer: Color(0xff2d3039),
      surfaceContainerHigh: Color(0xff383b44),
      surfaceContainerHighest: Color(0xff444750),
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


  List<ExtendedColor> get extendedColors => [
  ];
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
