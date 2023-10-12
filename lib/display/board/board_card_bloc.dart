import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import '../../model/model.dart';
import '../board/drag_item_bloc.dart';

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

/// Replace dragging item to shrink item.
class BoardCardReplaceShrinkItem extends BoardCardEvent {
  const BoardCardReplaceShrinkItem({
    required this.boardId,
    required this.taskItemId,
    required this.shrinkItem,
  });
  final String boardId;
  final String taskItemId;
  final TaskItemInfo shrinkItem;
}

/// Delete and Add shrink item when item is dragging.
class BoardCardDeleteAndAddShrinkItem extends BoardCardEvent {
  const BoardCardDeleteAndAddShrinkItem({
    required this.boardId,
    required this.insertingIndex,
    required this.shrinkItem,
  });

  final String boardId;
  final int insertingIndex;
  final TaskItemInfo shrinkItem;
}

/// Delete shrink item when item is dragging to other board.
class BoardCardDeleteShrinkItem extends BoardCardEvent {
  const BoardCardDeleteShrinkItem();
}

/// Complete dragging.
class BoardCardCompleteDraggedItem extends BoardCardEvent {
  const BoardCardCompleteDraggedItem({required this.draggingItem});
  final TaskItemInfo draggingItem;
}

class BoardCardSetIsAddingNewTask extends BoardCardEvent {
  const BoardCardSetIsAddingNewTask({required this.isAddedNewTask});
  final bool isAddedNewTask;
}

// State
@immutable
class BoardCardState extends Equatable {
  const BoardCardState({
    required this.projectId,
    required this.boardId,
    required this.title,
    required this.taskItemList,
    required this.isAddedNewTask,
    required this.scrollController,
  });

  final String projectId;
  final String boardId;
  final String title;
  final List<TaskItemInfo> taskItemList;
  final bool isAddedNewTask;
  final ScrollController scrollController;

  @override
  List<Object?> get props => [
        projectId,
        boardId,
        title,
        taskItemList,
        isAddedNewTask,
        scrollController,
      ];

  BoardCardState copyWith({
    String? projectId,
    String? boardId,
    String? title,
    List<TaskItemInfo>? taskItemList,
    bool? isAddedNewTask,
    ScrollController? scrollController,
  }) =>
      BoardCardState(
        projectId: projectId ?? this.projectId,
        boardId: boardId ?? this.boardId,
        title: title ?? this.title,
        taskItemList: taskItemList ?? this.taskItemList,
        isAddedNewTask: isAddedNewTask ?? this.isAddedNewTask,
        scrollController: scrollController ?? this.scrollController,
      );

  ///Check shrink item is included in target work board card list.
  bool get hasShrinkItem {
    return hasTaskItem(kShrinkId);
  }

  ///Check task item is included in target work board card list.
  bool hasTaskItem(String taskItemId) {
    return taskItemList
            .firstWhereOrNull((element) => element.taskItemId == taskItemId) !=
        null;
  }

  ///Get task item in target work board card list.
  TaskItemInfo? getTaskItem(String taskItemId) {
    return taskItemList
        .firstWhereOrNull((element) => element.taskItemId == taskItemId);
  }

  ///Get task item index in target work board card list.
  int getTaskItemIndex(String taskItemId) {
    return taskItemList
        .indexWhere((element) => element.taskItemId == taskItemId);
  }
}

// Bloc
class BoardCardBloc extends Bloc<BoardCardEvent, BoardCardState> {
  BoardCardBloc({
    required String projectId,
    required String boardId,
    required String title,
    required List<TaskItemInfo> taskItemList,
  }) : super(
          BoardCardState(
            projectId: projectId,
            boardId: boardId,
            title: title,
            taskItemList: taskItemList,
            isAddedNewTask: false,
            scrollController: ScrollController(),
          ),
        ) {
    on<_Init>(_onInit);
    on<BoardCardGetList>(_onGetList);
    on<BoardCardUpdate>(_onUpdateCard);
    on<BoardCardTapListItem>(_onTapListItem);
    on<BoardCardAddTaskItem>(_onAddTaskItem);
    on<BoardCardUpdateTaskItem>(_onUpdateTaskItem);
    on<BoardCardDeleteTaskItem>(_onDeleteTaskItem);
    on<BoardCardReplaceShrinkItem>(_onReplaceShrinkItem);
    on<BoardCardDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
    on<BoardCardDeleteShrinkItem>(_onDeleteShrinkItem);
    on<BoardCardCompleteDraggedItem>(_onReplaceDraggedItem);
    on<BoardCardSetIsAddingNewTask>(_onSetIsAddingNewTask);
  }

  void _onInit(_Init event, Emitter<BoardCardState> emit) {
    emit(
      BoardCardState(
        projectId: '',
        boardId: '',
        title: '',
        taskItemList: const [],
        isAddedNewTask: false,
        scrollController: ScrollController(),
      ),
    );
  }

  Future<void> _onGetList(
      BoardCardGetList event, Emitter<BoardCardState> emit) async {
    emit(
      BoardCardState(
        projectId: event.projectId,
        boardId: event.boardId,
        title: event.title,
        taskItemList: event.taskItemList,
        isAddedNewTask: false,
        scrollController: ScrollController(),
      ),
    );
  }

  void _onUpdateCard(BoardCardUpdate event, Emitter<BoardCardState> emit) {}

  Future<void> _onTapListItem(
      BoardCardTapListItem event, Emitter<BoardCardState> emit) async {}

  Future<void> _onAddTaskItem(
      BoardCardAddTaskItem event, Emitter<BoardCardState> emit) async {
    final emitTaskItemList = [...state.taskItemList];

    emitTaskItemList.add(
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
      state.copyWith(taskItemList: emitTaskItemList),
    );
  }

  Future<void> _onUpdateTaskItem(
      BoardCardUpdateTaskItem event, Emitter<BoardCardState> emit) async {
    final emitTaskItemList = [...state.taskItemList];
    final targetTaskItemIndex = state.getTaskItemIndex(event.taskItemId);

    final replaceTaskItem = TaskItemInfo(
      boardId: event.boardId,
      taskItemId: event.taskItemId,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.dueDate,
      labelList: event.labelList,
    );

    emitTaskItemList.replaceRange(
        targetTaskItemIndex, targetTaskItemIndex + 1, [replaceTaskItem]);

    emit(
      state.copyWith(taskItemList: emitTaskItemList),
    );
  }

  Future<void> _onDeleteTaskItem(
      BoardCardDeleteTaskItem event, Emitter<BoardCardState> emit) async {
    final emitTaskItemList = [...state.taskItemList];

    final targetTaskItemIndex = state.getTaskItemIndex(event.taskItemId);

    emitTaskItemList.removeAt(targetTaskItemIndex);
    emit(state.copyWith(taskItemList: emitTaskItemList));
  }

  // Drag時、対象要素をShrink Itemに置き換える
  Future<void> _onReplaceShrinkItem(
      BoardCardReplaceShrinkItem event, Emitter<BoardCardState> emit) async {
    if (!state.hasTaskItem(event.taskItemId)) return;
    final emitTaskItemList = [...state.taskItemList];
    final targetTaskItemIndex = state.getTaskItemIndex(event.taskItemId);

    emitTaskItemList[targetTaskItemIndex] = event.shrinkItem;
    emit(state.copyWith(taskItemList: emitTaskItemList));
  }

  Future<void> _onDeleteAndAddShrinkItem(BoardCardDeleteAndAddShrinkItem event,
      Emitter<BoardCardState> emit) async {
    final emitTaskItemList = [...state.taskItemList];
    // Task Item Listが空の場合
    if (emitTaskItemList.isEmpty) {
      emitTaskItemList.add(event.shrinkItem);
      // 他ボードからドラッグされたため、後続処理不要
    } else if (!state.hasShrinkItem) {
      emitTaskItemList.insert(event.insertingIndex, event.shrinkItem);
    } else {
      final currentShrinkItemIndex =
          state.getTaskItemIndex(event.shrinkItem.taskItemId);

      if (currentShrinkItemIndex == -1) return;
      // Shrink Item追加
      emitTaskItemList.insert(event.insertingIndex, event.shrinkItem);

      //indexですでに存在していたShrink itemを削除対象を判定
      emitTaskItemList.removeAt(currentShrinkItemIndex < event.insertingIndex
          ? currentShrinkItemIndex
          : currentShrinkItemIndex + 1);
    }
    emit(state.copyWith(taskItemList: emitTaskItemList));
  }

  //Shrink Item削除時、他Cardに移動しているため、Dragging Itemも初期化
  Future<void> _onDeleteShrinkItem(
      BoardCardDeleteShrinkItem event, Emitter<BoardCardState> emit) async {
    if (!state.hasShrinkItem) return;
    final emitTaskItemList = [...state.taskItemList];
    final currentShrinkItemIndex = state.getTaskItemIndex(kShrinkId);

    //indexで削除対象を判定
    emitTaskItemList.removeAt(currentShrinkItemIndex);

    emit(state.copyWith(taskItemList: emitTaskItemList));
  }

  /// Drag完了
  Future<void> _onReplaceDraggedItem(
      BoardCardCompleteDraggedItem event, Emitter<BoardCardState> emit) async {
    if (!state.hasShrinkItem) return;
    final emitTaskItemList = [...state.taskItemList];
    final targetTaskItemIndex = state.getTaskItemIndex(kShrinkId);

    emitTaskItemList[targetTaskItemIndex] = event.draggingItem;

    emit(state.copyWith(taskItemList: emitTaskItemList));
  }

  Future<void> _onSetIsAddingNewTask(
      BoardCardSetIsAddingNewTask event, Emitter<BoardCardState> emit) async {
    emit(state.copyWith(isAddedNewTask: event.isAddedNewTask));
  }
}
