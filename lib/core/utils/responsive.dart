import 'package:flutter/material.dart';

class Responsive {
  static double _screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // Breakpoints
  static bool isMobile(BuildContext context) => _screenWidth(context) < 600;
  static bool isTablet(BuildContext context) =>
      _screenWidth(context) >= 600 && _screenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) => _screenWidth(context) >= 1200;

  // Responsive width
  static double width(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // Responsive height
  static double height(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // Responsive font size
  static double fontSize(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // Responsive padding
  static EdgeInsets padding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    final mobileAll = all ?? 16.0;
    final mobileH = horizontal ?? mobileAll;
    final mobileV = vertical ?? mobileAll;

    final tabletAll = all != null ? all * 1.5 : 24.0;
    final tabletH = horizontal != null ? horizontal * 1.5 : tabletAll;
    final tabletV = vertical != null ? vertical * 1.5 : tabletAll;

    final desktopAll = all != null ? all * 2 : 32.0;
    final desktopH = horizontal != null ? horizontal * 2 : desktopAll;
    final desktopV = vertical != null ? vertical * 2 : desktopAll;

    final h = width(context, mobileH, tabletH, desktopH);
    final v = height(context, mobileV, tabletV, desktopV);

    return EdgeInsets.only(
      left: left ?? h,
      right: right ?? h,
      top: top ?? v,
      bottom: bottom ?? v,
    );
  }

  // Responsive spacing
  static double spacing(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    return height(context, mobile, tablet, desktop);
  }

  // Responsive icon size
  static double iconSize(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    return width(context, mobile, tablet, desktop);
  }

  // Responsive border radius
  static double borderRadius(BuildContext context, double mobile, [double? tablet, double? desktop]) {
    return width(context, mobile, tablet, desktop);
  }

  // Max width for content
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }
}

