import 'package:stairs/loom/loom_package.dart';

import '../../project/project_detail_bloc.dart' hide Init;
import '../../../model/model.dart';
import '../component/task_list_item.dart';
import '../task_item_bloc.dart';
import '../component/shrink_list_item.dart';
import '../board_position_bloc.dart';
import '../screen/board_screen.dart';
import 'input_task_item.dart';
import 'input_task_item_bloc.dart';
import '../screen/task_item_edit_modal.dart';
import '../board_card_bloc.dart';
import '../drag_item_bloc.dart';

const _kBorderWidth = 1.0;
const _kBoardAddBtnSpace = 16.0;
const _kListAndAddBtnSpace = 16.0;
const _kMovingDownHeight = 150.0;
const _kPageStorageKeyPrefixTxt = 'PageStorageKey_';
const _kBoardAddBtnTxt = 'タスクを追加';
const _kCancelBtnTxt = 'キャンセル';
const _kAddBtnTxt = '追加';

const _kAnimatedDuration = Duration(milliseconds: 300);

const _kContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
const _kContentMargin = EdgeInsets.only(
  top: 24,
  bottom: 48.0,
  left: 16.0,
  right: 40.0,
);

///ボードカード
class BoardCard extends StatelessWidget {
  const BoardCard({
    super.key,
    required this.projectId,
    required this.boardId,
    required this.displayedBoardId,
    required this.title,
    required this.themeColor,
    required this.taskItemList,
    required this.onPageChanged,
  });
  final String projectId;
  final String boardId;
  final String displayedBoardId;
  final String title;
  final Color themeColor;
  final List<TaskItemInfo> taskItemList;
  final Function(PageAction) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    final boardCardKey = GlobalKey();

    return BlocProvider(
      create: (_) => BoardCardBloc(
        projectId: projectId,
        boardId: boardId,
        title: title,
        taskItemList: taskItemList,
      ),
      child: BlocBuilder<BoardCardBloc, BoardCardState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context
                .read<BoardPositionBloc>()
                .add(BoardSetCardPosition(boardId: boardId, key: boardCardKey));
          });
          // if (state.isAddedNewTask) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     state.scrollController.animateTo(
          //       state.scrollController.position.maxScrollExtent,
          //       duration: _kAnimatedDuration,
          //       curve: Curves.easeIn,
          //     );
          //   });
          // }

          return DragTarget<String>(
            key: ValueKey(state.boardId),
            builder: (context, accepted, rejected) {
              return Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Header(
                      key: key,
                      title: state.title,
                      listSize: state.taskItemList.length,
                    ),
                    Expanded(
                      key: boardCardKey,
                      child: SingleChildScrollView(
                        key: PageStorageKey(
                            _kPageStorageKeyPrefixTxt + state.boardId),
                        controller: state.scrollController,
                        child: Column(
                          children: [
                            for (final item in state.taskItemList)
                              if (item.taskItemId == kShrinkId)
                                ShrinkTaskListItem(
                                  key: key,
                                  id: kShrinkId,
                                )
                              else
                                TaskListItem(
                                  id: item.taskItemId,
                                  title: item.title,
                                  dueDate: item.endDate,
                                  themeColor: themeColor,
                                  labelList: item.labelList,
                                  onTap: () async {
                                    final boardCardBloc =
                                        context.read<BoardCardBloc>();
                                    final taskItemBloc =
                                        context.read<TaskItemBloc>();

                                    final result = await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return TaskItemEditModal(
                                          themeColor: themeColor,
                                          taskItem: item,
                                          onChangeTaskItem: (taskItemVal) {},
                                        );
                                      },
                                    );
                                    if (result == null) {
                                      boardCardBloc.add(BoardCardUpdateTaskItem(
                                        boardId: taskItemBloc
                                            .state.taskItemInfo.boardId,
                                        taskItemId: taskItemBloc
                                            .state.taskItemInfo.taskItemId,
                                        title: taskItemBloc
                                            .state.taskItemInfo.title,
                                        description: taskItemBloc
                                            .state.taskItemInfo.description,
                                        startDate: taskItemBloc
                                            .state.taskItemInfo.startDate,
                                        dueDate: taskItemBloc
                                            .state.taskItemInfo.endDate,
                                        labelList: taskItemBloc
                                            .state.taskItemInfo.labelList,
                                      ));
                                    }
                                  },
                                  onDragStarted: () {
                                    context.read<DragItemBloc>().add(
                                          DragItemSetItem(
                                            boardId: item.boardId,
                                            draggingItem: item,
                                          ),
                                        );
                                    context.read<BoardCardBloc>().add(
                                          BoardCardReplaceShrinkItem(
                                            boardId: state.boardId,
                                            taskItemId: item.taskItemId,
                                            shrinkItem: context
                                                .read<DragItemBloc>()
                                                .getShrinkItem(
                                                  boardId: item.boardId,
                                                ),
                                          ),
                                        );
                                    // context.read<BoardCardBloc>().add(
                                    //       BoardCardSetDraggingItem(
                                    //         taskItemId: item.taskItemId,
                                    //       ),
                                    //     );
                                  },
                                  onDragUpdate: (detail) async {},
                                  onDragCompleted: () {},
                                  onDraggableCanceled: (velocity, offset) {
                                    final draggingState = context
                                        .read<DragItemBloc>()
                                        .state as DragItemDraggingState;
                                    context.read<BoardCardBloc>().add(
                                        BoardCardCompleteDraggedItem(
                                            draggingItem:
                                                draggingState.draggingItem));
                                    context.read<DragItemBloc>().add(
                                          const DragItemComplete(),
                                        );
                                  },
                                ),
                            if (state.isAddedNewTask) ...[
                              InputTaskItem(
                                id: '${state.boardId}_${uuid.v4()}',
                                themeColor: themeColor,
                                labelList: context
                                    .read<ProjectDetailBloc>()
                                    .getLabelList(projectId: state.projectId),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    if (state.isAddedNewTask) ...[
                      const SizedBox(
                        height: _kListAndAddBtnSpace,
                      ),
                      BlocBuilder<InputTaskItemBloc, InputTaskItemState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextButton(
                                title: _kCancelBtnTxt,
                                themeColor: themeColor,
                                onTap: () {
                                  context.read<BoardCardBloc>().add(
                                        const BoardCardSetIsAddingNewTask(
                                          isAddedNewTask: false,
                                        ),
                                      );
                                },
                              ),
                              AbsorbPointer(
                                absorbing: state.taskItemInfo.title.isEmpty,
                                child: CustomTextButton(
                                  title: _kAddBtnTxt,
                                  themeColor: themeColor,
                                  disabled: state.taskItemInfo.title.isEmpty,
                                  onTap: () {
                                    context.read<BoardCardBloc>().add(
                                          const BoardCardSetIsAddingNewTask(
                                            isAddedNewTask: false,
                                          ),
                                        );

                                    // context
                                    //     .read<BoardCardBloc>()
                                    //     .state
                                    //     .scrollController
                                    //     .jumpTo(
                                    //       context
                                    //           .read<BoardCardBloc>()
                                    //           .state
                                    //           .scrollController
                                    //           .position
                                    //           .maxScrollExtent,
                                    //     );

                                    context.read<BoardCardBloc>().add(
                                          BoardCardAddTaskItem(
                                            boardId: context
                                                .read<BoardCardBloc>()
                                                .state
                                                .boardId,
                                            taskItemId:
                                                state.taskItemInfo.taskItemId,
                                            title: state.taskItemInfo.title,
                                            dueDate: state.taskItemInfo.endDate,
                                            labelList:
                                                state.taskItemInfo.labelList,
                                          ),
                                        );
                                    context.read<InputTaskItemBloc>().add(
                                          InputTaskItemInit(
                                            boardId: context
                                                .read<BoardCardBloc>()
                                                .state
                                                .boardId,
                                          ),
                                        );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                    if (!state.isAddedNewTask)
                      _AddingItemButton(
                        key: key,
                        themeColor: themeColor,
                        onTapAddingBtn: () {
                          context.read<BoardCardBloc>().add(
                                const BoardCardSetIsAddingNewTask(
                                  isAddedNewTask: true,
                                ),
                              );
                        },
                      )
                  ],
                ),
              );
            },
            onMove: (details) async {
              final boardPosition = context
                  .read<BoardPositionBloc>()
                  .state
                  .boardPositionMap[boardId];
              if (boardPosition == null) return;
              final criteriaMovingPrevious =
                  boardPosition.dx - boardPosition.width / 2;
              final criteriaMovingNext =
                  boardPosition.dx + boardPosition.width / 2;

              // カード内移動
              if (details.offset.dx < criteriaMovingNext &&
                  criteriaMovingPrevious < details.offset.dx) {
                await onMove(
                  context: context,
                  boardCardKey: boardCardKey,
                  details: details,
                );
              } else {
                // 横ページ移動
                if (criteriaMovingNext < details.offset.dx) {
                  onPageChanged(PageAction.next);
                } else if (details.offset.dx < criteriaMovingNext) {
                  onPageChanged(PageAction.previous);
                }
              }
            },
            onAcceptWithDetails: (details) {
              onAccepted(context: context, details: details);
            },
          );
        },
      ),
    );
  }

  Future<void> onMove({
    required BuildContext context,
    required GlobalKey boardCardKey,
    required DragTargetDetails details,
  }) async {
    final boardCardState = context.read<BoardCardBloc>().state;
    final positionState = context.read<BoardPositionBloc>().state;

    if (positionState.boardItemPositionMap[kShrinkId] == null) {
      return;
    }
    final currentDraggingItemDy = details.offset.dy;
    final boardPosition = positionState.boardPositionMap[boardId];
    if (boardPosition == null) return;
    if (displayedBoardId == boardId) {
      // カード内移動
      // 縦スクロール
      //下に移動
      if (boardCardState.scrollController.offset <
              boardCardState.scrollController.position.maxScrollExtent &&
          boardCardKey.currentContext!.size!.height / 2 + 125 <
              currentDraggingItemDy) {
        boardCardState.scrollController.animateTo(
          boardCardState.scrollController.offset + _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
        //上に移動
      } else if (boardCardState.scrollController.offset > 0 &&
          boardCardKey.currentContext!.size!.height / 2 - 100 >
              currentDraggingItemDy) {
        boardCardState.scrollController.animateTo(
          boardCardState.scrollController.offset - _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
      }
      replaceShrinkItem(
        context: context,
        positionState: positionState,
        currentDraggingItemDy: currentDraggingItemDy,
      );
    }
    // context.read<BoardCardBloc>().add(
    //       const BoardCardDeleteShrinkItem(),
    //     );
  }

  void replaceShrinkItem({
    required BuildContext context,
    required BoardPositionBlocState positionState,
    required double currentDraggingItemDy,
  }) {
    if (positionState.boardItemPositionMap[kShrinkId] == null) return;
    final shrinkItemPosition =
        positionState.boardItemPositionMap[kShrinkId]!.dy;
    if (shrinkItemPosition - (kDraggedItemHeight / 2) < currentDraggingItemDy &&
        currentDraggingItemDy < shrinkItemPosition + (kDraggedItemHeight / 2)) {
      return;
    }
    final boardCardState = context.read<BoardCardBloc>().state;
    final draggingState = context.read<DragItemBloc>().state;
    final taskItemList = boardCardState.taskItemList;
    if (draggingState is! DragItemDraggingState) return;

    for (final item in taskItemList) {
      if (positionState.boardItemPositionMap[item.taskItemId] == null) return;
      if (positionState.boardItemPositionMap[item.taskItemId]!.dy >=
          currentDraggingItemDy) {
        final insertingShrinkItemIndex = taskItemList
            .indexWhere((element) => element.taskItemId == item.taskItemId);
        context.read<BoardCardBloc>().add(
              BoardCardDeleteAndAddShrinkItem(
                boardId: boardCardState.boardId,
                insertingIndex: insertingShrinkItemIndex,
                shrinkItem: draggingState.shrinkItem,
              ),
            );
        return;
      }
    }
    context.read<BoardCardBloc>().add(
          BoardCardDeleteAndAddShrinkItem(
            boardId: boardCardState.boardId,
            insertingIndex: taskItemList.length,
            shrinkItem: draggingState.shrinkItem,
          ),
        );
  }

  void onAccepted({
    required BuildContext context,
    required DragTargetDetails details,
  }) {
    final draggingState =
        context.read<DragItemBloc>().state as DragItemDraggingState;
    context.read<BoardCardBloc>().add(
        BoardCardCompleteDraggedItem(draggingItem: draggingState.draggingItem));
    context.read<DragItemBloc>().add(
          const DragItemComplete(),
        );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.title,
    required this.listSize,
  });
  final String title;
  final int listSize;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Container(
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: theme.colorFgDefaultWhite,
        border: Border(
          bottom: BorderSide(
            color: theme.colorFgDisabled,
            width: _kBorderWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                theme.textStyleSubHeading.copyWith(color: theme.colorFgDefault),
          ),
          Text('${listSize.toString()} 件'),
        ],
      ),
    );
  }
}

class _AddingItemButton extends StatelessWidget {
  const _AddingItemButton({
    super.key,
    required this.themeColor,
    required this.onTapAddingBtn,
  });
  final Color themeColor;
  final VoidCallback onTapAddingBtn;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return TapAction(
      key: key,
      tappedColor: themeColor,
      padding: _kContentPadding,
      border: Border.all(
        color: themeColor,
        width: _kBorderWidth,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      onTap: onTapAddingBtn,
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            theme.icons.add,
            color: themeColor,
          ),
          const SizedBox(
            width: _kBoardAddBtnSpace,
          ),
          Text(
            _kBoardAddBtnTxt,
            style: theme.textStyleBody,
          ),
        ],
      ),
    );
  }
}
