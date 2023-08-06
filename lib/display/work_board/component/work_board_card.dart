import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../loom/theme.dart';
import '../../../model/model.dart';
import '../component/task_list_item.dart';
import '../work_board_position_bloc.dart';
import '../work_board_bloc.dart';
import '../screen/work_board_screen.dart';

const _kBorderWidth = 1.0;
const _kWorkBoardAddBtnSpace = 16.0;
const _kWorkBoardAddBtnTxt = 'カードを追加';

const _kContentPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);
const _kContentMargin = EdgeInsets.only(
  top: 24,
  bottom: 48.0,
  left: 16.0,
  right: 40.0,
);

///ワークボードカード
class WorkBoardCard extends StatelessWidget {
  const WorkBoardCard({
    super.key,
    required this.workBoardId,
    required this.displayedWorkBoardId,
    required this.title,
    required this.themeColor,
    required this.workBoardItemList,
    required this.onPageChanged,
  });
  final String workBoardId;
  final String displayedWorkBoardId;
  final String title;
  final Color themeColor;
  final List<WorkBoardItemInfo> workBoardItemList;
  final Function(PageAction) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBoardPositionBloc, WorkBoardPositionBlocState>(
      builder: (context, state) {
        final theme = LoomTheme.of(context);
        final workBoardCardKey = GlobalKey();
        context.read<WorkBoardPositionBloc>().add(WorkBoardSetCardPosition(
            workBoardId: workBoardId, key: workBoardCardKey));

        return DragTarget(
          key: ValueKey(workBoardId),
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
                    title: title,
                    listSize: workBoardItemList.length,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      key: workBoardCardKey,
                      child: Column(
                        children: [
                          for (final item in workBoardItemList)
                            if (item.workBoardItemId == kShrinkId)
                              ShrinkTaskListItem(
                                key: key,
                                id: kShrinkId,
                              )
                            else
                              TaskListItem(
                                id: item.workBoardItemId,
                                title: item.title,
                                dueDate: item.endDate,
                                themeColor: themeColor,
                                labelList: item.labelList,
                                onTap: () {},
                                onDragStarted: () {
                                  context
                                      .read<WorkBoardBloc>()
                                      .add(WorkBoardSetDraggingItem(
                                        draggingItem: item,
                                      ));
                                  context.read<WorkBoardBloc>().add(
                                        WorkBoardReplaceShrinkItem(
                                            workBoardId: workBoardId,
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
                        ],
                      ),
                    ),
                  ),
                  _AddingItemButton(
                    key: key,
                    themeColor: themeColor,
                    onTapAddingBtn: () {},
                  )
                ],
              ),
            );
          },
          onMove: (details) async {
            if (context.read<WorkBoardBloc>().state.draggingItem == null) {
              context.read<WorkBoardBloc>().add(
                    WorkBoardSetDraggingItem(
                      draggingItem: workBoardItemList.firstWhere(
                          (element) => element.workBoardItemId == details.data),
                    ),
                  );
            }

            await onMove(
              context: context,
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
    final workBoardPosition = positionState.workBoardPositionMap[workBoardId];
    if (workBoardPosition == null) return;

    if (displayedWorkBoardId == workBoardId) {
      if (workBoardPosition.dx + workBoardPosition.width / 3 <
          currentDraggingItemDx) {
        onPageChanged(PageAction.next);
      } else if (currentDraggingItemDx < workBoardPosition.dx) {
        onPageChanged(PageAction.previous);
      }
    }

    final shrinkItemPosition =
        positionState.workBoardItemPositionMap[kShrinkId]!.dy;

    if (shrinkItemPosition - (kDraggedItemHeight / 2) < currentDraggingItemDy &&
        currentDraggingItemDy < shrinkItemPosition + (kDraggedItemHeight / 2)) {
      return;
    }

    for (final item in workBoardItemList) {
      if (positionState.workBoardItemPositionMap[item.workBoardItemId] ==
          null) {
        return;
      }
      if (positionState.workBoardItemPositionMap[item.workBoardItemId]!.dy >=
          currentDraggingItemDy) {
        final insertingShrinkItemIndex = workBoardItemList.indexWhere(
            (element) => element.workBoardItemId == item.workBoardItemId);
        context.read<WorkBoardBloc>().add(
              WorkBoardDeleteAndAddShrinkItem(
                workBoardId: workBoardId,
                insertingIndex: insertingShrinkItemIndex,
              ),
            );
        return;
      }
    }
    context.read<WorkBoardBloc>().add(
          WorkBoardDeleteAndAddShrinkItem(
            workBoardId: workBoardId,
            insertingIndex: workBoardItemList.length,
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
            style: theme.textStyleSubHeading,
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

    return Container(
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.3),
        border: Border.all(
          color: theme.colorFgDisabled,
          width: _kBorderWidth,
        ),
      ),
      child: Row(
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
