import 'package:flutter/material.dart';
import 'package:stairs/loom/component/input/text_input.dart';

import '../../../loom/theme.dart';
import '../../../loom/component/button/custom_text_button.dart';

const _kBorderWidth = 1.0;
const _kMaxLength = 30;
const _kAddingButtonHeight = 100.0;
const _kAddingIconSize = 16.0;
const _kInputTextAndButtonSpace = 30.0;

const _kAddingTitleTxt = 'ワークボードを追加';
const _kAddingTitleHintTxt = 'ワークボード';

const _kCancelBtnTxt = 'キャンセル';
const _kAddBtnTxt = '追加';

const _kContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
const _kContentMargin = EdgeInsets.only(
  top: 200,
  bottom: 200.0,
  left: 16.0,
  right: 40.0,
);

///ワークボード追加カード画面
class WorkBoardAddingCard extends StatefulWidget {
  const WorkBoardAddingCard({
    super.key,
    required this.themeColor,
    required this.onOpenCard,
    required this.onTapAddingBtn,
  });
  final Color themeColor;
  final VoidCallback onOpenCard;
  final Function(String) onTapAddingBtn;

  @override
  State<StatefulWidget> createState() => _WorkBoardAddingCardState();
}

class _WorkBoardAddingCardState extends State<WorkBoardAddingCard> {
  bool _isAddedNewCard = false;
  final textController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return _isAddedNewCard
        ? Container(
            padding: _kContentPadding,
            margin: _kContentMargin,
            decoration: BoxDecoration(
              color: theme.colorFgDefaultWhite,
              border: Border.all(
                color: theme.colorFgDisabled,
                width: _kBorderWidth,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInput(
                  textController: textController,
                  hintText: _kAddingTitleHintTxt,
                  maxLength: _kMaxLength,
                  autoFocus: true,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: _kInputTextAndButtonSpace,
                ),
                _FooterButtonArea(
                  key: widget.key,
                  themeColor: widget.themeColor,
                  disabled: false,
                  onTapAdd: () {
                    setState(
                      () {
                        _isAddedNewCard = false;
                      },
                    );
                    widget.onTapAddingBtn(textController.text);
                  },
                  onTapCancel: () => setState(
                    () {
                      _isAddedNewCard = false;
                    },
                  ),
                )
              ],
            ),
          )
        : Align(
            child: CustomTextButton(
              title: _kAddingTitleTxt,
              height: _kAddingButtonHeight,
              icon: Icon(
                theme.icons.add,
                size: _kAddingIconSize,
              ),
              themeColor: widget.themeColor,
              disabled: false,
              onTap: () {
                widget.onOpenCard();
                setState(
                  () {
                    _isAddedNewCard = true;
                  },
                );
              },
            ),
          );
  }
}

class _FooterButtonArea extends StatelessWidget {
  const _FooterButtonArea({
    super.key,
    required this.disabled,
    required this.themeColor,
    required this.onTapCancel,
    required this.onTapAdd,
  });
  final bool disabled;
  final Color themeColor;
  final VoidCallback onTapCancel;
  final VoidCallback onTapAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextButton(
          title: _kCancelBtnTxt,
          themeColor: themeColor,
          onTap: onTapCancel,
        ),
        AbsorbPointer(
          absorbing: disabled,
          child: CustomTextButton(
            title: _kAddBtnTxt,
            themeColor: themeColor,
            disabled: disabled,
            onTap: onTapAdd,
          ),
        ),
      ],
    );
  }
}
