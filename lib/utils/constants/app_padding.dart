import 'package:flutter/material.dart';

final class AppPaddings {
  AppPaddings._();

  /// Equal padding values from all directions
  static const xXSmallAll = EdgeInsets.all(4);
  static const xSmallAll = EdgeInsets.all(8);
  static const smallAll = EdgeInsets.all(12);
  static const mediumAll = EdgeInsets.all(16);
  static const largeAll = EdgeInsets.all(24);
  static const xLargeAll = EdgeInsets.all(32);

  /// Vertical padding values
  static const xXSmallHorizontal = EdgeInsets.symmetric(horizontal: 4);
  static const xSmallHorizontal = EdgeInsets.symmetric(horizontal: 8);
  static const smallHorizontal = EdgeInsets.symmetric(horizontal: 12);
  static const mediumHorizontal = EdgeInsets.symmetric(horizontal: 16);
  static const largeHorizontal = EdgeInsets.symmetric(horizontal: 24);
  static const xLargeHorizontal = EdgeInsets.symmetric(horizontal: 32);

  /// Horizontal padding values
  static const xXSmallVertical = EdgeInsets.symmetric(vertical: 4);
  static const xSmallVertical = EdgeInsets.symmetric(vertical: 8);
  static const smallVertical = EdgeInsets.symmetric(vertical: 12);
  static const mediumVertical = EdgeInsets.symmetric(vertical: 16);
  static const largeVertical = EdgeInsets.symmetric(vertical: 24);
  static const xLargeVertical = EdgeInsets.symmetric(vertical: 32);

  /// Top padding values
  static const xSmallTop = EdgeInsets.only(top: 4);
  static const smallTop = EdgeInsets.only(top: 8);
  static const mediumTop = EdgeInsets.only(top: 16);
  static const largeTop = EdgeInsets.only(top: 24);
  static const xLargeTop = EdgeInsets.only(top: 32);
  static const xXLargeTop = EdgeInsets.only(top: 48);

  /// Bottom padding values
  static const xSmallBottom = EdgeInsets.only(bottom: 4);
  static const smallBottom = EdgeInsets.only(bottom: 8);
  static const mediumBottom = EdgeInsets.only(bottom: 16);
  static const largeBottom = EdgeInsets.only(bottom: 24);
  static const xLargeBottom = EdgeInsets.only(bottom: 32);

  /// Left padding values
  static const xSmallLeft = EdgeInsets.only(left: 4);
  static const smallLeft = EdgeInsets.only(left: 8);
  static const mediumLeft = EdgeInsets.only(left: 16);
  static const largeLeft = EdgeInsets.only(left: 24);
  static const xLargeLeft = EdgeInsets.only(left: 32);
  static const xXLargeLeft = EdgeInsets.only(left: 64);

  /// Right padding values
  static const xXSmallRight = EdgeInsets.only(right: 4);
  static const xSmallRight = EdgeInsets.only(right: 8);
  static const smallRight = EdgeInsets.only(right: 12);
  static const mediumRight = EdgeInsets.only(right: 16);
  static const largeRight = EdgeInsets.only(right: 24);
  static const xLargeRight = EdgeInsets.only(right: 32);
}
