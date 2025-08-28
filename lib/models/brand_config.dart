import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brand_config.g.dart';

@JsonSerializable()
class BrandConfig {
  final String brandName;
  final String appTitle;
  final String splashScreenUrl;
  final String primaryColorHex;
  final String secondaryColorHex;
  final String accentColorHex;
  final String backgroundColorHex;
  final String textColorHex;
  final String fontFamily;
  final Map<String, String> assets;

  const BrandConfig({
    required this.brandName,
    required this.appTitle,
    required this.splashScreenUrl,
    required this.primaryColorHex,
    required this.secondaryColorHex,
    required this.accentColorHex,
    required this.backgroundColorHex,
    required this.textColorHex,
    this.fontFamily = 'Roboto',
    this.assets = const {},
  });

  factory BrandConfig.fromJson(Map<String, dynamic> json) =>
      _$BrandConfigFromJson(json);
  Map<String, dynamic> toJson() => _$BrandConfigToJson(this);

  // Helper methods to convert hex colors to Flutter Colors
  Color get primaryColor => _hexToColor(primaryColorHex);
  Color get secondaryColor => _hexToColor(secondaryColorHex);
  Color get accentColor => _hexToColor(accentColorHex);
  Color get backgroundColor => _hexToColor(backgroundColorHex);
  Color get textColor => _hexToColor(textColorHex);

  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  // Create a ThemeData from this brand configuration
  ThemeData get themeData {
    return ThemeData(
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: textColor, fontFamily: fontFamily),
        titleLarge: TextStyle(color: textColor, fontFamily: fontFamily),
        titleMedium: TextStyle(color: textColor, fontFamily: fontFamily),
        titleSmall: TextStyle(color: textColor, fontFamily: fontFamily),
      ),
      cardTheme: CardThemeData(
        color: _darkenColor(backgroundColor, 0.1),
        elevation: 2,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: textColor,
      ),
    );
  }

  // Helper method to darken a color by a given amount
  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.r.toInt();
    final int g = color.g.toInt();
    final int b = color.b.toInt();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}
