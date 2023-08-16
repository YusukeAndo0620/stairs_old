import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/model.dart';
import '../../../loom/theme.dart';
import '../../../loom/component/modal/select_item_modal.dart';
import '../../../loom/component/input/text_input.dart';
import '../../../loom/component/item/tap_action.dart';
import '../../../loom/component/label_tip.dart';
import '../../../loom/component/item/icon_badge.dart';
import 'input_task_item_bloc.dart';

const _kBorderWidth = 1.0;
const _kLabelTxt = 'ラベル';
const _kTaskHintTxt = 'タスク名を入力';
const _kTaskMaxLength = 100;
const _kLabelIconSize = 32.0;
const _kTitleAndLabelSpace = 24.0;

const _kContentPadding = EdgeInsets.all(8.0);
const _kDateContentPadding = EdgeInsets.only(right: 24.0);
const _kContentMargin = EdgeInsets.symmetric(vertical: 4.0);

/// 新規タスク入力アイテム
class InputTaskItem extends StatelessWidget {
  const InputTaskItem({
    super.key,
    required this.id,
    required this.themeColor,
    required this.labelList,
  });
  final String id;
  final Color themeColor;
  final List<ColorLabelInfo> labelList;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return BlocBuilder<InputTaskItemBloc, InputTaskItemBlocState>(
      builder: (context, state) {
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
                textController: TextEditingController(text: state.inputValue),
                hintText: _kTaskHintTxt,
                maxLength: _kTaskMaxLength,
                autoFocus: true,
                onSubmitted: (value) => context
                    .read<InputTaskItemBloc>()
                    .add(UpdateInputValue(inputValue: value)),
              ),
              const SizedBox(
                height: _kTitleAndLabelSpace,
              ),
              Row(
                children: [
                  Padding(
                    padding: _kDateContentPadding,
                    child: TapAction(
                      widget: LabelTip(
                        type: LabelTipType.square,
                        label: _getFormattedDate(state.dueDate),
                        textColor:
                            state.dueDate.difference(DateTime.now()).inDays < 3
                                ? theme.colorDangerBgDefault
                                : theme.colorFgDefault,
                        themeColor: theme.colorDisabled,
                        iconData: Icons.date_range,
                      ),
                      tappedColor: themeColor,
                      onTap: () async {
                        final bloc = context.read<InputTaskItemBloc>();
                        DateTime? targetDate = await showDatePicker(
                          context: context,
                          initialDate: state.dueDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                        if (targetDate != null) {
                          bloc.add(UpdateDueDate(dueDate: targetDate));
                        }
                      },
                    ),
                  ),
                  IconBadge(
                    icon: Icon(
                      Icons.label,
                      size: _kLabelIconSize,
                      color: themeColor.withOpacity(0.6),
                    ),
                    badgeColor: themeColor,
                    tappedColor: themeColor,
                    count: state.labelList.length,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return SelectItemModal(
                          id: id,
                          type: DisplayType.tile,
                          title: _kLabelTxt,
                          height: MediaQuery.of(context).size.height * 0.7,
                          labelList: labelList,
                          selectedLabelList: state.labelList,
                          onTapListItem: (linkLabelList) {
                            context.read<InputTaskItemBloc>().add(
                                  UpdateLabelList(labelList: linkLabelList),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

String _getFormattedDate(DateTime date) =>
    '${date.year}/${date.month}/${date.day}';
