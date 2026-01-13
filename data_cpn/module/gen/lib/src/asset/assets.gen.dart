// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_data.png
  AssetGenImage get icData => const AssetGenImage('assets/icons/ic_data.png');

  /// File path: assets/icons/ic_epoch_run.png
  AssetGenImage get icEpochRun =>
      const AssetGenImage('assets/icons/ic_epoch_run.png');

  /// File path: assets/icons/ic_info.png
  AssetGenImage get icInfo => const AssetGenImage('assets/icons/ic_info.png');

  /// File path: assets/icons/ic_loading_data.png
  AssetGenImage get icLoadingData =>
      const AssetGenImage('assets/icons/ic_loading_data.png');

  /// File path: assets/icons/ic_logo.png
  AssetGenImage get icLogo => const AssetGenImage('assets/icons/ic_logo.png');

  /// File path: assets/icons/ic_mse_test.png
  AssetGenImage get icMseTest =>
      const AssetGenImage('assets/icons/ic_mse_test.png');

  /// File path: assets/icons/ic_mse_training.png
  AssetGenImage get icMseTraining =>
      const AssetGenImage('assets/icons/ic_mse_training.png');

  /// File path: assets/icons/ic_plus.png
  AssetGenImage get icPlus => const AssetGenImage('assets/icons/ic_plus.png');

  /// File path: assets/icons/ic_settings.png
  AssetGenImage get icSettings =>
      const AssetGenImage('assets/icons/ic_settings.png');

  /// File path: assets/icons/ic_start_educate.png
  AssetGenImage get icStartEducate =>
      const AssetGenImage('assets/icons/ic_start_educate.png');

  /// File path: assets/icons/ic_training_time.png
  AssetGenImage get icTrainingTime =>
      const AssetGenImage('assets/icons/ic_training_time.png');

  /// File path: assets/icons/ic_welcome.png
  AssetGenImage get icWelcome =>
      const AssetGenImage('assets/icons/ic_welcome.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    icData,
    icEpochRun,
    icInfo,
    icLoadingData,
    icLogo,
    icMseTest,
    icMseTraining,
    icPlus,
    icSettings,
    icStartEducate,
    icTrainingTime,
    icWelcome,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
