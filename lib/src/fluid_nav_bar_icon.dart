import 'package:flutter/cupertino.dart';

/// An icon definition used as child by [FluidNavBar]
///
/// See also:
///
///  * [FluidNavBar]

class FluidNavBarIcon {
  /// The path of the SVG asset
  @deprecated
  final String? iconPath;

  /// The SVG path
  final String? svgPath;

  /// The icon data
  final IconData? icon;

  /// The color used to paint the SVG when the item is active
  final Color? selectedForegroundColor;

  /// The color used to paint the SVG when the item is inactive
  final Color? unselectedForegroundColor;

  /// The background color of the item
  final Color? backgroundColor;

  /// Extra information which can be used in [FluidNavBarItemBuilder]
  final Map<String, dynamic>? extras;

  FluidNavBarIcon({
    this.iconPath,
    this.svgPath,
    this.icon,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.backgroundColor,
    this.extras,
  })  : assert(iconPath == null || svgPath == null || icon == null, 'Cannot provide both an svgPath and an icon.'),
        assert(iconPath != null || svgPath != null || icon != null, 'An svgPath or an icon must be provided.');
}
