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
import '../board_bloc.dart';
import '../drag_item_bloc.dart';
import '../../board/component/carousel_display_bloc.dart';

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
class BoardCard extends StatefulWidget {
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
  State<StatefulWidget> createState() => _BoardCardState();
}

class _BoardCardState extends State<BoardCard> {
  bool _isAddedNewTask = false;
  bool _isMovingLast = false;
  final _scrollController = ScrollController();

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
    final boardCardKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardPositionBloc>().add(
          BoardSetCardPosition(boardId: widget.boardId, key: boardCardKey));
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (_isAddedNewTask) {
          await Future.delayed(const Duration(milliseconds: 50)).then(
            (value) => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: _kAnimatedDuration,
              curve: Curves.easeIn,
            ),
          );
        }
        if (_isMovingLast) {
          await Future.delayed(const Duration(milliseconds: 50)).then(
            (value) => _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            ),
          );
          _isMovingLast = false;
        }
      },
    );

    return DragTarget<String>(
      key: ValueKey(widget.boardId),
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
                key: widget.key,
                title: widget.title,
                listSize: widget.taskItemList.length,
              ),
              Expanded(
                key: boardCardKey,
                child: SingleChildScrollView(
                  key: PageStorageKey(
                      _kPageStorageKeyPrefixTxt + widget.boardId),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      for (final item in widget.taskItemList)
                        if (item.taskItemId == kShrinkId)
                          ShrinkTaskListItem(
                            key: widget.key,
                            id: kShrinkId,
                          )
                        else
                          TaskListItem(
                            id: item.taskItemId,
                            title: item.title,
                            dueDate: item.endDate,
                            themeColor: widget.themeColor,
                            labelList: item.labelList,
                            onTap: () async {
                              final boardBloc = context.read<BoardBloc>();
                              final taskItemBloc = context.read<TaskItemBloc>();

                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return TaskItemEditModal(
                                    themeColor: widget.themeColor,
                                    taskItem: item,
                                    onChangeTaskItem: (taskItemVal) {},
                                  );
                                },
                              );
                              if (result == null) {
                                boardBloc.add(BoardUpdateTaskItem(
                                  boardId:
                                      taskItemBloc.state.taskItemInfo.boardId,
                                  taskItemId: taskItemBloc
                                      .state.taskItemInfo.taskItemId,
                                  title: taskItemBloc.state.taskItemInfo.title,
                                  description: taskItemBloc
                                      .state.taskItemInfo.description,
                                  startDate:
                                      taskItemBloc.state.taskItemInfo.startDate,
                                  dueDate:
                                      taskItemBloc.state.taskItemInfo.endDate,
                                  labelList:
                                      taskItemBloc.state.taskItemInfo.labelList,
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
                              context.read<BoardBloc>().add(
                                    BoardReplaceShrinkItem(
                                      boardId: widget.boardId,
                                      taskItemId: item.taskItemId,
                                      shrinkItem: context
                                          .read<DragItemBloc>()
                                          .getShrinkItem(
                                            boardId: item.boardId,
                                          ),
                                    ),
                                  );
                              context.read<BoardPositionBloc>().add(
                                  BoardSetCardItemPosition(
                                      taskItemId: kShrinkId,
                                      key: boardCardKey));
                              // context.read<BoardCardBloc>().add(
                              //       BoardCardSetDraggingItem(
                              //         taskItemId: item.taskItemId,
                              //       ),
                              //     );
                            },
                            onDragUpdate: (detail) async {},
                            onDragCompleted: () {
                              // final draggingState = context
                              //     .read<DragItemBloc>()
                              //     .state as DragItemDraggingState;
                              // context.read<BoardCardBloc>().add(
                              //     BoardCardCompleteDraggedItem(
                              //         draggingItem:
                              //             draggingwidget.draggingItem));
                              // context.read<DragItemBloc>().add(
                              //       const DragItemComplete(),
                              //     );
                            },
                            onDraggableCanceled: (velocity, offset) {
                              final draggingState = context
                                  .read<DragItemBloc>()
                                  .state as DragItemDraggingState;
                              context
                                  .read<BoardBloc>()
                                  .add(BoardCompleteDraggedItem(
                                    draggingItem: draggingState.draggingItem,
                                    shrinkItem: draggingState.shrinkItem,
                                  ));

                              context.read<DragItemBloc>().add(
                                    const DragItemComplete(),
                                  );
                            },
                          ),
                      if (_isAddedNewTask) ...[
                        InputTaskItem(
                          id: '${widget.boardId}_${uuid.v4()}',
                          themeColor: widget.themeColor,
                          labelList: context
                              .read<ProjectDetailBloc>()
                              .getLabelList(projectId: widget.projectId),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              if (_isAddedNewTask) ...[
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
                          themeColor: widget.themeColor,
                          onTap: () {
                            _isAddedNewTask = false;
                          },
                        ),
                        AbsorbPointer(
                          absorbing: state.taskItemInfo.title.isEmpty,
                          child: CustomTextButton(
                            title: _kAddBtnTxt,
                            themeColor: widget.themeColor,
                            disabled: state.taskItemInfo.title.isEmpty,
                            onTap: () {
                              setState(
                                () {
                                  _isAddedNewTask = false;
                                  _isMovingLast = true;
                                },
                              );
                              context.read<BoardBloc>().add(
                                    BoardAddTaskItem(
                                      boardId: widget.boardId,
                                      taskItemId: state.taskItemInfo.taskItemId,
                                      title: state.taskItemInfo.title,
                                      dueDate: state.taskItemInfo.endDate,
                                      labelList: state.taskItemInfo.labelList,
                                    ),
                                  );
                              context.read<InputTaskItemBloc>().add(
                                  InputTaskItemInit(boardId: widget.boardId));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
              if (!_isAddedNewTask)
                _AddingItemButton(
                  key: widget.key,
                  themeColor: widget.themeColor,
                  onTapAddingBtn: () async => setState(
                    () {
                      _isAddedNewTask = true;
                    },
                  ),
                )
            ],
          ),
        );
      },
      onMove: (details) async {
        if (!context.read<CarouselDisplayBloc>().state.isReady) return;
        final boardPositionState = context.read<BoardPositionBloc>().state;
        final boardPosition =
            boardPositionState.boardPositionMap[widget.boardId];

        if (boardPosition == null) return;
        final criteriaMovingPrevious =
            boardPosition.dx - boardPosition.width / 2;
        final criteriaMovingNext = boardPosition.dx + boardPosition.width / 2;

        // カード内移動
        if (details.offset.dx < criteriaMovingNext &&
            criteriaMovingPrevious < details.offset.dx) {
          onMoveVertical(
            context: context,
            boardCardKey: boardCardKey,
            dy: details.offset.dy,
            positionState: boardPositionState,
          );
        } else {
          // // positionを更新
          // context.read<BoardPositionBloc>().add(
          //     BoardSetCardPosition(boardId: widget.boardId, key: boardCardKey));
          // 横ページ移動
          onMoveHorizontal(
            context: context,
            dx: details.offset.dx,
            dy: details.offset.dy,
            criteriaMovingNext: criteriaMovingNext,
            positionState: context.read<BoardPositionBloc>().state,
          );
        }
      },
      onAcceptWithDetails: (details) {
        onAccepted(context: context, details: details);
      },
      onLeave: (data) {},
      onWillAccept: (data) {
        return false;
      },
    );
  }

  // カード内移動
  Future<void> onMoveVertical({
    required BuildContext context,
    required GlobalKey boardCardKey,
    required double dy,
    required BoardPositionBlocState positionState,
  }) async {
    if (positionState.boardItemPositionMap[kShrinkId] == null) {
      return;
    }
    final boardPosition = positionState.boardPositionMap[widget.boardId];
    if (boardPosition == null) return;
    if (widget.displayedBoardId == widget.boardId) {
      // カード内移動
      // 縦スクロール
      //下に移動
      if (_scrollController.offset <
              _scrollController.position.maxScrollExtent &&
          boardCardKey.currentContext!.size!.height / 2 + 125 < dy) {
        _scrollController.animateTo(
          _scrollController.offset + _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
        //上に移動
      } else if (_scrollController.offset > 0 &&
          boardCardKey.currentContext!.size!.height / 2 - 100 > dy) {
        _scrollController.animateTo(
          _scrollController.offset - _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
      }
      replaceShrinkItem(
        context: context,
        positionState: positionState,
        currentDraggingItemDy: dy,
      );
    }
  }

  // ページ移動
  Future<void> onMoveHorizontal({
    required BuildContext context,
    required double dx,
    required double dy,
    required double criteriaMovingNext,
    required BoardPositionBlocState positionState,
  }) async {
    // 横ページ移動
    if (criteriaMovingNext < dx) {
      widget.onPageChanged(PageAction.next);
    } else if (dx < criteriaMovingNext) {
      widget.onPageChanged(PageAction.previous);
    }
    replaceShrinkItem(
      context: context,
      positionState: positionState,
      currentDraggingItemDy: dy,
    );
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
    if (context.read<DragItemBloc>().state is! DragItemDraggingState) return;
    final draggingState =
        context.read<DragItemBloc>().state as DragItemDraggingState;

    for (final item in widget.taskItemList) {
      if (positionState.boardItemPositionMap[item.taskItemId] == null) {
        return;
      }
      if (positionState.boardItemPositionMap[item.taskItemId]!.dy >=
          currentDraggingItemDy) {
        final insertingShrinkItemIndex = widget.taskItemList
            .indexWhere((element) => element.taskItemId == item.taskItemId);
        context.read<BoardBloc>().add(
              BoardDeleteAndAddShrinkItem(
                boardId: widget.boardId,
                insertingIndex: insertingShrinkItemIndex,
                shrinkItem: draggingState.shrinkItem,
              ),
            );
        return;
      }
    }
    context.read<BoardBloc>().add(
          BoardDeleteAndAddShrinkItem(
            boardId: widget.boardId,
            insertingIndex: widget.taskItemList.length,
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
    context.read<BoardBloc>().add(BoardCompleteDraggedItem(
          draggingItem: draggingState.draggingItem,
          shrinkItem: draggingState.shrinkItem,
        ));
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
