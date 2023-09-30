import 'package:stairs/loom/loom_package.dart';

import '../task_item_bloc.dart';
import '../../../model/model.dart';

const _kBottomSpaceHeight = 30.0;
const _kTaskItemTitleTxt = 'タスク名を入力';
const _kTaskItemDescriptionTxt = '説明を入力';
const _kTaskItemStartDateTxt = '開始日';
const _kTaskItemStartDateHintTxt = '開始日を入力';
const _kTaskItemEndDateTxt = '期日';
const _kTaskItemEndDateHintTxt = '期日を入力';
const _kLabelTxt = 'ラベル';
const _kLabelHintTxt = 'ラベルを設定';

class TaskItemEditModal extends StatelessWidget {
  const TaskItemEditModal({
    super.key,
    required this.themeColor,
    required this.taskItem,
    required this.onChangeTaskItem,
  });

  final Color themeColor;
  final TaskItemInfo taskItem;
  final Function(TaskItemInfo) onChangeTaskItem;

  @override
  Widget build(BuildContext context) {
    context.read<TaskItemBloc>().add(
          TaskItemInit(
            workBoardId: taskItem.workBoardId,
            taskItemId: taskItem.taskItemId,
            title: taskItem.title,
            description: taskItem.description,
            startDate: taskItem.startDate,
            endDate: taskItem.endDate,
            labelList: taskItem.labelList,
          ),
        );
    return BlocBuilder<TaskItemBloc, TaskItemBlocState>(
      builder: (context, state) {
        final theme = LoomTheme.of(context);
        final titleTxtController =
            TextEditingController(text: state.taskItemInfo.title);

        return Modal(
          onClose: onChangeTaskItem(state.taskItemInfo),
          buildMainContent: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // タスク名
              TextInput(
                textController: titleTxtController,
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
                  color: themeColor,
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
                iconColor: themeColor,
                iconData: theme.icons.calender,
                hintText: _kTaskItemStartDateHintTxt,
                itemList: [
                  Text(
                    _getFormattedDate(state.taskItemInfo.startDate),
                    style: theme.textStyleBody,
                  )
                ],
                onTap: () async {
                  final bloc = context.read<TaskItemBloc>();
                  DateTime? targetDate = await showDatePicker(
                    context: context,
                    initialDate: bloc.state.taskItemInfo.startDate,
                    firstDate: DateTime(1990, 1, 1),
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
                iconColor: themeColor,
                iconData: theme.icons.calender,
                hintText: _kTaskItemEndDateHintTxt,
                itemList: [
                  Text(
                    _getFormattedDate(state.taskItemInfo.endDate),
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
                iconColor: themeColor,
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
                      id: taskItem.taskItemId,
                      type: DisplayType.tile,
                      title: _kLabelTxt,
                      height: MediaQuery.of(context).size.height * 0.7,
                      labelList: taskItem.labelList,
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
          ),
        );
      },
    );
  }
}

String _getFormattedDate(DateTime date) =>
    '${date.year}/${date.month}/${date.day}';
