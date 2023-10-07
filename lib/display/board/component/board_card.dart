import 'package:stairs/loom/loom_package.dart';

import '../../project/project_detail_bloc.dart' hide Init;
import '../../../model/model.dart';
import '../component/task_list_item.dart';
import '../task_item_bloc.dart';
import '../component/shrink_list_item.dart';
import '../board_position_bloc.dart';
import '../board_bloc.dart';
import '../screen/board_screen.dart';
import 'input_task_item.dart';
import 'input_task_item_bloc.dart';
import '../screen/task_item_edit_modal.dart';

const _kBorderWidth = 1.0;
const _kBoardAddBtnSpace = 16.0;
const _kListAndAddBtnSpace = 16.0;
const _kMovingDownHeight = 150.0;
const _kPageStorageKeyPrefixTxt = 'PageStorageKey_';
const _kBoardAddBtnTxt = 'タスクを追加';
const _kCancelBtnTxt = 'キャンセル';
const _kAddBtnTxt = '追加';

const _kAnimatedDuration = Duration(milliseconds: 100);

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
    return BlocBuilder<BoardPositionBloc, BoardPositionBlocState>(
      builder: (context, state) {
        final theme = LoomTheme.of(context);
        final boardCardKey = GlobalKey();

        context.read<BoardPositionBloc>().add(
            BoardSetCardPosition(boardId: widget.boardId, key: boardCardKey));

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

        return DragTarget(
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
                                  final taskItemBloc =
                                      context.read<TaskItemBloc>();

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
                                      boardId: taskItemBloc
                                          .state.taskItemInfo.boardId,
                                      taskItemId: taskItemBloc
                                          .state.taskItemInfo.taskItemId,
                                      title:
                                          taskItemBloc.state.taskItemInfo.title,
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
                                  context.read<BoardBloc>().add(
                                        BoardSetDraggingItem(
                                          draggingItem: item,
                                        ),
                                      );
                                  context.read<BoardBloc>().add(
                                        BoardReplaceShrinkItem(
                                            boardId: widget.boardId,
                                            taskItemId: item.taskItemId),
                                      );
                                },
                                onDragUpdate: (detail) {},
                                onDragCompleted: () {},
                                onDraggableCanceled: (velocity, offset) {
                                  context
                                      .read<BoardBloc>()
                                      .add(const BoardCompleteDraggedItem());
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
                                setState(
                                  () {
                                    _isAddedNewTask = false;
                                  },
                                );
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
                                          boardId: widget.boardId));
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
            final boardState =
                context.read<BoardBloc>().state as BoardListState;
            if (boardState.draggingItem == null) {
              context.read<BoardBloc>().add(
                    BoardSetDraggingItem(
                      draggingItem: widget.taskItemList.firstWhere(
                          (element) => element.taskItemId == details.data),
                    ),
                  );
            }

            await onMove(
              context: context,
              boardCardKey: boardCardKey,
              details: details,
            );
          },
          onAcceptWithDetails: (details) {
            onAccepted(context: context, details: details);
          },
        );
      },
    );
  }

  Future<void> onMove({
    required BuildContext context,
    required GlobalKey boardCardKey,
    required DragTargetDetails details,
  }) async {
    final boardState = context.read<BoardBloc>().state as BoardListState;
    final positionState = context.read<BoardPositionBloc>().state;

    if (boardState.shrinkItem == null ||
        positionState.boardItemPositionMap[kShrinkId] == null) {
      return;
    }
    final currentDraggingItemDx = details.offset.dx;
    final currentDraggingItemDy = details.offset.dy;
    final boardPosition = positionState.boardPositionMap[widget.boardId];

    if (boardPosition == null) return;
    final criteriaMovingPrevious = boardPosition.dx - boardPosition.width / 6;
    final criteriaMovingNext = boardPosition.dx + boardPosition.width / 4;

    if (widget.displayedBoardId == widget.boardId) {
      // カード内移動
      if (currentDraggingItemDx < criteriaMovingNext &&
          criteriaMovingPrevious < currentDraggingItemDx) {
        // 縦スクロール
        //下に移動
        if (_scrollController.offset <
                _scrollController.position.maxScrollExtent &&
            boardCardKey.currentContext!.size!.height / 2 + 125 <
                currentDraggingItemDy) {
          _scrollController.animateTo(
            _scrollController.offset + _kMovingDownHeight,
            duration: _kAnimatedDuration,
            curve: Curves.linear,
          );
          //上に移動
        } else if (_scrollController.offset > 0 &&
            boardCardKey.currentContext!.size!.height / 2 - 100 >
                currentDraggingItemDy) {
          _scrollController.animateTo(
            _scrollController.offset - _kMovingDownHeight,
            duration: _kAnimatedDuration,
            curve: Curves.linear,
          );
        }
        replaceShrinkItem(
          positionState: positionState,
          currentDraggingItemDy: currentDraggingItemDy,
        );
        return;
      }
      // 横ページ移動
      if (criteriaMovingNext < currentDraggingItemDx) {
        widget.onPageChanged(PageAction.next);
      } else if (currentDraggingItemDx < criteriaMovingNext) {
        widget.onPageChanged(PageAction.previous);
      }
    }
    replaceShrinkItem(
      positionState: positionState,
      currentDraggingItemDy: currentDraggingItemDy,
    );
  }

  void replaceShrinkItem({
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
              ),
            );
        return;
      }
    }
    context.read<BoardBloc>().add(
          BoardDeleteAndAddShrinkItem(
            boardId: widget.boardId,
            insertingIndex: widget.taskItemList.length,
          ),
        );
  }

  void onAccepted({
    required BuildContext context,
    required DragTargetDetails details,
  }) {
    context.read<BoardBloc>().add(const BoardCompleteDraggedItem());
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
