import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../loom/theme.dart';
import '../../../loom/component/item/tap_action.dart';
import '../../../loom/component/button/custom_text_button.dart';
import '../../../display/board/board_detail_bloc.dart' hide Init;
import '../../../model/model.dart';
import '../component/task_list_item.dart';
import '../component/input_task_item_bloc.dart';
import '../component/shrink_list_item.dart';
import '../work_board_position_bloc.dart';
import '../work_board_bloc.dart';
import '../screen/work_board_screen.dart';
import 'input_task_item.dart';

const _kBorderWidth = 1.0;
const _kWorkBoardAddBtnSpace = 16.0;
const _kListAndAddBtnSpace = 16.0;
const _kMovingDownHeight = 150.0;
const _kPageStorageKeyPrefixTxt = 'PageStorageKey_';
const _kWorkBoardAddBtnTxt = 'タスクを追加';
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

///ワークボードカード
class WorkBoardCard extends StatefulWidget {
  const WorkBoardCard({
    super.key,
    required this.boardId,
    required this.workBoardId,
    required this.displayedWorkBoardId,
    required this.title,
    required this.themeColor,
    required this.workBoardItemList,
    required this.onPageChanged,
  });
  final String boardId;
  final String workBoardId;
  final String displayedWorkBoardId;
  final String title;
  final Color themeColor;
  final List<WorkBoardItemInfo> workBoardItemList;
  final Function(PageAction) onPageChanged;

  @override
  State<StatefulWidget> createState() => _WorkBoardCardState();
}

class _WorkBoardCardState extends State<WorkBoardCard> {
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
    return BlocBuilder<WorkBoardPositionBloc, WorkBoardPositionBlocState>(
      builder: (context, state) {
        final theme = LoomTheme.of(context);
        final workBoardCardKey = GlobalKey();

        context.read<WorkBoardPositionBloc>().add(WorkBoardSetCardPosition(
            workBoardId: widget.workBoardId, key: workBoardCardKey));

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

        return BlocBuilder<InputTaskItemBloc, InputTaskItemBlocState>(
          builder: (context, state) {
            return DragTarget(
              key: ValueKey(widget.workBoardId),
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
                        listSize: widget.workBoardItemList.length,
                      ),
                      Expanded(
                        key: workBoardCardKey,
                        child: SingleChildScrollView(
                          key: PageStorageKey(
                              _kPageStorageKeyPrefixTxt + widget.workBoardId),
                          controller: _scrollController,
                          child: Column(
                            children: [
                              for (final item in widget.workBoardItemList)
                                if (item.workBoardItemId == kShrinkId)
                                  ShrinkTaskListItem(
                                    key: widget.key,
                                    id: kShrinkId,
                                  )
                                else
                                  TaskListItem(
                                    id: item.workBoardItemId,
                                    title: item.title,
                                    dueDate: item.endDate,
                                    themeColor: widget.themeColor,
                                    labelList: item.labelList,
                                    onTap: () {},
                                    onDragStarted: () {
                                      context.read<WorkBoardBloc>().add(
                                            WorkBoardSetDraggingItem(
                                              draggingItem: item,
                                            ),
                                          );
                                      context.read<WorkBoardBloc>().add(
                                            WorkBoardReplaceShrinkItem(
                                                workBoardId: widget.workBoardId,
                                                workBoardItemId:
                                                    item.workBoardItemId),
                                          );
                                    },
                                    onDragUpdate: (detail) {},
                                    onDragCompleted: () {},
                                    onDraggableCanceled: (velocity, offset) {
                                      context.read<WorkBoardBloc>().add(
                                          const WorkBoardCompleteDraggedItem());
                                    },
                                  ),
                              if (_isAddedNewTask) ...[
                                InputTaskItem(
                                  id: '${widget.workBoardId}_${uuid.v4()}',
                                  themeColor: widget.themeColor,
                                  labelList: context
                                      .read<BoardDetailBloc>()
                                      .getLabelList(boardId: widget.boardId),
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
                        Row(
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
                              absorbing: context
                                  .read<InputTaskItemBloc>()
                                  .state
                                  .inputValue
                                  .isEmpty,
                              child: CustomTextButton(
                                title: _kAddBtnTxt,
                                themeColor: widget.themeColor,
                                disabled: context
                                    .read<InputTaskItemBloc>()
                                    .state
                                    .inputValue
                                    .isEmpty,
                                onTap: () {
                                  setState(
                                    () {
                                      _isAddedNewTask = false;
                                      _isMovingLast = true;
                                    },
                                  );
                                  final taskItemBloc =
                                      context.read<InputTaskItemBloc>();
                                  context.read<WorkBoardBloc>().add(
                                        WorkBoardAddTaskItem(
                                          workBoardId: widget.workBoardId,
                                          inputValue:
                                              taskItemBloc.state.inputValue,
                                          dueDate: taskItemBloc.state.dueDate,
                                          labelList:
                                              taskItemBloc.state.labelList,
                                        ),
                                      );
                                  taskItemBloc.add(const Init());
                                },
                              ),
                            ),
                          ],
                        ),
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
                if (context.read<WorkBoardBloc>().state.draggingItem == null) {
                  context.read<WorkBoardBloc>().add(
                        WorkBoardSetDraggingItem(
                          draggingItem: widget.workBoardItemList.firstWhere(
                              (element) =>
                                  element.workBoardItemId == details.data),
                        ),
                      );
                }

                await onMove(
                  context: context,
                  workBoardCardKey: workBoardCardKey,
                  details: details,
                );
              },
              onAcceptWithDetails: (details) {
                onAccepted(context: context, details: details);
              },
            );
          },
        );
      },
      // ),
    );
  }

  Future<void> onMove({
    required BuildContext context,
    required GlobalKey workBoardCardKey,
    required DragTargetDetails details,
  }) async {
    final workBoardState = context.read<WorkBoardBloc>().state;
    final positionState = context.read<WorkBoardPositionBloc>().state;

    if (workBoardState.shrinkItem == null ||
        positionState.workBoardItemPositionMap[kShrinkId] == null) {
      return;
    }
    final currentDraggingItemDx = details.offset.dx;
    final currentDraggingItemDy = details.offset.dy;
    final workBoardPosition =
        positionState.workBoardPositionMap[widget.workBoardId];
    if (workBoardPosition == null) return;

    if (widget.displayedWorkBoardId == widget.workBoardId) {
      // 横ページ移動
      if (workBoardPosition.dx + workBoardPosition.width / 2 <
          currentDraggingItemDx) {
        widget.onPageChanged(PageAction.next);
      } else if (currentDraggingItemDx <
          workBoardPosition.dx - workBoardPosition.width / 3) {
        widget.onPageChanged(PageAction.previous);
      }
      // 縦スクロール
      //下に移動
      if (_scrollController.offset <
              _scrollController.position.maxScrollExtent &&
          workBoardCardKey.currentContext!.size!.height / 2 + 125 <
              currentDraggingItemDy) {
        _scrollController.animateTo(
          _scrollController.offset + _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
        //上に移動
      } else if (_scrollController.offset > 0 &&
          workBoardCardKey.currentContext!.size!.height / 2 - 100 >
              currentDraggingItemDy) {
        _scrollController.animateTo(
          _scrollController.offset - _kMovingDownHeight,
          duration: _kAnimatedDuration,
          curve: Curves.linear,
        );
      }
    }

    final shrinkItemPosition =
        positionState.workBoardItemPositionMap[kShrinkId]!.dy;

    if (shrinkItemPosition - (kDraggedItemHeight / 2) < currentDraggingItemDy &&
        currentDraggingItemDy < shrinkItemPosition + (kDraggedItemHeight / 2)) {
      return;
    }

    for (final item in widget.workBoardItemList) {
      if (positionState.workBoardItemPositionMap[item.workBoardItemId] ==
          null) {
        return;
      }
      if (positionState.workBoardItemPositionMap[item.workBoardItemId]!.dy >=
          currentDraggingItemDy) {
        final insertingShrinkItemIndex = widget.workBoardItemList.indexWhere(
            (element) => element.workBoardItemId == item.workBoardItemId);
        context.read<WorkBoardBloc>().add(
              WorkBoardDeleteAndAddShrinkItem(
                workBoardId: widget.workBoardId,
                insertingIndex: insertingShrinkItemIndex,
              ),
            );
        return;
      }
    }
    context.read<WorkBoardBloc>().add(
          WorkBoardDeleteAndAddShrinkItem(
            workBoardId: widget.workBoardId,
            insertingIndex: widget.workBoardItemList.length,
          ),
        );
  }

  void onAccepted({
    required BuildContext context,
    required DragTargetDetails details,
  }) {
    context.read<WorkBoardBloc>().add(const WorkBoardCompleteDraggedItem());
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
            width: _kWorkBoardAddBtnSpace,
          ),
          Text(
            _kWorkBoardAddBtnTxt,
            style: theme.textStyleBody,
          ),
        ],
      ),
    );
  }
}
