import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/svg.dart';

import 'curves.dart';

typedef void FluidNavBarButtonPressedCallback();

class FluidNavBarButton extends StatefulWidget {
  final String iconPath;
  final bool selected;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color activeColor;
  final double minScale;
  final double maxScale;

  final FluidNavBarButtonPressedCallback onPressed;

  FluidNavBarButton({
    this.iconPath,
    this.selected = false,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.grey,
    this.activeColor = Colors.black,
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State createState() {
    return _FluidNavBarButtonState(selected);
  }
}

class _FluidNavBarButtonState extends State<FluidNavBarButton> with SingleTickerProviderStateMixin {
  static const double _activeOffset = 16;
  static const double _defaultOffset = 0;
  static const double _radius = 25;

  bool _selected;

  AnimationController _animationController;
  Animation<double> _animation;

  _FluidNavBarButtonState(this._selected);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1666),
      reverseDuration: const Duration(milliseconds: 833),
      vsync: this,
    )..addListener(() => setState(() {}));

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: LinearPointCurve(0.28, 0.0)));

    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    const ne = const Size(64, 64);

    final offsetCurve = _selected ? ElasticOutCurve(0.38) : Curves.easeInCirc;
    final offset = Tween<double>(begin: _defaultOffset, end: _activeOffset).transform(
      offsetCurve.transform(_animation.value),
    );
    final scale = Tween<double>(begin: widget.minScale, end: widget.maxScale).transform(offsetCurve.transform(_animation.value));

    final clipCurve = _selected ? Interval(0.31, 0.42, curve: Curves.easeOutQuint) : Interval(0.5, 0.8, curve: Curves.easeInCirc);
    final clip = Tween<double>(begin: 0.0, end: _radius * scale).transform(clipCurve.transform(_animationController.value));

    return GestureDetector(
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints.tight(ne),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(ne.width / 2 - _radius),
          constraints: BoxConstraints.tight(Size.square(_radius * 2)),
          decoration: ShapeDecoration(
            color: widget.backgroundColor,
            shape: CircleBorder(),
          ),
          transform: Matrix4.translationValues(0, -offset, 0),
          child: Stack(children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  widget.iconPath,
                  color: widget.foregroundColor,
                  width: _radius * scale,
                  height: _radius * scale,
                  colorBlendMode: BlendMode.srcATop,
                )),
            Container(
                alignment: Alignment.center,
                child: ClipRect(
                  clipper: _SvgPictureClipper(clip),
                  child: SvgPicture.asset(
                    widget.iconPath,
                    color: widget.activeColor,
                    width: _radius * scale,
                    height: _radius * scale,
                    colorBlendMode: BlendMode.srcATop,
                  ),
                )),
          ]),
        ),
      ),
    );
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

  void _startAnimation() {
    if (_selected) {
      _animationController.forward();
    } else {
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
