import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';

import '/model/model.dart';
import '../item/color_box.dart';

const _kBorderWidth = 1.0;
const _kCheckIconBoxSize = 40.0;
const _kCheckIconSize = 20.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class ColorListItem extends StatelessWidget {
  const ColorListItem({
    super.key,
    required this.selectedColorId,
    required this.colorInfo,
    required this.onTap,
  });
  final int selectedColorId;
  final ColorInfo colorInfo;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

class CheckIcon extends StatelessWidget {
  const CheckIcon({
    super.key,
    required this.isChecked,
  });
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isChecked
        ? SizedBox(
            width: _kCheckIconBoxSize,
            child: IconButton(
              icon: Icon(
                theme.icons.done,
                color: theme.colorPrimary,
              ),
              iconSize: _kCheckIconSize,
              onPressed: () {},
            ),
          )
        : const SizedBox(
            width: _kCheckIconBoxSize,
          );
  }
}
