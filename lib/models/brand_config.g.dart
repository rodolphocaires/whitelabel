// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandConfig _$BrandConfigFromJson(Map<String, dynamic> json) => BrandConfig(
  brandName: json['brandName'] as String,
  appTitle: json['appTitle'] as String,
  logoPath: json['logoPath'] as String,
  splashScreenUrl: json['splashScreenUrl'] as String,
  primaryColorHex: json['primaryColorHex'] as String,
  secondaryColorHex: json['secondaryColorHex'] as String,
  accentColorHex: json['accentColorHex'] as String,
  backgroundColorHex: json['backgroundColorHex'] as String,
  textColorHex: json['textColorHex'] as String,
  fontFamily: json['fontFamily'] as String? ?? 'Roboto',
  assets:
      (json['assets'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  customSettings: json['customSettings'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$BrandConfigToJson(BrandConfig instance) =>
    <String, dynamic>{
      'brandName': instance.brandName,
      'appTitle': instance.appTitle,
      'logoPath': instance.logoPath,
      'splashScreenUrl': instance.splashScreenUrl,
      'primaryColorHex': instance.primaryColorHex,
      'secondaryColorHex': instance.secondaryColorHex,
      'accentColorHex': instance.accentColorHex,
      'backgroundColorHex': instance.backgroundColorHex,
      'textColorHex': instance.textColorHex,
      'fontFamily': instance.fontFamily,
      'assets': instance.assets,
      'customSettings': instance.customSettings,
    };
