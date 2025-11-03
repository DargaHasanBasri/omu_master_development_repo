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

  /// File path: assets/icons/ic_arrow_back.png
  AssetGenImage get icArrowBack =>
      const AssetGenImage('assets/icons/ic_arrow_back.png');

  /// File path: assets/icons/ic_arrow_back_left.png
  AssetGenImage get icArrowBackLeft =>
      const AssetGenImage('assets/icons/ic_arrow_back_left.png');

  /// File path: assets/icons/ic_bookings.png
  AssetGenImage get icBookings =>
      const AssetGenImage('assets/icons/ic_bookings.png');

  /// File path: assets/icons/ic_dataset.png
  AssetGenImage get icDataset =>
      const AssetGenImage('assets/icons/ic_dataset.png');

  /// File path: assets/icons/ic_download.png
  AssetGenImage get icDownload =>
      const AssetGenImage('assets/icons/ic_download.png');

  /// File path: assets/icons/ic_favourites.png
  AssetGenImage get icFavourites =>
      const AssetGenImage('assets/icons/ic_favourites.png');

  /// File path: assets/icons/ic_file.png
  AssetGenImage get icFile => const AssetGenImage('assets/icons/ic_file.png');

  /// File path: assets/icons/ic_folder.png
  AssetGenImage get icFolder =>
      const AssetGenImage('assets/icons/ic_folder.png');

  /// File path: assets/icons/ic_home.png
  AssetGenImage get icHome => const AssetGenImage('assets/icons/ic_home.png');

  /// File path: assets/icons/ic_profile.png
  AssetGenImage get icProfile =>
      const AssetGenImage('assets/icons/ic_profile.png');

  /// File path: assets/icons/ic_search.png
  AssetGenImage get icSearch =>
      const AssetGenImage('assets/icons/ic_search.png');

  /// File path: assets/icons/ic_settings.png
  AssetGenImage get icSettings =>
      const AssetGenImage('assets/icons/ic_settings.png');

  /// File path: assets/icons/ic_tap.png
  AssetGenImage get icTap => const AssetGenImage('assets/icons/ic_tap.png');

  /// File path: assets/icons/ic_uploaded.png
  AssetGenImage get icUploaded =>
      const AssetGenImage('assets/icons/ic_uploaded.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    icArrowBack,
    icArrowBackLeft,
    icBookings,
    icDataset,
    icDownload,
    icFavourites,
    icFile,
    icFolder,
    icHome,
    icProfile,
    icSearch,
    icSettings,
    icTap,
    icUploaded,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img_welcome.png
  AssetGenImage get imgWelcome =>
      const AssetGenImage('assets/images/img_welcome.png');

  /// List of all assets
  List<AssetGenImage> get values => [imgWelcome];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
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
