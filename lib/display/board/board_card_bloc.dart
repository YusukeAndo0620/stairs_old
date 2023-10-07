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
    required this.projectId,
    required this.boardId,
    required this.title,
    required this.taskItemList,
  });
  final String projectId;
  final String boardId;
  final String title;
  final List<TaskItemInfo> taskItemList;
}

class BoardCardUpdate extends BoardCardEvent {
  const BoardCardUpdate({
    required this.boardId,
    required this.context,
    required this.theme,
  });

  final String boardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class BoardCardAddTaskItem extends BoardCardEvent {
  const BoardCardAddTaskItem({
    required this.boardId,
    required this.taskItemId,
    required this.title,
    required this.dueDate,
    required this.labelList,
  });

  final String taskItemId;
  final String boardId;
  final String title;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
}

class BoardCardUpdateTaskItem extends BoardCardEvent {
  const BoardCardUpdateTaskItem({
    required this.boardId,
    required this.taskItemId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.labelList,
  });

  final String boardId;
  final String taskItemId;
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
    required this.boardId,
    required this.taskItemId,
  });
  final String boardId;
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
    required this.boardId,
    required this.taskItemId,
  });
  final String boardId;
  final String taskItemId;
}

// Delete and Add shrink item when item is dragging.
class BoardCardDeleteAndAddShrinkItem extends BoardCardEvent {
  const BoardCardDeleteAndAddShrinkItem({
    required this.boardId,
    required this.insertingIndex,
  });

  final String boardId;
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
    required this.boardInfo,
    this.draggingItem,
    this.shrinkItem,
  });

  final BoardInfo boardInfo;
  final TaskItemInfo? draggingItem;
  final TaskItemInfo? shrinkItem;

  @override
  List<Object?> get props => [
        boardInfo,
        draggingItem,
        shrinkItem,
      ];

  BoardCardState copyWith({
    BoardInfo? boardInfo,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      BoardCardState(
        boardInfo: boardInfo ?? this.boardInfo,
        draggingItem: draggingItem ?? this.draggingItem,
        shrinkItem: shrinkItem ?? this.shrinkItem,
      );

  ///Check shrink item is included in target work board card list.
  bool hasShrinkItem(String boardId) {
    return boardInfo.taskItemList
            .firstWhereOrNull((element) => element.taskItemId == kShrinkId) !=
        null;
  }
}

// Bloc
class BoardCardBloc extends Bloc<BoardCardEvent, BoardCardState> {
  BoardCardBloc()
      : super(
          BoardCardState(
            boardInfo: BoardInfo(
              projectId: '',
              boardId: '',
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
        boardInfo: BoardInfo(
          projectId: '',
          boardId: '',
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
        boardInfo: BoardInfo(
          projectId: event.projectId,
          boardId: event.boardId,
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
    final emitBoardInfo = state.boardInfo;

    emitBoardInfo.taskItemList.add(
      TaskItemInfo(
        boardId: event.boardId,
        taskItemId: event.taskItemId,
        title: event.title,
        description: '',
        startDate: DateTime.now(),
        endDate: event.dueDate,
        labelList: event.labelList,
      ),
    );
    emit(
      state.copyWith(boardInfo: emitBoardInfo),
    );
  }

  Future<void> _onUpdateTaskItem(
      BoardCardUpdateTaskItem event, Emitter<BoardCardState> emit) async {
    final emitBoardInfo = state.boardInfo;
    final targetTaskItemIndex = state.boardInfo.taskItemList
        .indexWhere((element) => element.taskItemId == event.taskItemId);

    final replaceTaskItem = TaskItemInfo(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.dueDate,
      labelList: event.labelList,
    );

    emitBoardInfo.taskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emit(
      state.copyWith(boardInfo: emitBoardInfo),
    );
  }

  Future<void> _onDeleteTaskItem(
      BoardCardDeleteTaskItem event, Emitter<BoardCardState> emit) async {
    final emitBoardInfo = state.boardInfo;

    final targetTaskItemIndex = emitBoardInfo.taskItemList
        .indexWhere((element) => element.taskItemId == event.taskItemId);

    emitBoardInfo.taskItemList.removeAt(targetTaskItemIndex);
    emit(state.copyWith(boardInfo: emitBoardInfo));
  }

  Future<void> _onInitDragging(
      BoardCardInitDragging event, Emitter<BoardCardState> emit) async {
    emit(
      BoardCardState(boardInfo: state.boardInfo),
    );
  }

  Future<void> _onSetDraggingItem(
      BoardCardSetDraggingItem event, Emitter<BoardCardState> emit) async {
    emit(state.copyWith(draggingItem: event.draggingItem));
  }

  // Drag時、対象要素をShrink Itemに置き換える
  Future<void> _onReplaceShrinkItem(
      BoardCardReplaceShrinkItem event, Emitter<BoardCardState> emit) async {
    final shrinkItem = getShrinkItem(boardId: event.boardId);
    final emitBoardInfo = state.boardInfo;

    final targetTaskItemIndex = emitBoardInfo.taskItemList.indexWhere(
      (element) => element.taskItemId == event.taskItemId,
    );
    emitBoardInfo.taskItemList[targetTaskItemIndex] = shrinkItem;

    emit(state.copyWith(boardInfo: emitBoardInfo, shrinkItem: shrinkItem));
  }

  Future<void> _onDeleteAndAddShrinkItem(BoardCardDeleteAndAddShrinkItem event,
      Emitter<BoardCardState> emit) async {
    final shrinkItem = getShrinkItem(boardId: event.boardId);
    final emitBoardInfo = state.boardInfo;
    // Task Item Listが空の場合
    if (emitBoardInfo.taskItemList.isEmpty) {
      emitBoardInfo.taskItemList.add(shrinkItem);
    } else {
      final currentShrinkItemIndex = emitBoardInfo.taskItemList.indexWhere(
          (element) => element.taskItemId == state.shrinkItem!.taskItemId);

      // Shrink Item追加
      emitBoardInfo.taskItemList.insert(event.insertingIndex, shrinkItem);

      //indexで削除対象を判定
      emitBoardInfo.taskItemList.removeAt(
          currentShrinkItemIndex < event.insertingIndex
              ? currentShrinkItemIndex
              : currentShrinkItemIndex + 1);
    }
    emit(state.copyWith(boardInfo: emitBoardInfo, shrinkItem: shrinkItem));
  }

  //Shrink Item削除時、他Cardに移動しているため、Dragging Itemも初期化
  Future<void> _onDeleteShrinkItem(BoardCardDeleteAndAddShrinkItem event,
      Emitter<BoardCardState> emit) async {
    final emitBoardInfo = state.boardInfo;

    final currentShrinkItemIndex = emitBoardInfo.taskItemList.indexWhere(
        (element) => element.taskItemId == state.shrinkItem!.taskItemId);

    //indexで削除対象を判定
    emitBoardInfo.taskItemList.removeAt(currentShrinkItemIndex);

    emit(
      BoardCardState(boardInfo: emitBoardInfo),
    );
  }

  Future<void> _onReplaceDraggedItem(
      BoardCardCompleteDraggedItem event, Emitter<BoardCardState> emit) async {
    if (state.draggingItem == null || state.shrinkItem == null) {
      return;
    }
    final emitBoardInfo = state.boardInfo;
    final targetTaskItemIndex = emitBoardInfo.taskItemList.indexWhere(
      (element) => element.taskItemId == state.shrinkItem!.taskItemId,
    );
    emitBoardInfo.taskItemList[targetTaskItemIndex] = state.draggingItem!;

    emit(state.copyWith(boardInfo: emitBoardInfo));
    add(const BoardCardInitDragging());
  }

  /// shrink itemを生成。取得。
  TaskItemInfo getShrinkItem({required String boardId}) {
    return TaskItemInfo(
      boardId: boardId,
      taskItemId: kShrinkId,
      title: '',
      description: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      labelList: [],
    );
  }
}
