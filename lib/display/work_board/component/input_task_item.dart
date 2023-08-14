import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../loom/theme.dart';
import '../../../model/model.dart';
import '../../../loom/component/input/text_input.dart';
import '../../../loom/component/item/tap_action.dart';
import '../../../loom/component/label_tip.dart';

const _kBorderWidth = 1.0;
const _kTaskHintTxt = 'タスク名を入力';
const _kTaskMaxLength = 100;
const _kLabelIconSize = 16.0;
const _kTitleAndLabelSpace = 24.0;

const _kContentPadding = EdgeInsets.all(8.0);
const _kLabelContentPadding = EdgeInsets.only(right: 8.0, bottom: 8.0);
const _kContentMargin = EdgeInsets.symmetric(vertical: 4.0);

/// 新規タスク入力アイテム
class InputTaskItem extends StatelessWidget {
  const InputTaskItem({
    super.key,
    required this.inputValue,
    required this.dueDate,
    required this.labelList,
    required this.themeColor,
    required this.onTextSubmitted,
  });
  final String inputValue;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
  final Color themeColor;
  final Function(String) onTextSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Container(
      width: double.infinity,
      padding: _kContentPadding,
      margin: _kContentMargin,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorFgDisabled,
          width: _kBorderWidth,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInput(
            textController: TextEditingController(text: inputValue),
            hintText: _kTaskHintTxt,
            maxLength: _kTaskMaxLength,
            autoFocus: true,
            onSubmitted: (value) => onTextSubmitted(value),
          ),
          const SizedBox(
            height: _kTitleAndLabelSpace,
          ),
          Row(
            children: [
              Padding(
                padding: _kLabelContentPadding,
                child: TapAction(
                  widget: LabelTip(
                    type: LabelTipType.square,
                    label: _getFormattedDate(dueDate),
                    textColor: dueDate.difference(DateTime.now()).inDays < 3
                        ? theme.colorDangerBgDefault
                        : theme.colorFgDefault,
                    themeColor: theme.colorDisabled,
                    iconData: Icons.date_range,
                  ),
                  tappedColor: themeColor,
                  onTap: () async {
                    DateTime? range = await showDatePicker(
                      context: context,
                      initialDate: dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialEntryMode: DatePickerEntryMode.calendar,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: themeColor, // ヘッダー背景色
                              onPrimary: LoomTheme.of(context)
                                  .colorBgLayer1, // ヘッダーテキストカラー
                              onSurface: LoomTheme.of(context)
                                  .colorFgDefault, // カレンダーのテキストカラー
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: _kLabelContentPadding,
                child: IconButton(
                  icon: const Icon(
                    Icons.label,
                    size: _kLabelIconSize,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

String _getFormattedDate(DateTime date) =>
    '${date.year}/${date.month}/${date.day}';
