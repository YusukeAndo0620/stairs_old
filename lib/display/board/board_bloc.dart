import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

const kShrinkId = 'shrinkId';

// Event
abstract class BoardBlocEvent {
  const BoardBlocEvent();
}

class _Init extends BoardBlocEvent {
  const _Init();
}

class BoardGetList extends BoardBlocEvent {
  const BoardGetList({required this.projectId});
  final String projectId;
}

class BoardAddCard extends BoardBlocEvent {
  const BoardAddCard({
    required this.projectId,
    required this.title,
  });

  final String projectId;
  final String title;
}

class BoardAddTaskItem extends BoardBlocEvent {
  const BoardAddTaskItem({
    required this.boardId,
    required this.taskItemId,
    required this.title,
    required this.dueDate,
    required this.labelList,
  });

  final String boardId;
  final String taskItemId;
  final String title;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
}

class BoardUpdateTaskItem extends BoardBlocEvent {
  const BoardUpdateTaskItem({
    required this.boardId,
    required this.taskItemId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.labelList,
  });

  final String taskItemId;
  final String boardId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;
}

class BoardTapListItem extends BoardBlocEvent {
  const BoardTapListItem({required this.taskItemId});

  final String taskItemId;
}

class BoardTapEdit extends BoardBlocEvent {
  const BoardTapEdit({
    required this.boardId,
    required this.context,
    required this.theme,
  });

  final String boardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class BoardDeleteListItem extends BoardBlocEvent {
  const BoardDeleteListItem({
    required this.boardId,
    required this.taskItemId,
  });
  final String boardId;
  final String taskItemId;
}

/// Init drag. shrink item and dragging item is initialized.
class BoardInitDragging extends BoardBlocEvent {
  const BoardInitDragging();
}

/// Set Dragging item.
class BoardSetDraggingItem extends BoardBlocEvent {
  const BoardSetDraggingItem({
    required this.draggingItem,
  });
  final TaskItemInfo draggingItem;
}

/// Replace dragging item to shrink item.
class BoardReplaceShrinkItem extends BoardBlocEvent {
  const BoardReplaceShrinkItem({
    required this.boardId,
    required this.taskItemId,
  });
  final String boardId;
  final String taskItemId;
}

// Delete and Add shrink item when item is dragging.
class BoardDeleteAndAddShrinkItem extends BoardBlocEvent {
  const BoardDeleteAndAddShrinkItem({
    required this.boardId,
    required this.insertingIndex,
  });

  final String boardId;
  final int insertingIndex;
}

// Complete dragging.
class BoardCompleteDraggedItem extends BoardBlocEvent {
  const BoardCompleteDraggedItem();
}

// State
@immutable
abstract class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object?> get props => [];
}

//Initial
class BoardInitialState extends BoardState {
  const BoardInitialState();

  @override
  List<Object?> get props => [];
}

class BoardListState extends BoardState {
  const BoardListState({
    required this.boardList,
    this.draggingItem,
    this.shrinkItem,
  });

  final List<BoardInfo> boardList;
  final TaskItemInfo? draggingItem;
  final TaskItemInfo? shrinkItem;

  @override
  List<Object?> get props => [
        boardList,
        draggingItem,
        shrinkItem,
      ];

  BoardListState copyWith({
    List<BoardInfo>? boardList,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      BoardListState(
        boardList: boardList ?? this.boardList,
        draggingItem: draggingItem ?? this.draggingItem,
        shrinkItem: shrinkItem ?? this.shrinkItem,
      );

  ///Check shrink item is included in target work board card list.
  bool hasShrinkItem(String boardId) {
    final targetBoard = boardList.firstWhereOrNull(
      (element) => element.boardId == boardId,
    );
    if (targetBoard == null) return false;
    return targetBoard.taskItemList
            .firstWhereOrNull((element) => element.taskItemId == kShrinkId) !=
        null;
  }
}

// Bloc
class BoardBloc extends Bloc<BoardBlocEvent, BoardState> {
  BoardBloc()
      : super(
          const BoardInitialState(),
        ) {
    on<_Init>(_onInit);
    on<BoardGetList>(_onGetList);
    on<BoardTapListItem>(_onTapListItem);
    on<BoardAddCard>(_onAddCard);
    on<BoardAddTaskItem>(_onAddTaskItem);
    on<BoardUpdateTaskItem>(_onUpdateTaskItem);
    on<BoardTapEdit>(_onTapEdit);
    on<BoardDeleteListItem>(_onDeleteListItem);
    on<BoardInitDragging>(_onInitDragging);
    on<BoardSetDraggingItem>(_onSetDraggingItem);
    on<BoardReplaceShrinkItem>(_onReplaceShrinkItem);
    on<BoardDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
    on<BoardCompleteDraggedItem>(_onReplaceDraggedItem);
  }

  void _onInit(_Init event, Emitter<BoardState> emit) {
    emit(const BoardListState(boardList: []));
  }

  Future<void> _onGetList(BoardGetList event, Emitter<BoardState> emit) async {
    emit(BoardListState(boardList: dummyBoardList));
  }

  Future<void> _onTapListItem(
      BoardTapListItem event, Emitter<BoardState> emit) async {}

  Future<void> _onAddCard(BoardAddCard event, Emitter<BoardState> emit) async {
    final emitList = [
      ...(state as BoardListState).boardList,
    ];

    emitList.add(
      BoardInfo(
        projectId: event.projectId,
        boardId: uuid.v4(),
        title: event.title,
        taskItemList: <TaskItemInfo>[],
      ),
    );
    emit((state as BoardListState).copyWith(boardList: emitList));
  }

  Future<void> _onAddTaskItem(
      BoardAddTaskItem event, Emitter<BoardState> emit) async {
    final emitBoardList = [...(state as BoardListState).boardList];
    final targetBoardIndex =
        emitBoardList.indexWhere((element) => element.boardId == event.boardId);
    if (targetBoardIndex < 0) return;

    emitBoardList[targetBoardIndex].taskItemList.add(
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
      (state as BoardListState).copyWith(boardList: emitBoardList),
    );
  }

  Future<void> _onUpdateTaskItem(
      BoardUpdateTaskItem event, Emitter<BoardState> emit) async {
    final emitBoardList = [...(state as BoardListState).boardList];
    final targetBoardIndex =
        emitBoardList.indexWhere((element) => element.boardId == event.boardId);
    if (targetBoardIndex < 0) return;
    final targetTaskItemIndex = emitBoardList[targetBoardIndex]
        .taskItemList
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

    emitBoardList[targetBoardIndex].taskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emit(
      (state as BoardListState).copyWith(boardList: emitBoardList),
    );
  }

  void _onTapEdit(BoardTapEdit event, Emitter<BoardState> emit) {}

  Future<void> _onDeleteListItem(
      BoardDeleteListItem event, Emitter<BoardState> emit) async {
    final listState = (state as BoardListState);
    final targetList = [...listState.boardList];

    final deleteBoardIndex = targetList.indexWhere(
      (element) => element.boardId == event.boardId,
    );
    final deleteBoardItemIndex =
        targetList[deleteBoardIndex].taskItemList.indexWhere(
              (element) => element.taskItemId == event.taskItemId,
            );
    targetList[deleteBoardIndex].taskItemList.removeAt(deleteBoardItemIndex);
    emit(listState.copyWith(boardList: targetList));
  }

  Future<void> _onInitDragging(
      BoardInitDragging event, Emitter<BoardState> emit) async {
    emit(
      BoardListState(
        boardList: (state as BoardListState).boardList,
      ),
    );
  }

  Future<void> _onSetDraggingItem(
      BoardSetDraggingItem event, Emitter<BoardState> emit) async {
    emit(
      (state as BoardListState).copyWith(
        draggingItem: event.draggingItem,
      ),
    );
  }

  Future<void> _onReplaceShrinkItem(
      BoardReplaceShrinkItem event, Emitter<BoardState> emit) async {
    final shrinkItem = getShrinkItem(boardId: event.boardId);
    final targetList = [...(state as BoardListState).boardList];
    final boardIndex = targetList.indexWhere(
      (element) => element.boardId == event.boardId,
    );
    final boardItemIndex = targetList[boardIndex].taskItemList.indexWhere(
          (element) => element.taskItemId == event.taskItemId,
        );
    targetList[boardIndex].taskItemList[boardItemIndex] = shrinkItem;

    emit((state as BoardListState)
        .copyWith(boardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onDeleteAndAddShrinkItem(
      BoardDeleteAndAddShrinkItem event, Emitter<BoardState> emit) async {
    final shrinkItem = getShrinkItem(boardId: event.boardId);
    final listState = (state as BoardListState);

    var targetList = [...listState.boardList];

    if (listState.shrinkItem == null) return;
    final currentShrinkItemWBIndex = targetList.indexWhere(
      (element) => element.boardId == listState.shrinkItem!.boardId,
    );
    final currentShrinkItemWBItemIndex = targetList
        .firstWhere(
            (element) => element.boardId == listState.shrinkItem!.boardId)
        .taskItemList
        .indexWhere((element) =>
            element.taskItemId == listState.shrinkItem!.taskItemId);

    // Shrink Itemを追加する対象のBoard
    final boardIndex = targetList.indexWhere(
      (element) => element.boardId == event.boardId,
    );
    final targetBoard = targetList[boardIndex];

    if (targetList[boardIndex].taskItemList.isEmpty) {
      final replaceBoard = BoardInfo(
          projectId: targetBoard.projectId,
          boardId: targetBoard.boardId,
          title: targetBoard.title,
          taskItemList: [shrinkItem]);
      targetList.replaceRange(boardIndex, boardIndex + 1, [replaceBoard]);
    } else {
      targetBoard.taskItemList.insert(
          targetBoard.taskItemList.isEmpty ? 1 : event.insertingIndex,
          shrinkItem);
    }

    //同じワークボード内で移動した場合、それぞれのindexで削除対象を判定
    if (shrinkItem.boardId == listState.shrinkItem!.boardId) {
      targetBoard.taskItemList.removeAt(
          currentShrinkItemWBItemIndex < event.insertingIndex
              ? currentShrinkItemWBItemIndex
              : currentShrinkItemWBItemIndex + 1);
    } else {
      targetList[currentShrinkItemWBIndex]
          .taskItemList
          .removeAt(currentShrinkItemWBItemIndex);
    }

    emit(listState.copyWith(boardList: targetList, shrinkItem: shrinkItem));
  }

  Future<void> _onReplaceDraggedItem(
      BoardCompleteDraggedItem event, Emitter<BoardState> emit) async {
    final listState = (state as BoardListState);
    if (listState.draggingItem == null || listState.shrinkItem == null) {
      return;
    }
    final targetList = [...listState.boardList];
    final boardIndex = targetList.indexWhere(
      (element) => element.boardId == listState.shrinkItem!.boardId,
    );
    final boardItemIndex = targetList[boardIndex].taskItemList.indexWhere(
          (element) => element.taskItemId == listState.shrinkItem!.taskItemId,
        );
    targetList[boardIndex].taskItemList[boardItemIndex] =
        listState.draggingItem!;

    emit(listState.copyWith(boardList: targetList));
    add(const BoardInitDragging());
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
