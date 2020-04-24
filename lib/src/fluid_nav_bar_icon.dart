import 'package:flutter/cupertino.dart';

/// An icon definition used as child by [FluidNavBar]
///
/// See also:
///
///  * [FluidNavBar]

class FluidNavBarIcon {
  /// The path of the SVG asset
  final String iconPath;

  /// The color used to paint the SVG when the item is active
  final Color selectedForegroundColor;

  /// The color used to paint the SVG when the item is inactive
  final Color unselectedForegroundColor;

  /// The background color of the item
  final Color backgroundColor;

  FluidNavBarIcon(
      {@required this.iconPath,
      this.selectedForegroundColor,
      this.unselectedForegroundColor,
      this.backgroundColor});
}
