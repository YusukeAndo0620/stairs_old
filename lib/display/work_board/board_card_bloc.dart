import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import '../../model/model.dart';

const kShrinkId = 'shrinkId';

// Event
abstract class BoardCardEvent {
  const BoardCardEvent();
}

class _Init extends BoardCardEvent {
  const _Init();
}

class BoardCardGetList extends BoardCardEvent {
  const BoardCardGetList({
    required this.workBoardId,
    required this.title,
    required this.taskItemList,
  });
  final String workBoardId;
  final String title;
  final List<TaskItemInfo> taskItemList;
}

class BoardCardUpdate extends BoardCardEvent {
  const BoardCardUpdate({
    required this.workBoardId,
    required this.context,
    required this.theme,
  });

  final String workBoardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class BoardCardAddTaskItem extends BoardCardEvent {
  const BoardCardAddTaskItem({
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

class BoardCardUpdateTaskItem extends BoardCardEvent {
  const BoardCardUpdateTaskItem({
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

class BoardCardTapListItem extends BoardCardEvent {
  const BoardCardTapListItem({required this.taskItemId});

  final String taskItemId;
}

class BoardCardDeleteTaskItem extends BoardCardEvent {
  const BoardCardDeleteTaskItem({
    required this.workBoardId,
    required this.taskItemId,
  });
  final String workBoardId;
  final String taskItemId;
}

/// Init drag. shrink item and dragging item is initialized.
class BoardCardInitDragging extends BoardCardEvent {
  const BoardCardInitDragging();
}

/// Set Dragging item.
class BoardCardSetDraggingItem extends BoardCardEvent {
  const BoardCardSetDraggingItem({
    required this.draggingItem,
  });
  final TaskItemInfo draggingItem;
}

/// Replace dragging item to shrink item.
class BoardCardReplaceShrinkItem extends BoardCardEvent {
  const BoardCardReplaceShrinkItem({
    required this.workBoardId,
    required this.taskItemId,
  });
  final String workBoardId;
  final String taskItemId;
}

// Delete and Add shrink item when item is dragging.
class BoardCardDeleteAndAddShrinkItem extends BoardCardEvent {
  const BoardCardDeleteAndAddShrinkItem({
    required this.workBoardId,
    required this.insertingIndex,
  });

  final String workBoardId;
  final int insertingIndex;
}

// Complete dragging.
class BoardCardCompleteDraggedItem extends BoardCardEvent {
  const BoardCardCompleteDraggedItem();
}

// State
@immutable
class BoardCardState extends Equatable {
  const BoardCardState({
    required this.workBoard,
    this.draggingItem,
    this.shrinkItem,
  });

  final WorkBoard workBoard;
  final TaskItemInfo? draggingItem;
  final TaskItemInfo? shrinkItem;

  @override
  List<Object?> get props => [
        workBoard,
        draggingItem,
        shrinkItem,
      ];

  BoardCardState copyWith({
    WorkBoard? workBoard,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      BoardCardState(
        workBoard: workBoard ?? this.workBoard,
        draggingItem: draggingItem ?? this.draggingItem,
        shrinkItem: shrinkItem ?? this.shrinkItem,
      );

  ///Check shrink item is included in target work board card list.
  bool hasShrinkItem(String workBoardId) {
    return workBoard.taskItemList
            .firstWhereOrNull((element) => element.taskItemId == kShrinkId) !=
        null;
  }
}

// Bloc
class BoardCardBloc extends Bloc<BoardCardEvent, BoardCardState> {
  BoardCardBloc()
      : super(
          BoardCardState(
            workBoard: WorkBoard(
              workBoardId: '',
              title: '',
              taskItemList: [],
            ),
          ),
        ) {
    on<_Init>(_onInit);
    on<BoardCardGetList>(_onGetList);
    on<BoardCardUpdate>(_onUpdateCard);
    on<BoardCardTapListItem>(_onTapListItem);
    on<BoardCardAddTaskItem>(_onAddTaskItem);
    on<BoardCardUpdateTaskItem>(_onUpdateTaskItem);
    on<BoardCardDeleteTaskItem>(_onDeleteTaskItem);
    on<BoardCardInitDragging>(_onInitDragging);
    on<BoardCardSetDraggingItem>(_onSetDraggingItem);
    on<BoardCardReplaceShrinkItem>(_onReplaceShrinkItem);
    on<BoardCardDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
    on<BoardCardCompleteDraggedItem>(_onReplaceDraggedItem);
  }

  void _onInit(_Init event, Emitter<BoardCardState> emit) {
    emit(
      BoardCardState(
        workBoard: WorkBoard(
          workBoardId: '',
          title: '',
          taskItemList: [],
        ),
      ),
    );
  }

  Future<void> _onGetList(
      BoardCardGetList event, Emitter<BoardCardState> emit) async {
    emit(
      BoardCardState(
        workBoard: WorkBoard(
          workBoardId: event.workBoardId,
          title: event.title,
          taskItemList: event.taskItemList,
        ),
      ),
    );
  }

  void _onUpdateCard(BoardCardUpdate event, Emitter<BoardCardState> emit) {}

  Future<void> _onTapListItem(
      BoardCardTapListItem event, Emitter<BoardCardState> emit) async {}

  Future<void> _onAddTaskItem(
      BoardCardAddTaskItem event, Emitter<BoardCardState> emit) async {
    final emitWorkBoard = state.workBoard;

    emitWorkBoard.taskItemList.add(
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
      state.copyWith(workBoard: emitWorkBoard),
    );
  }

  Future<void> _onUpdateTaskItem(
      BoardCardUpdateTaskItem event, Emitter<BoardCardState> emit) async {
    final emitWorkBoard = state.workBoard;
    final targetTaskItemIndex = state.workBoard.taskItemList
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

    emitWorkBoard.taskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emit(
      state.copyWith(workBoard: emitWorkBoard),
    );
  }

  Future<void> _onDeleteTaskItem(
      BoardCardDeleteTaskItem event, Emitter<BoardCardState> emit) async {
    final emitWorkBoard = state.workBoard;

    final targetTaskItemIndex = emitWorkBoard.taskItemList
        .indexWhere((element) => element.taskItemId == event.taskItemId);

    emitWorkBoard.taskItemList.removeAt(targetTaskItemIndex);
    emit(state.copyWith(workBoard: emitWorkBoard));
  }

  Future<void> _onInitDragging(
      BoardCardInitDragging event, Emitter<BoardCardState> emit) async {
    emit(
      BoardCardState(workBoard: state.workBoard),
    );
  }

  Future<void> _onSetDraggingItem(
      BoardCardSetDraggingItem event, Emitter<BoardCardState> emit) async {
    emit(state.copyWith(draggingItem: event.draggingItem));
  }

  // Drag時、対象要素をShrink Itemに置き換える
  Future<void> _onReplaceShrinkItem(
      BoardCardReplaceShrinkItem event, Emitter<BoardCardState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final emitWorkBoard = state.workBoard;

    final targetTaskItemIndex = emitWorkBoard.taskItemList.indexWhere(
      (element) => element.taskItemId == event.taskItemId,
    );
    emitWorkBoard.taskItemList[targetTaskItemIndex] = shrinkItem;

    emit(state.copyWith(workBoard: emitWorkBoard, shrinkItem: shrinkItem));
  }

  Future<void> _onDeleteAndAddShrinkItem(BoardCardDeleteAndAddShrinkItem event,
      Emitter<BoardCardState> emit) async {
    final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
    final emitWorkBoard = state.workBoard;
    // Task Item Listが空の場合
    if (emitWorkBoard.taskItemList.isEmpty) {
      emitWorkBoard.taskItemList.add(shrinkItem);
    } else {
      final currentShrinkItemIndex = emitWorkBoard.taskItemList.indexWhere(
          (element) => element.taskItemId == state.shrinkItem!.taskItemId);

      // Shrink Item追加
      emitWorkBoard.taskItemList.insert(event.insertingIndex, shrinkItem);

      //indexで削除対象を判定
      emitWorkBoard.taskItemList.removeAt(
          currentShrinkItemIndex < event.insertingIndex
              ? currentShrinkItemIndex
              : currentShrinkItemIndex + 1);
    }
    emit(state.copyWith(workBoard: emitWorkBoard, shrinkItem: shrinkItem));
  }

  //Shrink Item削除時、他Cardに移動しているため、Dragging Itemも初期化
  Future<void> _onDeleteShrinkItem(BoardCardDeleteAndAddShrinkItem event,
      Emitter<BoardCardState> emit) async {
    final emitWorkBoard = state.workBoard;

    final currentShrinkItemIndex = emitWorkBoard.taskItemList.indexWhere(
        (element) => element.taskItemId == state.shrinkItem!.taskItemId);

    //indexで削除対象を判定
    emitWorkBoard.taskItemList.removeAt(currentShrinkItemIndex);

    emit(
      BoardCardState(workBoard: emitWorkBoard),
    );
  }

  Future<void> _onReplaceDraggedItem(
      BoardCardCompleteDraggedItem event, Emitter<BoardCardState> emit) async {
    if (state.draggingItem == null || state.shrinkItem == null) {
      return;
    }
    final emitWorkBoard = state.workBoard;
    final targetTaskItemIndex = emitWorkBoard.taskItemList.indexWhere(
      (element) => element.taskItemId == state.shrinkItem!.taskItemId,
    );
    emitWorkBoard.taskItemList[targetTaskItemIndex] = state.draggingItem!;

    emit(state.copyWith(workBoard: emitWorkBoard));
    add(const BoardCardInitDragging());
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
