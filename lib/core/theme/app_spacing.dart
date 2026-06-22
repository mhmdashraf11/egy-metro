import 'package:flutter/material.dart';

abstract class AppSpacing {
  // Base unit
  static const double unit = 8.0;
  
  // Stacking (Vertical)
  static const double stackSm = 8.0;
  static const double stackMd = 16.0;
  static const double stackLg = 24.0;
  
  // Layout
  static const double marginMobile = 20.0;
  static const double gutter = 16.0;
  
  // Legacy compatibility (if needed)
  static const double base = 8.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  
  // Edge Insets helpers
  static const EdgeInsets edgeInsetsXS = EdgeInsets.all(xs);
  static const EdgeInsets edgeInsetsSM = EdgeInsets.all(sm);
  static const EdgeInsets edgeInsetsMD = EdgeInsets.all(md);
  static const EdgeInsets edgeInsetsLG = EdgeInsets.all(lg);
  static const EdgeInsets edgeInsetsXL = EdgeInsets.all(xl);
  
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: marginMobile);
  static const EdgeInsets stackPaddingSm = EdgeInsets.symmetric(vertical: stackSm);
  static const EdgeInsets stackPaddingMd = EdgeInsets.symmetric(vertical: stackMd);
  static const EdgeInsets stackPaddingLg = EdgeInsets.symmetric(vertical: stackLg);
}
