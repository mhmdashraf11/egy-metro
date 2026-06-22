import 'package:flutter/material.dart';

abstract class AppShapes {
  static const double radiusXS = 4.0; // 0.25rem
  static const double radiusDefault = 8.0; // 0.5rem
  static const double radiusMD = 12.0; // 0.75rem
  static const double radiusLG = 16.0; // 1rem
  static const double radiusXL = 24.0; // 1.5rem
  static const double radiusFull = 9999.0;
  
  // BorderRadius
  static const BorderRadius borderXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderDefault = BorderRadius.all(Radius.circular(radiusDefault));
  static const BorderRadius borderMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(radiusFull));
  
  // Specialized shapes
  static const BorderRadius bottomSheetBorder = BorderRadius.vertical(top: Radius.circular(radiusXL));
}
