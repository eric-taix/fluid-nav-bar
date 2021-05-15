import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// An immutable style in which paint [FluidNavBar]
///
///
/// {@tool sample}
/// Here, a [FluidNavBar] with a given specific style which overrides the default color style of the background
///
/// ```dart
/// FluidNavBar(
///   icons: [
///     FluidNavBarIcon(iconPath: "assets/home.svg"),
///     FluidNavBarIcon(iconPath: "assets/bookmark.svg"),
///   ],
///   style: FluidNavBarStyle(
///     backgroundColor: Colors.red,
/// )
/// ```
/// {@end-tool}
@immutable
class FluidNavBarStyle with Diagnosticable {
  /// The navigation bar background color
  final Color? barBackgroundColor;

  /// Icons background color
  final Color? iconBackgroundColor;

  /// Icons color when activated
  final Color? iconSelectedForegroundColor;

  /// Icons color when inactivated
  final Color? iconUnselectedForegroundColor;

  const FluidNavBarStyle({
    this.barBackgroundColor,
    this.iconBackgroundColor,
    this.iconSelectedForegroundColor,
    this.iconUnselectedForegroundColor,
  });
}
