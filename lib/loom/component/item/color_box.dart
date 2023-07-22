import 'package:flutter/material.dart' hide Theme;

const _kColorWidth = 30.0;
const _kColorHeight = 30.0;
const _kColorRadius = 20.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);

class ColorBox extends StatelessWidget {
  const ColorBox({
    super.key,
    this.width = _kColorWidth,
    this.height = _kColorHeight,
    required this.color,
  });
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _kColorHeight,
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(_kColorRadius)),
      ),
    );
  }
}
