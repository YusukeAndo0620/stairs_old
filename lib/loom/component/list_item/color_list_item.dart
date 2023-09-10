import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';

import '/model/model.dart';
import '../item/color_box.dart';
import '../item/check_icon.dart';

const _kBorderWidth = 1.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class ColorListItem extends StatelessWidget {
  const ColorListItem({
    super.key,
    required this.selectedColorId,
    required this.colorInfo,
    required this.onTap,
  });
  final String selectedColorId;
  final ColorInfo colorInfo;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return GestureDetector(
      onTap: () => onTap(colorInfo.id),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorFgDefault,
              width: _kBorderWidth,
            ),
          ),
        ),
        child: Row(
          children: [
            CheckIcon(
              isChecked: selectedColorId == colorInfo.id,
            ),
            Padding(
              padding: _kContentPadding,
              child: ColorBox(
                color: colorInfo.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
