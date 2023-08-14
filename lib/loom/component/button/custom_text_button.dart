import 'package:flutter/material.dart';
import '../../../loom/theme.dart';
import '../../../loom/component/item/tap_action.dart';

const _kBorderWidth = 1.0;
const _kMinWidth = 100.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);

/// テキストボタン
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.themeColor,
    required this.onTap,
  });
  final String title;
  final Color themeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return TapAction(
      key: key,
      minWidth: _kMinWidth,
      padding: _kContentPadding,
      border: Border.all(
        color: themeColor,
        width: _kBorderWidth,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.circular(5.0),
      tappedColor: themeColor,
      onTap: onTap,
      widget: Text(
        title,
        style: theme.textStyleBody,
        textAlign: TextAlign.center,
      ),
    );
  }
}
