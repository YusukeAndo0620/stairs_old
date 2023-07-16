import 'package:flutter/material.dart';

TextStyle textStyleBody(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

TextStyle textStyleFootnote(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.66,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

TextStyle textStyleTitle(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

TextStyle textStyleSubtitle(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

TextStyle textStyleHeading(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

TextStyle textStyleSubHeading(Color color) {
  return TextStyle(
    fontFamily: '',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );
}

extension TextStyleExtension on TextStyle {
  TextStyle copyWith({
    required Color? newColor,
    required double? newFontSize,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: newFontSize ?? fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      leadingDistribution: leadingDistribution,
      color: newColor ?? color,
    );
  }
}
