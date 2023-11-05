import 'dart:math';

import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'board_position_bloc.dart';

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
    required this.shrinkItemPosition,
  });

  final List<BoardInfo> boardList;
  // key: board id, value: index of task item board card
  final Map<int, int> shrinkItemPosition;

  @override
  List<Object?> get props => [
        boardList,
        shrinkItemPosition,
      ];

  BoardListState copyWith({
    List<BoardInfo>? boardList,
    Map<int, int>? shrinkItemPosition,
  }) =>
      BoardListState(
        boardList: boardList ?? this.boardList,
        shrinkItemPosition: shrinkItemPosition ?? this.shrinkItemPosition,
      );

  ///Check shrink item is included in target board card list.
  bool hasShrinkItem(String boardId) {
    final targetBoard = boardList.firstWhereOrNull(
      (element) => element.boardId == boardId,
    );
    if (targetBoard == null) return false;
    return targetBoard.taskItemList
            .firstWhereOrNull((element) => element.taskItemId == kShrinkId) !=
        null;
  }

  ///get board id of shrink item is included in target board card list.
  String? get boardIdOfHavingShrinkItem {
    final targetBoardList = boardList
        .map((element) => element.taskItemList
            .firstWhereOrNull((item) => item.taskItemId == kShrinkId))
        .whereType<TaskItemInfo>()
        .toList();
    if (targetBoardList.isEmpty || targetBoardList.length != 1) return null;
    return targetBoardList.first.boardId;
  }

  ///Get task item index in target board card list.
  int getBoardIndex({required String boardId}) {
    return boardList.indexWhere(
      (element) => element.boardId == boardId,
    );
  }

  ///Get task item index in target board card list.
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

  final _logger = stairsLogger(name: 'board_bloc');

  void _onInit(_Init event, Emitter<BoardState> emit) {
    emit(const BoardListState(boardList: [], shrinkItemPosition: {}));
  }

  Future<void> _onGetList(BoardGetList event, Emitter<BoardState> emit) async {
    emit(BoardListState(
        boardList: dummyBoardList, shrinkItemPosition: const {}));
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
    final listState = state as BoardListState;
    final emitBoardList = [...listState.boardList];
    final targetBoardIndex = listState.getBoardIndex(boardId: event.boardId);
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
      listState.copyWith(boardList: emitBoardList),
    );
  }

  Future<void> _onUpdateTaskItem(
      BoardUpdateTaskItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final listState = state as BoardListState;
    final emitBoardList = [...listState.boardList];
    final targetBoardIndex = listState.getBoardIndex(boardId: event.boardId);

    if (targetBoardIndex == -1) return;
    final targetTaskItemIndex = listState.getTaskItemIndex(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
    );
    if (targetBoardIndex == -1) return;

    final replaceBoardInfo = BoardInfo(
      projectId: emitBoardList[targetBoardIndex].projectId,
      boardId: emitBoardList[targetBoardIndex].boardId,
      title: emitBoardList[targetBoardIndex].title,
      taskItemList: emitBoardList[targetBoardIndex].taskItemList,
    );

    final replaceTaskItem = TaskItemInfo(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.dueDate,
      labelList: event.labelList,
    );

    replaceBoardInfo.taskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emitBoardList.replaceRange(
        targetBoardIndex, targetBoardIndex + 1, [replaceBoardInfo]);

    emit(
      listState.copyWith(boardList: emitBoardList),
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
    final listState = (state as BoardListState);
    final targetList = [...listState.boardList];
    final boardIndex = listState.getBoardIndex(boardId: event.boardId);
    if (boardIndex == -1) return;
    final boardItemIndex = listState.getTaskItemIndex(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
    );

    targetList[boardIndex].taskItemList[boardItemIndex] = event.shrinkItem;

    emit(
      listState.copyWith(
        boardList: targetList,
        shrinkItemPosition: getShrinkItemPosition(
          boardIdIndex: listState.getBoardIndex(boardId: event.boardId),
          taskItemIndex: boardItemIndex,
        ),
      ),
    );
  }

  Future<void> _onDeleteAndAddShrinkItem(
      BoardDeleteAndAddShrinkItem event, Emitter<BoardState> emit) async {
    if (!isListState()) return;
    final listState = (state as BoardListState);
    var targetList = [...listState.boardList];
    // 現在のリスト内shrink itemのindexを参照するため、ここで定義
    final currentShrinkItemBoardIndex =
        listState.getBoardIndex(boardId: event.shrinkItem.boardId);
    final currentShrinkItemTaskItemIndex = listState.getTaskItemIndex(
      boardId: event.shrinkItem.boardId,
      taskItemId: event.shrinkItem.taskItemId,
    );

    // Shrink Itemを追加する対象のBoard
    final boardIndex =
        (state as BoardListState).getBoardIndex(boardId: event.boardId);
    _logger.d("===BoardDeleteAndAddShrinkItem===");
    _logger.d(
      "boardId: ${event.boardId}, shrinkItem.boardId: ${event.shrinkItem.boardId}, insertingIndex: ${event.insertingIndex}",
    );
    if (boardIndex == -1) return;
    final targetBoard = targetList[boardIndex];
    final targetShrinkItemPosition = {...listState.shrinkItemPosition};

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

    // TODO: position mapに別ボードに残っているshrink itemがないため、削除できない
    // TODO: 一度ページ移動して戻ると、別ボードの要素が消されていく。
    // TODO: ページ移動が早い
    //→リビルトされて detailsの値が更新。board id 1の時450px、2の時更新されて110px
    //ビルドさせないとだめ。

    targetShrinkItemPosition[listState.getBoardIndex(boardId: event.boardId)] =
        event.insertingIndex;

    //同じワークボード内で移動した場合、それぞれのindexで削除対象を判定
    if (currentShrinkItemBoardIndex != -1 &&
        currentShrinkItemTaskItemIndex != -1 &&
        targetBoard.taskItemList.isNotEmpty) {
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
    }

    // print("削除前のtargetShrinkItemPosition: $targetShrinkItemPosition");
    _logger.d("削除前のtargetShrinkItemPosition: $targetShrinkItemPosition");
    // 別ボード内に残っているShrink itemを削除
    for (final item in {...targetShrinkItemPosition}.entries) {
      if (targetList[item.key].boardId != event.shrinkItem.boardId) {
        final shrinkItemIndex = targetList[item.key]
            .taskItemList
            .indexWhere((element) => element.taskItemId == kShrinkId);
        if (shrinkItemIndex == -1) continue;
        targetList[item.key].taskItemList.removeAt(shrinkItemIndex);
        targetShrinkItemPosition.remove(item.key);
      }
    }
    _logger.d("削除後のtargetShrinkItemPosition: $targetShrinkItemPosition");

    emit(listState.copyWith(
      boardList: targetList,
      shrinkItemPosition: targetShrinkItemPosition,
    ));
  }

  // Drag completed
  Future<void> _onReplaceDraggedItem(
      BoardCompleteDraggedItem event, Emitter<BoardState> emit) async {
    _logger.d("===BoardCompleteDraggedItem===");

    if (!isListState()) return;
    final listState = (state as BoardListState);
    final targetList = [...listState.boardList];
    final boardIndex =
        listState.getBoardIndex(boardId: event.shrinkItem.boardId);

    final boardItemIndex = listState.getTaskItemIndex(
      boardId: event.shrinkItem.boardId,
      taskItemId: event.shrinkItem.taskItemId,
    );
    // drag完了時に別ボードカード内にshrink itemがある場合
    if (boardItemIndex == -1) {
      final targetBoardId = listState.boardIdOfHavingShrinkItem;
      if (targetBoardId == null) return;
      final targetBoardIdIndex =
          listState.getBoardIndex(boardId: targetBoardId);
      final dragItem = event.draggingItem.copyWith(
        boardId: targetList[targetBoardIdIndex].boardId,
      );
      final shrinkItemIndex = listState.getTaskItemIndex(
          boardId: targetBoardId, taskItemId: event.shrinkItem.taskItemId);
      if (shrinkItemIndex == -1) return;
      targetList[targetBoardIdIndex].taskItemList[shrinkItemIndex] = dragItem;
    } else {
      targetList[boardIndex].taskItemList[boardItemIndex] = event.draggingItem;
    }

    emit(BoardListState(boardList: targetList, shrinkItemPosition: const {}));
  }

  Map<int, int>? getShrinkItemPosition(
      {required int boardIdIndex, required int taskItemIndex}) {
    if (!isListState()) return null;
    final Map<int, int> targetMap = {};
    targetMap[boardIdIndex] = taskItemIndex;
    return targetMap;
  }

  bool isListState() {
    return state is BoardListState;
  }
}
