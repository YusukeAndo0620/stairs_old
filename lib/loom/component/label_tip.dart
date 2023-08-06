import 'package:flutter/material.dart' hide Theme;
import '/loom/theme.dart';

const _kBorder = 1.0;
const _kContentWidth = 120.0;

const _kContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0);

enum LabelTipType {
  circle,
  square,
}

class LabelTip extends StatelessWidget {
  const LabelTip({
    super.key,
    this.width = _kContentWidth,
    required this.label,
    required this.themeColor,
    this.type = LabelTipType.circle,
  });

  final double width;
  final String label;
  final Color themeColor;
  final LabelTipType type;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.all(
            Radius.circular(type == LabelTipType.circle ? 20.0 : 5.0)),
        border: Border.all(
          color: themeColor,
          width: _kBorder,
        ),
      ),
      child: Text(
        label,
        style: theme.textStyleFootnote.copyWith(color: theme.colorFgDefault),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
