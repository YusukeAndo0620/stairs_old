import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';
import '../../model/model.dart';

const kShrinkId = 'shrinkId';

// Event
abstract class DragItemEvent {
  const DragItemEvent();
}

/// Init drag. shrink item and dragging item is initialized.
class _Init extends DragItemEvent {
  const _Init();
}

/// Set Moving ready.
class DragItemSetReadyMoving extends DragItemEvent {
  const DragItemSetReadyMoving();
}

/// Set Moving not ready.
class DragItemSetDisableMoving extends DragItemEvent {
  const DragItemSetDisableMoving();
}

/// Set Dragging item.
class DragItemSetItem extends DragItemEvent {
  const DragItemSetItem({
    required this.boardId,
    required this.draggingItem,
  });
  final String boardId;
  final TaskItemInfo draggingItem;
}

/// Change Task item when dragging to another board.
class DragItemChangeTaskItem extends DragItemEvent {
  const DragItemChangeTaskItem({
    required this.boardId,
  });
  final String boardId;
}

/// Complete dragging.
class DragItemComplete extends DragItemEvent {
  const DragItemComplete();
}

// State
@immutable
abstract class DragItemState extends Equatable {
  const DragItemState();

  @override
  List<Object?> get props => [];
}

//Initial
class DragItemInitialState extends DragItemState {
  const DragItemInitialState();

  @override
  List<Object?> get props => [];
}

class DragItemDraggingState extends DragItemState {
  const DragItemDraggingState({
    required this.isReady,
    required this.boardId,
    required this.draggingItem,
    required this.shrinkItem,
  });

  final bool isReady;
  final String boardId;
  final TaskItemInfo draggingItem;
  final TaskItemInfo shrinkItem;

  @override
  List<Object?> get props => [
        isReady,
        boardId,
        draggingItem,
        shrinkItem,
      ];

  DragItemDraggingState copyWith({
    bool? isReady,
    String? boardId,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      DragItemDraggingState(
        isReady: isReady ?? this.isReady,
        boardId: boardId ?? this.boardId,
        draggingItem: draggingItem ?? this.draggingItem,
        shrinkItem: shrinkItem ?? this.shrinkItem,
      );
}

// Bloc
class DragItemBloc extends Bloc<DragItemEvent, DragItemState> {
  DragItemBloc()
      : super(
          const DragItemInitialState(),
        ) {
    on<_Init>(_onInit);
    on<DragItemSetReadyMoving>(_onSetReadyMoving);
    on<DragItemSetDisableMoving>(_onSetDisableMoving);
    on<DragItemSetItem>(_onSetItem);
    on<DragItemChangeTaskItem>(_onChangeTaskItem);
    on<DragItemComplete>(_onComplete);
    add(const _Init());
  }

  void _onInit(_Init event, Emitter<DragItemState> emit) {
    emit(const DragItemInitialState());
  }

  Future<void> _onSetReadyMoving(
      DragItemSetReadyMoving event, Emitter<DragItemState> emit) async {
    if (state is! DragItemDraggingState) return;
    final draggingState = state as DragItemDraggingState;

    emit(
      draggingState.copyWith(isReady: true),
    );
  }

  Future<void> _onSetDisableMoving(
      DragItemSetDisableMoving event, Emitter<DragItemState> emit) async {
    if (state is! DragItemDraggingState) return;
    final draggingState = state as DragItemDraggingState;

    emit(
      draggingState.copyWith(isReady: false),
    );
  }

  Future<void> _onSetItem(
      DragItemSetItem event, Emitter<DragItemState> emit) async {
    emit(
      DragItemDraggingState(
        isReady: true,
        boardId: event.boardId,
        draggingItem: event.draggingItem,
        shrinkItem: getShrinkItem(
          boardId: event.boardId,
        ),
      ),
    );
  }

  Future<void> _onChangeTaskItem(
      DragItemChangeTaskItem event, Emitter<DragItemState> emit) async {
    if (state is! DragItemDraggingState) return;
    final draggingState = state as DragItemDraggingState;
    // 他ボードからドラッグされたことを考慮し、board idを更新
    final targetDragItem = TaskItemInfo(
      boardId: event.boardId,
      taskItemId: draggingState.draggingItem.taskItemId,
      title: draggingState.draggingItem.title,
      description: draggingState.draggingItem.description,
      startDate: draggingState.draggingItem.startDate,
      endDate: draggingState.draggingItem.endDate,
      labelList: draggingState.draggingItem.labelList,
    );

    emit(
      draggingState.copyWith(
        boardId: event.boardId,
        draggingItem: targetDragItem,
        shrinkItem: getShrinkItem(
          boardId: event.boardId,
        ),
      ),
    );
  }

  Future<void> _onComplete(
      DragItemComplete event, Emitter<DragItemState> emit) async {
    add(const _Init());
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
