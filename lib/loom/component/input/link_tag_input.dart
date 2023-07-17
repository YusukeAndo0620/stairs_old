import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';
import '../input/text_input.dart';
import '../event_area.dart';
import '../../component/label_tip.dart';
import '../../../model/model.dart';

const _kListItemBorder = 1.0;
const _kCDeleteIconSize = 16.0;
const _kSpaceWidth = 16.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 16.0);

// Input text area and add tag area
class LinkTagInput extends StatelessWidget {
  const LinkTagInput({
    super.key,
    required this.id,
    required this.inputValue,
    required this.hintText,
    required this.tagHintText,
    this.maxLength = 100,
    this.autoFocus = false,
    required this.linkedValue,
    required this.onTextSubmitted,
    required this.onTap,
    required this.onDeleteItem,
  });

  final int id;
  final String inputValue;
  final String hintText;
  final String tagHintText;
  final List<LabelInfo> linkedValue;
  final int maxLength;
  final bool autoFocus;
  final Function(String, int) onTextSubmitted;
  final Function(int) onTap;
  final Function(String) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: theme.colorFgDefaultWhite,
        border: Border(
          bottom: BorderSide(
            color: theme.colorFgDisabled,
            width: _kListItemBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextInput(
              iconColor: theme.colorPrimary,
              textController: TextEditingController(text: inputValue),
              hintText: hintText,
              maxLength: maxLength,
              autoFocus: autoFocus,
              onSubmitted: (value) => onTextSubmitted(value, id),
            ),
          ),
          const SizedBox(
            width: _kSpaceWidth,
          ),
          EventArea(
            itemList:
                getLinkValueList(context: context, linkedValue: linkedValue),
            hintText: tagHintText,
            trailingIconData: Icons.expand_more,
            onTap: () => onTap(id),
          ),
          const SizedBox(
            width: _kSpaceWidth,
          ),
          IconButton(
            icon: Icon(
              theme.icons.close,
            ),
            iconSize: _kCDeleteIconSize,
            onPressed: () => onDeleteItem(inputValue),
          ),
        ],
      ),
    );
  }

  List<Widget> getLinkValueList({
    required BuildContext context,
    required List<LabelInfo> linkedValue,
  }) {
    return linkedValue
        .map((item) => LabelTip(
              label: item.labelName,
              themeColor: item.themeColor,
            ))
        .toList();
  }
}
