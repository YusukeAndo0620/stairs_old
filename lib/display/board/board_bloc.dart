import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../board/drag_item_bloc.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

// Event
abstract class BoardEvent {
  const BoardEvent();
}

class _Init extends BoardEvent {
  const _Init();
}

class BoardGetList extends BoardEvent {
  const BoardGetList({required this.projectId});
  final String projectId;
}

class BoardAddCard extends BoardEvent {
  const BoardAddCard({
    required this.projectId,
    required this.title,
  });

  final String projectId;
  final String title;
}

class BoardAddTaskItem extends BoardEvent {
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

class BoardUpdateTaskItem extends BoardEvent {
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

class BoardTapListItem extends BoardEvent {
  const BoardTapListItem({required this.taskItemId});

  final String taskItemId;
}

class BoardTapEdit extends BoardEvent {
  const BoardTapEdit({
    required this.boardId,
    required this.context,
    required this.theme,
  });

  final String boardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class BoardDeleteListItem extends BoardEvent {
  const BoardDeleteListItem({
    required this.boardId,
    required this.taskItemId,
  });
  final String boardId;
  final String taskItemId;
}

/// Replace dragging item to shrink item.
class BoardReplaceShrinkItem extends BoardEvent {
  const BoardReplaceShrinkItem({
    required this.boardId,
    required this.taskItemId,
    required this.shrinkItem,
  });
  final String boardId;
  final String taskItemId;
  final TaskItemInfo shrinkItem;
}

// Delete and Add shrink item when item is dragging.
class BoardDeleteAndAddShrinkItem extends BoardEvent {
  const BoardDeleteAndAddShrinkItem({
    required this.boardId,
    required this.insertingIndex,
    required this.shrinkItem,
  });

  final String boardId;
  final int insertingIndex;
  final TaskItemInfo shrinkItem;
}

// Complete dragging.
class BoardCompleteDraggedItem extends BoardEvent {
  const BoardCompleteDraggedItem({
    required this.draggingItem,
    required this.shrinkItem,
  });
  final TaskItemInfo draggingItem;
  final TaskItemInfo shrinkItem;
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
  });

  final List<BoardInfo> boardList;

  @override
  List<Object?> get props => [
        boardList,
      ];

  BoardListState copyWith({
    List<BoardInfo>? boardList,
  }) =>
      BoardListState(
        boardList: boardList ?? this.boardList,
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

  ///Get task item index in target work board.
  int getBoardIndex({required String boardId}) {
    return boardList.indexWhere(
      (element) => element.boardId == boardId,
    );
  }

  ///Get task item index in target work board.
  int getTaskItemIndex({
    required String boardId,
    required String taskItemId,
  }) {
    if (getBoardIndex(boardId: boardId) == -1) return -1;
    return boardList[getBoardIndex(boardId: boardId)]
        .taskItemList
        .indexWhere((element) => element.taskItemId == taskItemId);
  }
}

// Bloc
class BoardBloc extends Bloc<BoardEvent, BoardState> {
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
    if (!isListState()) return;
    final emitBoardList = [...(state as BoardListState).boardList];
    final targetBoardIndex =
        (state as BoardListState).getBoardIndex(boardId: event.boardId);
    if (targetBoardIndex == -1) return;

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
    if (!isListState()) return;
    final emitBoardList = [...(state as BoardListState).boardList];
    final targetBoardIndex =
        (state as BoardListState).getBoardIndex(boardId: event.boardId);

    if (targetBoardIndex == -1) return;
    final targetTaskItemIndex = (state as BoardListState).getTaskItemIndex(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
    );
    if (targetBoardIndex == -1) return;

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

  void _onTapEdit(BoardTapEdit event, Emitter<BoardState> emit) {
    if (!isListState()) return;
  }

  Future<void> _onDeleteListItem(
      BoardDeleteListItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final listState = (state as BoardListState);
    final targetList = [...listState.boardList];

    final deleteBoardIndex = listState.getBoardIndex(boardId: event.boardId);
    if (deleteBoardIndex == -1) return;
    final deleteBoardItemIndex = (state as BoardListState).getTaskItemIndex(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
    );

    targetList[deleteBoardIndex].taskItemList.removeAt(deleteBoardItemIndex);
    emit(listState.copyWith(boardList: targetList));
  }

  Future<void> _onReplaceShrinkItem(
      BoardReplaceShrinkItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final targetList = [...(state as BoardListState).boardList];
    final boardIndex =
        (state as BoardListState).getBoardIndex(boardId: event.boardId);
    if (boardIndex == -1) return;
    final boardItemIndex = (state as BoardListState).getTaskItemIndex(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
    );

    targetList[boardIndex].taskItemList[boardItemIndex] = event.shrinkItem;

    emit((state as BoardListState).copyWith(boardList: targetList));
  }

  Future<void> _onDeleteAndAddShrinkItem(
      BoardDeleteAndAddShrinkItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final listState = (state as BoardListState);
    var targetList = [...listState.boardList];
    final currentShrinkItemBoardIndex =
        listState.getBoardIndex(boardId: event.shrinkItem.boardId);
    final currentShrinkItemTaskItemIndex = listState.getTaskItemIndex(
      boardId: event.shrinkItem.boardId,
      taskItemId: event.shrinkItem.taskItemId,
    );

    // Shrink Itemを追加する対象のBoard
    final boardIndex =
        (state as BoardListState).getBoardIndex(boardId: event.boardId);
    if (boardIndex == -1) return;
    final targetBoard = targetList[boardIndex];

    if (targetList[boardIndex].taskItemList.isEmpty) {
      final replaceBoard = BoardInfo(
          projectId: targetBoard.projectId,
          boardId: targetBoard.boardId,
          title: targetBoard.title,
          taskItemList: [event.shrinkItem]);
      targetList.replaceRange(boardIndex, boardIndex + 1, [replaceBoard]);
    } else {
      targetBoard.taskItemList.insert(
          targetBoard.taskItemList.isEmpty ? 1 : event.insertingIndex,
          event.shrinkItem);
    }

    //同じワークボード内で移動した場合、それぞれのindexで削除対象を判定
    if (event.shrinkItem.boardId ==
        targetList[currentShrinkItemBoardIndex].boardId) {
      targetBoard.taskItemList.removeAt(
          currentShrinkItemTaskItemIndex < event.insertingIndex
              ? currentShrinkItemTaskItemIndex
              : currentShrinkItemTaskItemIndex + 1);
    } else {
      targetList[currentShrinkItemBoardIndex]
          .taskItemList
          .removeAt(currentShrinkItemTaskItemIndex);
    }

    emit(listState.copyWith(boardList: targetList));
  }

  Future<void> _onReplaceDraggedItem(
      BoardCompleteDraggedItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final listState = (state as BoardListState);
    final targetList = [...listState.boardList];
    final boardIndex =
        listState.getBoardIndex(boardId: event.shrinkItem.boardId);

    final boardItemIndex = listState.getTaskItemIndex(
      boardId: event.shrinkItem.boardId,
      taskItemId: event.shrinkItem.taskItemId,
    );
    if (boardItemIndex == -1) return;
    targetList[boardIndex].taskItemList[boardItemIndex] = event.draggingItem;
    emit(listState.copyWith(boardList: targetList));
  }

  bool isListState() {
    return state is BoardListState;
  }
}
