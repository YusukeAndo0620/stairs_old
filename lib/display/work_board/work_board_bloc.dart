import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
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
  const WorkBoardAddCard({required this.title});

  final String title;
}

class WorkBoardAddTaskItem extends WorkBoardBlocEvent {
  const WorkBoardAddTaskItem({
    required this.workBoardId,
    required this.taskItemId,
    required this.title,
    required this.dueDate,
    required this.labelList,
  });

  final String taskItemId;
  final String workBoardId;
  final String title;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
}

class WorkBoardUpdateTaskItem extends WorkBoardBlocEvent {
  const WorkBoardUpdateTaskItem({
    required this.workBoardId,
    required this.taskItemId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.labelList,
  });

  final String taskItemId;
  final String workBoardId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
}

class WorkBoardTapListItem extends WorkBoardBlocEvent {
  const WorkBoardTapListItem({required this.taskItemId});

  final String taskItemId;
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
    required this.taskItemId,
  });
  final String workBoardId;
  final String taskItemId;
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
  final TaskItemInfo draggingItem;
}

/// Replace dragging item to shrink item.
class WorkBoardReplaceShrinkItem extends WorkBoardBlocEvent {
  const WorkBoardReplaceShrinkItem({
    required this.workBoardId,
    required this.taskItemId,
  });
  final String workBoardId;
  final String taskItemId;
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
abstract class WorkBoardState extends Equatable {
  const WorkBoardState();

  @override
  List<Object?> get props => [];
}

//Initial
class WorkBoardInitialState extends WorkBoardState {
  const WorkBoardInitialState();

  @override
  List<Object?> get props => [];
}

class WorkBoardListState extends WorkBoardState {
  const WorkBoardListState({
    required this.workBoardList,
    this.draggingItem,
    this.shrinkItem,
  });

  final List<WorkBoard> workBoardList;
  final TaskItemInfo? draggingItem;
  final TaskItemInfo? shrinkItem;

  @override
  List<Object?> get props => [
        workBoardList,
        draggingItem,
        shrinkItem,
      ];

  WorkBoardListState copyWith({
    List<WorkBoard>? workBoardList,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      WorkBoardListState(
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
    return targetWorkBoard.taskItemList
            .firstWhereOrNull((element) => element.taskItemId == kShrinkId) !=
        null;
  }
}

// Bloc
class WorkBoardBloc extends Bloc<WorkBoardBlocEvent, WorkBoardState> {
  WorkBoardBloc()
      : super(
          const WorkBoardInitialState(),
        ) {
    on<_Init>(_onInit);
    on<WorkBoardGetList>(_onGetList);
    on<WorkBoardTapListItem>(_onTapListItem);
    on<WorkBoardAddCard>(_onAddCard);
    on<WorkBoardAddTaskItem>(_onAddTaskItem);
    on<WorkBoardUpdateTaskItem>(_onUpdateTaskItem);
    on<WorkBoardTapEdit>(_onTapEdit);
    on<WorkBoardDeleteListItem>(_onDeleteListItem);
    on<WorkBoardInitDragging>(_onInitDragging);
    on<WorkBoardSetDraggingItem>(_onSetDraggingItem);
    on<WorkBoardReplaceShrinkItem>(_onReplaceShrinkItem);
    on<WorkBoardDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
    on<WorkBoardCompleteDraggedItem>(_onReplaceDraggedItem);
  }

  void _onInit(_Init event, Emitter<WorkBoardState> emit) {
    emit(const WorkBoardListState(workBoardList: []));
  }

  Future<void> _onGetList(
      WorkBoardGetList event, Emitter<WorkBoardState> emit) async {
    emit(WorkBoardListState(workBoardList: dummyWorkBoardList));
  }

  Future<void> _onTapListItem(
      WorkBoardTapListItem event, Emitter<WorkBoardState> emit) async {}

  Future<void> _onAddCard(
      WorkBoardAddCard event, Emitter<WorkBoardState> emit) async {
    final emitList = [
      ...(state as WorkBoardListState).workBoardList,
    ];

    emitList.add(
      WorkBoard(
        workBoardId: uuid.v4(),
        title: event.title,
        taskItemList: <TaskItemInfo>[],
      ),
    );
    emit((state as WorkBoardListState).copyWith(workBoardList: emitList));
  }

  Future<void> _onAddTaskItem(
      WorkBoardAddTaskItem event, Emitter<WorkBoardState> emit) async {
    final emitWorkBoardList = [...(state as WorkBoardListState).workBoardList];
    final targetWorkBoardIndex = emitWorkBoardList
        .indexWhere((element) => element.workBoardId == event.workBoardId);
    if (targetWorkBoardIndex < 0) return;

    emitWorkBoardList[targetWorkBoardIndex].taskItemList.add(
          TaskItemInfo(
            workBoardId: event.workBoardId,
            taskItemId: event.taskItemId,
            title: event.title,
            description: '',
            startDate: DateTime.now(),
            endDate: event.dueDate,
            labelList: event.labelList,
          ),
        );
    emit(
      (state as WorkBoardListState).copyWith(workBoardList: emitWorkBoardList),
    );
  }

  Future<void> _onUpdateTaskItem(
      WorkBoardUpdateTaskItem event, Emitter<WorkBoardState> emit) async {
    final emitWorkBoardList = [...(state as WorkBoardListState).workBoardList];
    final targetWorkBoardIndex = emitWorkBoardList
        .indexWhere((element) => element.workBoardId == event.workBoardId);
    if (targetWorkBoardIndex < 0) return;
    final targetTaskItemIndex = emitWorkBoardList[targetWorkBoardIndex]
        .taskItemList
        .indexWhere((element) => element.taskItemId == event.taskItemId);

    final replaceTaskItem = TaskItemInfo(
      workBoardId: event.workBoardId,
      taskItemId: event.taskItemId,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.dueDate,
      labelList: event.labelList,
    );

    emitWorkBoardList[targetWorkBoardIndex].taskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emit(
      (state as WorkBoardListState).copyWith(workBoardList: emitWorkBoardList),
    );
  }

  void _onTapEdit(WorkBoardTapEdit event, Emitter<WorkBoardState> emit) {}

  Future<void> _onDeleteListItem(
      WorkBoardDeleteListItem event, Emitter<WorkBoardState> emit) async {
    final listState = (state as WorkBoardListState);
    final targetList = [...listState.workBoardList];

    final deleteWorkBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    final deleteWorkBoardItemIndex =
        targetList[deleteWorkBoardIndex].taskItemList.indexWhere(
              (element) => element.taskItemId == event.taskItemId,
            );
    targetList[deleteWorkBoardIndex]
        .taskItemList
        .removeAt(deleteWorkBoardItemIndex);
    emit(listState.copyWith(workBoardList: targetList));
  }

  Future<void> _onInitDragging(
      WorkBoardInitDragging event, Emitter<WorkBoardState> emit) async {
    emit(
      WorkBoardListState(
        workBoardList: (state as WorkBoardListState).workBoardList,
      ),
    );
  }

  Future<void> _onSetDraggingItem(
      WorkBoardSetDraggingItem event, Emitter<WorkBoardState> emit) async {
    emit(
      (state as WorkBoardListState).copyWith(
        draggingItem: event.draggingItem,
      ),
    );
  }

  Future<void> _onReplaceShrinkItem(
      WorkBoardReplaceShrinkItem event, Emitter<WorkBoardState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final targetList = [...(state as WorkBoardListState).workBoardList];
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    final workBoardItemIndex =
        targetList[workBoardIndex].taskItemList.indexWhere(
              (element) => element.taskItemId == event.taskItemId,
            );
    targetList[workBoardIndex].taskItemList[workBoardItemIndex] = shrinkItem;

    emit((state as WorkBoardListState)
        .copyWith(workBoardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onDeleteAndAddShrinkItem(WorkBoardDeleteAndAddShrinkItem event,
      Emitter<WorkBoardState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final listState = (state as WorkBoardListState);

    var targetList = [...listState.workBoardList];

    if (listState.shrinkItem == null) return;
    final currentShrinkItemWBIndex = targetList.indexWhere(
      (element) => element.workBoardId == listState.shrinkItem!.workBoardId,
    );
    final currentShrinkItemWBItemIndex = targetList
        .firstWhere((element) =>
            element.workBoardId == listState.shrinkItem!.workBoardId)
        .taskItemList
        .indexWhere((element) =>
            element.taskItemId == listState.shrinkItem!.taskItemId);

    // Shrink Itemを追加する対象のWorkBoard
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == event.workBoardId,
    );
    final targetWorkBoard = targetList[workBoardIndex];

    if (targetList[workBoardIndex].taskItemList.isEmpty) {
      final replaceWorkBoard = WorkBoard(
          workBoardId: targetWorkBoard.workBoardId,
          title: targetWorkBoard.title,
          taskItemList: [shrinkItem]);
      targetList
          .replaceRange(workBoardIndex, workBoardIndex + 1, [replaceWorkBoard]);
    } else {
      targetWorkBoard.taskItemList.insert(
          targetWorkBoard.taskItemList.isEmpty ? 1 : event.insertingIndex,
          shrinkItem);
    }

    //同じワークボード内で移動した場合、それぞれのindexで削除対象を判定
    if (shrinkItem.workBoardId == listState.shrinkItem!.workBoardId) {
      targetWorkBoard.taskItemList.removeAt(
          currentShrinkItemWBItemIndex < event.insertingIndex
              ? currentShrinkItemWBItemIndex
              : currentShrinkItemWBItemIndex + 1);
    } else {
      targetList[currentShrinkItemWBIndex]
          .taskItemList
          .removeAt(currentShrinkItemWBItemIndex);
    }

    emit(listState.copyWith(workBoardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onReplaceDraggedItem(
      WorkBoardCompleteDraggedItem event, Emitter<WorkBoardState> emit) async {
    final listState = (state as WorkBoardListState);
    if (listState.draggingItem == null || listState.shrinkItem == null) {
      return;
    }
    final targetList = [...listState.workBoardList];
    final workBoardIndex = targetList.indexWhere(
      (element) => element.workBoardId == listState.shrinkItem!.workBoardId,
    );
    final workBoardItemIndex =
        targetList[workBoardIndex].taskItemList.indexWhere(
              (element) =>
                  element.taskItemId == listState.shrinkItem!.taskItemId,
            );
    targetList[workBoardIndex].taskItemList[workBoardItemIndex] =
        listState.draggingItem!;

    emit(listState.copyWith(workBoardList: targetList));
    add(const WorkBoardInitDragging());
  }

  /// shrink itemを生成。取得。
  TaskItemInfo getShrinkItem({required String workBoardId}) {
    return TaskItemInfo(
      workBoardId: workBoardId,
      taskItemId: kShrinkId,
      title: '',
      description: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      labelList: [],
    );
  }
}
