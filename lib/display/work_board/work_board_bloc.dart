import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../board/screens/board_modal.dart';
import '../../loom/loom_theme_data.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

const kShrinkId = 'shrinkId';

// Event
abstract class WorkBoardBlocEvent {
  const WorkBoardBlocEvent();
}

class _Init extends WorkBoardBlocEvent {
  const _Init();
}

class WorkBoardGetList extends WorkBoardBlocEvent {
  const WorkBoardGetList({required this.boardId});
  final String boardId;
}

class WorkBoardAddCard extends WorkBoardBlocEvent {
  const WorkBoardAddCard({required this.workBoardId});

  final String workBoardId;
}

class WorkBoardAddTaskItem extends WorkBoardBlocEvent {
  const WorkBoardAddTaskItem({required this.workBoardItemId});

  final String workBoardItemId;
}

class WorkBoardTapListItem extends WorkBoardBlocEvent {
  const WorkBoardTapListItem({required this.workBoardItemId});

  final String workBoardItemId;
}

class WorkBoardTapEdit extends WorkBoardBlocEvent {
  const WorkBoardTapEdit({
    required this.workBoardId,
    required this.context,
    required this.theme,
  });

  final String workBoardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class WorkBoardDeleteListItem extends WorkBoardBlocEvent {
  const WorkBoardDeleteListItem({
    required this.workBoardId,
    required this.workBoardItemId,
  });
  final String workBoardId;
  final String workBoardItemId;
}

/// Init drag. shrink item and dragging item is initialized.
class WorkBoardInitDragging extends WorkBoardBlocEvent {
  const WorkBoardInitDragging();
}

/// Set Dragging item.
class WorkBoardSetDraggingItem extends WorkBoardBlocEvent {
  const WorkBoardSetDraggingItem({
    required this.draggingItem,
  });
  final WorkBoardItemInfo draggingItem;
}

/// Replace dragging item to shrink item.
class WorkBoardReplaceShrinkItem extends WorkBoardBlocEvent {
  const WorkBoardReplaceShrinkItem({
    required this.workBoardId,
    required this.workBoardItemId,
  });
  final String workBoardId;
  final String workBoardItemId;
}

// Delete and Add shrink item when item is dragging.
class WorkBoardDeleteAndAddShrinkItem extends WorkBoardBlocEvent {
  const WorkBoardDeleteAndAddShrinkItem({
    required this.workBoardId,
    required this.insertingIndex,
  });

  final String workBoardId;
  final int insertingIndex;
}

// Complete dragging.
class WorkBoardCompleteDraggedItem extends WorkBoardBlocEvent {
  const WorkBoardCompleteDraggedItem();
}

// State
@immutable
class WorkBoardBlocState extends Equatable {
  const WorkBoardBlocState({
    required this.workBoardList,
    this.draggingItem,
    this.shrinkItem,
  });

  final List<WorkBoard> workBoardList;
  final WorkBoardItemInfo? draggingItem;
  final WorkBoardItemInfo? shrinkItem;

  @override
  List<Object?> get props => [
        workBoardList,
        draggingItem,
        shrinkItem,
      ];

  WorkBoardBlocState copyWith({
    List<WorkBoard>? workBoardList,
    WorkBoardItemInfo? draggingItem,
    WorkBoardItemInfo? shrinkItem,
  }) =>
      WorkBoardBlocState(
        workBoardList: workBoardList ?? this.workBoardList,
        draggingItem: draggingItem ?? this.draggingItem,
        shrinkItem: shrinkItem ?? this.shrinkItem,
      );

  ///Check shrink item is included in target work board card list.
  bool hasShrinkItem(String workBoardId) {
    final targetWorkBoard = workBoardList.firstWhereOrNull(
      (element) => element.workBoardId == workBoardId,
    );
    if (targetWorkBoard == null) return false;
    return targetWorkBoard.workBoardItemList.firstWhereOrNull(
            (element) => element.workBoardItemId == kShrinkId) !=
        null;
  }
}

// Bloc
class WorkBoardBloc extends Bloc<WorkBoardBlocEvent, WorkBoardBlocState> {
  WorkBoardBloc()
      : super(
          const WorkBoardBlocState(workBoardList: []),
        ) {
    on<_Init>(_onInit);
    on<WorkBoardGetList>(_onGetList);
    on<WorkBoardTapListItem>(_onTapListItem);
    on<WorkBoardAddCard>(_onAddCard);
    on<WorkBoardAddTaskItem>(_onAddTaskItem);
    on<WorkBoardTapEdit>(_onTapEdit);
    on<WorkBoardDeleteListItem>(_onDeleteListItem);
    on<WorkBoardInitDragging>(_onInitDragging);
    on<WorkBoardSetDraggingItem>(_onSetDraggingItem);
    on<WorkBoardReplaceShrinkItem>(_onReplaceShrinkItem);
    on<WorkBoardDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
    on<WorkBoardCompleteDraggedItem>(_onReplaceDraggedItem);
  }

  void _onInit(_Init event, Emitter<WorkBoardBlocState> emit) {
    emit(const WorkBoardBlocState(workBoardList: []));
  }

  Future<void> _onGetList(
      WorkBoardGetList event, Emitter<WorkBoardBlocState> emit) async {
    emit(state.copyWith(workBoardList: dummyWorkBoardList));
  }

  Future<void> _onTapListItem(
      WorkBoardTapListItem event, Emitter<WorkBoardBlocState> emit) async {}

  Future<void> _onAddCard(
      WorkBoardAddCard event, Emitter<WorkBoardBlocState> emit) async {}

  Future<void> _onAddTaskItem(
      WorkBoardAddTaskItem event, Emitter<WorkBoardBlocState> emit) async {}

  void _onTapEdit(WorkBoardTapEdit event, Emitter<WorkBoardBlocState> emit) {
    // showModalBottomSheet(
    //   context: event.context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) {
    //     return BoardModal(boardId: event.boardId);
    //   },
    // );
  }

  Future<void> _onDeleteListItem(
      WorkBoardDeleteListItem event, Emitter<WorkBoardBlocState> emit) async {
    final targetList = [...state.workBoardList];

    final deleteWorkBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    final deleteWorkBoardItemIndex =
        targetList[deleteWorkBoardIndex].workBoardItemList.indexWhere(
              (element) => element.workBoardItemId == event.workBoardItemId,
            );
    targetList[deleteWorkBoardIndex]
        .workBoardItemList
        .removeAt(deleteWorkBoardItemIndex);
    emit(state.copyWith(workBoardList: targetList));
  }

  Future<void> _onInitDragging(
      WorkBoardInitDragging event, Emitter<WorkBoardBlocState> emit) async {
    emit(
      WorkBoardBlocState(
        workBoardList: state.workBoardList,
      ),
    );
  }

  Future<void> _onSetDraggingItem(
      WorkBoardSetDraggingItem event, Emitter<WorkBoardBlocState> emit) async {
    emit(
      state.copyWith(
        draggingItem: event.draggingItem,
      ),
    );
  }

  Future<void> _onReplaceShrinkItem(WorkBoardReplaceShrinkItem event,
      Emitter<WorkBoardBlocState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final targetList = [...state.workBoardList];
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    final workBoardItemIndex =
        targetList[workBoardIndex].workBoardItemList.indexWhere(
              (element) => element.workBoardItemId == event.workBoardItemId,
            );
    targetList[workBoardIndex].workBoardItemList[workBoardItemIndex] =
        shrinkItem;

    emit(state.copyWith(workBoardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onDeleteAndAddShrinkItem(WorkBoardDeleteAndAddShrinkItem event,
      Emitter<WorkBoardBlocState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final targetList = [...state.workBoardList];

    if (state.shrinkItem == null) return;
    final currentShrinkItemWBIndex = targetList.indexWhere(
      (element) => element.workBoardId == state.shrinkItem!.workBoardId,
    );
    final currentShrinkItemWBItemIndex = targetList
        .firstWhere(
            (element) => element.workBoardId == state.shrinkItem!.workBoardId)
        .workBoardItemList
        .indexWhere((element) =>
            element.workBoardItemId == state.shrinkItem!.workBoardItemId);
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    targetList[workBoardIndex]
        .workBoardItemList
        .insert(event.insertingIndex, shrinkItem);

    //同じワークボード内で移動した場合、それぞれのindexで削除対象を判定
    if (shrinkItem.workBoardId == state.shrinkItem!.workBoardId) {
      targetList[workBoardIndex].workBoardItemList.removeAt(
          currentShrinkItemWBItemIndex < event.insertingIndex
              ? currentShrinkItemWBItemIndex
              : currentShrinkItemWBItemIndex + 1);
    } else {
      targetList[currentShrinkItemWBIndex]
          .workBoardItemList
          .removeAt(currentShrinkItemWBItemIndex);
    }

    emit(state.copyWith(workBoardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onReplaceDraggedItem(WorkBoardCompleteDraggedItem event,
      Emitter<WorkBoardBlocState> emit) async {
    if (state.draggingItem == null || state.shrinkItem == null) {
      return;
    }
    final targetList = [...state.workBoardList];
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == state.shrinkItem!.workBoardId,
    );
    final workBoardItemIndex =
        targetList[workBoardIndex].workBoardItemList.indexWhere(
              (element) =>
                  element.workBoardItemId == state.shrinkItem!.workBoardItemId,
            );
    targetList[workBoardIndex].workBoardItemList[workBoardItemIndex] =
        state.draggingItem!;

    emit(state.copyWith(workBoardList: targetList));
    add(const WorkBoardInitDragging());
  }

  /// shrink itemを削除したList<WorkBoard>を取得
  List<WorkBoard> _getDeletedShrinkItemList() {
    final targetList = [...state.workBoardList];
    if (state.shrinkItem == null) return targetList;

    final deleteWorkBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == state.shrinkItem!.workBoardId,
    );
    final deleteWorkBoardItemIndex =
        targetList[deleteWorkBoardIndex].workBoardItemList.indexWhere(
              (element) =>
                  element.workBoardItemId == state.shrinkItem!.workBoardItemId,
            );
    if (deleteWorkBoardItemIndex == -1) {
      return targetList;
    }
    targetList[deleteWorkBoardIndex]
        .workBoardItemList
        .removeAt(deleteWorkBoardItemIndex);
    return targetList;
  }

  /// shrink itemを生成。取得。
  WorkBoardItemInfo getShrinkItem({required String workBoardId}) {
    return WorkBoardItemInfo(
      workBoardId: workBoardId,
      workBoardItemId: kShrinkId,
      title: '',
      description: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      labelList: [],
    );
  }
}
