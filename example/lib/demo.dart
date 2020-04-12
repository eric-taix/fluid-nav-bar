import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'content/home.dart';
import 'content/account.dart';
import 'content/grid.dart';

class FluidNavBarDemo extends StatefulWidget {
  @override
  State createState() {
    return _FluidNavBarDemoState();
  }
}

class _FluidNavBarDemoState extends State {
  Widget _child;

  @override
  void initState() {
    _child = HomeContent();
    super.initState();
  }

  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF75B7E1),
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(iconPath: "assets/home.svg", backgroundColor: Color(0xFF4285F4)),
            FluidNavBarIcon(iconPath: "assets/bookmark.svg", backgroundColor: Color(0xFFEC4134)),
            FluidNavBarIcon(iconPath: "assets/partner.svg", backgroundColor: Color(0xFFFCBA02)),
            FluidNavBarIcon(iconPath: "assets/conference.svg", backgroundColor: Color(0xFF34A950)),
          ],
          onChange: _handleNavigationChange,
         style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.white
          ),
          scaleFactor: 1.5,
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = HomeContent();
          break;
        case 1:
          _child = AccountContent();
          break;
        case 2:
          _child = GridContent();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
