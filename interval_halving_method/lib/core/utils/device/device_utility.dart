import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:interval_halving_method/core/utils/constants/app_sizes.dart';

class DeviceUtility {
  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.desktopScreenSize;
  }

  static bool isTabletScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.tabletScreenSize &&
        MediaQuery.of(context).size.width < AppSizes.desktopScreenSize;
  }

  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.tabletScreenSize;
  }
}
