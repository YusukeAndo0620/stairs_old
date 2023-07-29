import 'package:flutter/material.dart' hide Theme;
import '../../../loom/theme.dart';

const _kContentSpaceHeight = 24.0;
const _kIconSize = 50.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0);

/// アイテムがない際の画面
class EmptyDisplay extends StatelessWidget {
  const EmptyDisplay({
    super.key,
    this.iconData = Icons.abc_outlined,
    this.width,
    required this.message,
  });
  final double? width;
  final IconData iconData;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      padding: _kContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: _kIconSize,
          ),
          const SizedBox(
            height: _kContentSpaceHeight,
          ),
          Text(
            message,
            style: theme.textStyleBody,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
