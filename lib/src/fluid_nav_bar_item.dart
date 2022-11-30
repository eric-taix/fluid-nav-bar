import 'dart:math';

import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:fluid_bottom_nav_bar/src/fluid_nav_bar_icon.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'curves.dart';

typedef void FluidNavBarButtonTappedCallback();

/// An interactive button within [FluidNavBar]
///
/// This class is not used in isolation. It is created by
/// fluid navigation bar widget according to [FluidNavBarIcon] definition.
///
/// See also:
///
///  * [FluidNavBar]
///  * [FluidNavBarIcon]

class FluidNavBarItem extends StatefulWidget {
  static const nominalExtent = const Size(64, 64);

  /// The badge amount
  final int? badge;

  // The background color of the badge container
  final Color? badgeBackgroundColor;

  // The color used to badge text
  final Color? badgeTextColor;

  // The icon or svg size
  final double? size;

  /// The path of the SVG asset
  final String? svgPath;

  // The icon data
  final IconData? icon;

  /// Flag to know if this item is active or not
  final bool selected;

  /// The color used to paint the SVG when the item is active
  final Color selectedForegroundColor;

  /// The color used to paint the SVG when the item is inactive
  final Color unselectedForegroundColor;

  /// The background color of the item
  final Color backgroundColor;

  /// The temporary SVG scale used when the item pop
  final double scaleFactor;

  /// The callback used when the item is tapped
  final FluidNavBarButtonTappedCallback onTap;

  /// The delay factor of the animations ( < 1 is faster, > 1 is slower)
  final double animationFactor;

  FluidNavBarItem({
    this.size,
    this.badge,
    this.badgeBackgroundColor,
    this.badgeTextColor,
    this.svgPath,
    this.icon,
    required this.selected,
    required this.onTap,
    required this.selectedForegroundColor,
    required this.unselectedForegroundColor,
    required this.backgroundColor,
    required this.scaleFactor,
    required this.animationFactor,
  })  : assert(scaleFactor >= 1.0),
        assert(svgPath == null || icon == null, 'Cannot provide both an iconPath and an icon.'),
        assert(!(svgPath == null && icon == null), 'An iconPath or an icon must be provided.');

  @override
  State createState() {
    return _FluidNavBarItemState(selected);
  }
}

class _FluidNavBarItemState extends State<FluidNavBarItem> with SingleTickerProviderStateMixin {
  static const double _activeOffset = 16;
  static const double _defaultOffset = 0;
  static const double _iconSize = 25;

  bool _selected;

  late AnimationController _animationController;
  late Animation<double> _activeColorClipAnimation;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _activatingAnimation;
  late Animation<double> _inactivatingAnimation;
  late Animation<Color?> _activateBadgeColor;

  _FluidNavBarItemState(this._selected);

  @override
  void initState() {
    super.initState();

    double waveRatio = 0.28;
    _animationController = AnimationController(
      duration: Duration(milliseconds: (1600 * widget.animationFactor).toInt()),
      reverseDuration: Duration(milliseconds: (1000 * widget.animationFactor).toInt()),
      vsync: this,
    )..addListener(() => setState(() {}));

    _activeColorClipAnimation = Tween<double>(begin: 0.0, end: (widget.size ?? _iconSize)).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.25, 0.38, curve: Curves.easeOut),
      reverseCurve: Interval(0.7, 1.0, curve: Curves.easeInCirc),
    ));

    _activateBadgeColor = ColorTween(
      begin: Colors.grey,
      end: widget.badgeBackgroundColor ?? Colors.red[700],
    ).animate(_animationController);

    var _animation = CurvedAnimation(parent: _animationController, curve: LinearPointCurve(waveRatio, 0.0));

    _yOffsetAnimation = Tween<double>(begin: _defaultOffset, end: _activeOffset).animate(CurvedAnimation(
      parent: _animation,
      curve: ElasticOutCurve(0.38),
      reverseCurve: Curves.easeInCirc,
    ));

    var activatingHalfTween = Tween<double>(begin: 1, end: widget.scaleFactor);
    _activatingAnimation = TweenSequence([
      TweenSequenceItem(tween: activatingHalfTween, weight: 50.0),
      TweenSequenceItem(tween: ReverseTween<double>(activatingHalfTween), weight: 50.0),
    ]).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.0, 0.3),
    ));
    _inactivatingAnimation = ConstantTween<double>(1.0).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.3, 1.0),
    ));

    _startAnimation();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.selected != _selected) {
      setState(() {
        _selected = widget.selected;
      });
      _startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    const ne = FluidNavBarItem.nominalExtent;

    final scaleAnimation = _selected ? _activatingAnimation : _inactivatingAnimation;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints.tight(ne),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(ne.width / 2 - min(widget.size ?? _iconSize, _iconSize)),
          constraints: BoxConstraints.tight(Size.square((widget.size ?? _iconSize) * 2)),
          decoration: ShapeDecoration(
            color: widget.backgroundColor,
            shape: CircleBorder(),
          ),
          transform: Matrix4.translationValues(0, -_yOffsetAnimation.value, 0),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: widget.icon == null
                    ? SvgPicture.asset(
                        widget.svgPath!,
                        color: widget.unselectedForegroundColor,
                        width: (widget.size ?? _iconSize),
                        height: (widget.size ?? _iconSize) * scaleAnimation.value,
                        colorBlendMode: BlendMode.srcIn,
                      )
                    : Icon(
                        widget.icon,
                        color: widget.unselectedForegroundColor,
                        size: (widget.size ?? _iconSize) * scaleAnimation.value,
                      ),
              ),
              Container(
                alignment: Alignment.center,
                child: ClipRect(
                  clipper: _SvgPictureClipper(_activeColorClipAnimation.value * scaleAnimation.value),
                  child: widget.icon == null
                      ? SvgPicture.asset(
                          widget.svgPath!,
                          color: widget.selectedForegroundColor,
                          width: (widget.size ?? _iconSize),
                          height: (widget.size ?? _iconSize) * scaleAnimation.value,
                          colorBlendMode: BlendMode.srcIn,
                        )
                      : Icon(
                          widget.icon,
                          color: widget.selectedForegroundColor,
                          size: (widget.size ?? _iconSize) * scaleAnimation.value,
                        ),
                ),
              ),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.all(3),
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  child: Text(
                    widget.badge! >= 10 ? "+9" : widget.badge.toString(),
                    style: TextStyle(
                      color: widget.badgeTextColor ?? Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  transform: Matrix4.translationValues(
                    (widget.size ?? _iconSize) + 5,
                    -(((widget.size ?? _iconSize) - 12) * scaleAnimation.value),
                    0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _activateBadgeColor.value,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _startAnimation() {
    if (_selected) {
      _animationController.forward();
    } else {
      // Required otherwise the CurvedAnimation uses the standard curve instead of the reverseCurve
      // if the animation is not completed: so set it as completed before calling reverse.
      _animationController.value = 1.0;
      _animationController.reverse();
    }
  }
}

class _SvgPictureClipper extends CustomClipper<Rect> {
  final double height;

  _SvgPictureClipper(this.height);

  @override
  Rect getClip(Size size) {
    return Rect.fromPoints(size.topLeft(Offset.zero), size.topRight(Offset.zero) + Offset(0, height));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
