import 'package:stairs/loom/loom_package.dart';

import '../task_item_bloc.dart';
import '../../../model/model.dart';

const _kTrailingWidth = 30.0;
const _kIconSize = 24.0;
const _kBottomSpaceHeight = 30.0;
const _kTaskItemTitleTxt = 'タスク名を入力';
const _kTaskItemDescriptionTxt = '説明を入力';
const _kTaskItemStartDateTxt = '開始日';
const _kTaskItemStartDateHintTxt = '開始日を入力';
const _kTaskItemEndDateTxt = '期日';
const _kTaskItemEndDateHintTxt = '期日を入力';
const _kLabelTxt = 'ラベル';
const _kLabelHintTxt = 'ラベルを設定';

class TaskItemEditModal extends Modal {
  const TaskItemEditModal({
    super.key,
    required this.workBoardId,
    required this.workBoardItemId,
    required this.themeColor,
    required this.taskItem,
    required this.labelList,
    required this.onChangeTaskItem,
  });

  final String workBoardId;
  final String workBoardItemId;
  final Color themeColor;
  final TaskItemInfo taskItem;
  final List<ColorLabelInfo> labelList;
  final Function(TaskItemInfo) onChangeTaskItem;

  @override
  String? get title => null;

  @override
  List<SingleChildWidget> getPageProviders() {
    return [];
  }

  @override
  Widget buildLeadingContent(BuildContext context) {
    final theme = LoomTheme.of(context);
    return IconButton(
      icon: Icon(
        theme.icons.close,
        color: theme.colorFgDefault,
      ),
      iconSize: _kIconSize,
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildTrailingContent(BuildContext context) {
    final theme = LoomTheme.of(context);
    return SizedBox(
      width: _kTrailingWidth,
      child: IconButton(
        icon: Icon(
          theme.icons.done,
        ),
        color: theme.colorPrimary,
        iconSize: _kIconSize,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget buildMainContent(BuildContext context) {
    return BlocBuilder<TaskItemBloc, TaskItemBlocState>(
      builder: (context, state) {
        context.read<TaskItemBloc>().add(TaskItemInit(
              workBoardId: workBoardId,
              workBoardItemId: workBoardItemId,
            ));

        final theme = LoomTheme.of(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // タスク名
            TextInput(
              textController:
                  TextEditingController(text: state.taskItemInfo.title),
              hintText: _kTaskItemTitleTxt,
              autoFocus: false,
              onSubmitted: (value) {
                context
                    .read<TaskItemBloc>()
                    .add(TaskItemUpdateTitle(title: value));
              },
            ),
            // 説明
            CardLstItem.input(
              icon: Icon(
                theme.icons.trash,
                color: theme.colorPrimary,
              ),
              inputValue: state.taskItemInfo.description,
              hintText: _kTaskItemDescriptionTxt,
              onSubmitted: (value) {
                context
                    .read<TaskItemBloc>()
                    .add(TaskItemUpdateDescription(description: value));
              },
            ),
            //開始日
            CardLstItem.labeWithIcon(
              label: _kTaskItemStartDateTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.calender,
              hintText: _kTaskItemStartDateHintTxt,
              itemList: [
                Text(
                  state.taskItemInfo.startDate.toString(),
                  style: theme.textStyleBody,
                )
              ],
              onTap: () async {
                final bloc = context.read<TaskItemBloc>();
                DateTime? targetDate = await showDatePicker(
                  context: context,
                  initialDate: bloc.state.taskItemInfo.startDate,
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
                if (targetDate != null) {
                  bloc.add(TaskItemUpdateStartDate(startDate: targetDate));
                }
              },
            ),
            // 期日
            CardLstItem.labeWithIcon(
              label: _kTaskItemEndDateTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.calender,
              hintText: _kTaskItemEndDateHintTxt,
              itemList: [
                Text(
                  state.taskItemInfo.endDate.toString(),
                  style: theme.textStyleBody,
                )
              ],
              onTap: () async {
                final bloc = context.read<TaskItemBloc>();
                DateTime? targetDate = await showDatePicker(
                  context: context,
                  initialDate: bloc.state.taskItemInfo.endDate,
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
                if (targetDate != null) {
                  bloc.add(TaskItemUpdateEndDate(endDate: targetDate));
                }
              },
            ),
            // ラベル
            CardLstItem.labeWithIcon(
              label: _kLabelTxt,
              iconColor: theme.colorPrimary,
              iconData: Icons.label,
              hintText: _kLabelHintTxt,
              itemList: [
                for (final item in context
                    .read<TaskItemBloc>()
                    .state
                    .taskItemInfo
                    .labelList)
                  LabelTip(
                    label: item.labelName,
                    themeColor: item.themeColor,
                  )
              ],
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return SelectItemModal(
                    id: workBoardItemId,
                    type: DisplayType.tile,
                    title: _kLabelTxt,
                    height: MediaQuery.of(context).size.height * 0.7,
                    labelList: labelList,
                    selectedLabelList: state.taskItemInfo.labelList,
                    onTapListItem: (linkLabelList) {
                      context.read<TaskItemBloc>().add(
                          TaskItemUpdateLabelList(labelList: linkLabelList));
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: _kBottomSpaceHeight,
            ),
          ],
        );
      },
    );
  }
}
