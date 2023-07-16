import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';
import '../input/text_input.dart';
import '../event_area.dart';

const _kListItemBorder = 1.0;
const _kSpaceWidth = 16.0;
const _kBoardListTitlePadding = EdgeInsets.symmetric(vertical: 16.0);

class LinkListItem extends StatelessWidget {
  const LinkListItem({
    super.key,
    required this.inputValue,
    required this.hintText,
    this.maxLength = 100,
    this.autoFocus = false,
    required this.onTextSubmitted,
    required this.linkedValue,
    required this.onTap,
  });

  final String inputValue;
  final String hintText;
  final List<String> linkedValue;
  final int maxLength;
  final bool autoFocus;
  final Function(String) onTextSubmitted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        width: double.infinity,
        padding: _kBoardListTitlePadding,
        decoration: BoxDecoration(
          color: theme.colorFgDefaultWhite,
          border: Border(
            bottom: BorderSide(
              color: theme.colorFgDefault,
              width: _kListItemBorder,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextInput(
              iconColor: theme.colorPrimary,
              textController: TextEditingController(text: inputValue),
              hintText: hintText,
              maxLength: maxLength,
              autoFocus: autoFocus,
              onSubmitted: onTextSubmitted,
            ),
            const SizedBox(
              width: _kSpaceWidth,
            ),
            EventArea(
              itemList:
                  getLinkValueList(context: context, linkedValue: linkedValue),
              hintText: hintText,
              trailingIconData: Icons.expand_more,
              onTap: onTap,
            ),
          ],
        ));
  }

  List<Widget> getLinkValueList({
    required BuildContext context,
    required List<String> linkedValue,
  }) {
    final theme = Theme.of(context);
    return linkedValue
        .map((item) => Text(
              item,
              style: theme.textStyleBody,
            ))
        .toList();
  }
}
