import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';
import '../../display/select_label_display_bloc.dart';

const _kBorderWidth = 1.0;
const _kCheckIconBoxSize = 40.0;
const _kCheckIconSize = 20.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class CheckListItem extends StatelessWidget {
  const CheckListItem({
    super.key,
    required this.info,
    required this.onTap,
  });
  final CheckLabel info;
  final Function(CheckLabel) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return GestureDetector(
      onTap: () => onTap(info),
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
              isChecked: info.checked,
            ),
            Padding(
                padding: _kContentPadding,
                child: Text(
                  info.labelName,
                  style: theme.textStyleBody,
                )),
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
    final theme = LoomTheme.of(context);
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
