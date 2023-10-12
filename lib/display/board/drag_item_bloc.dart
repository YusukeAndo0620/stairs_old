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
    required this.boardId,
    required this.draggingItem,
    required this.shrinkItem,
  });

  final String boardId;
  final TaskItemInfo draggingItem;
  final TaskItemInfo shrinkItem;

  @override
  List<Object?> get props => [
        boardId,
        draggingItem,
        shrinkItem,
      ];

  DragItemDraggingState copyWith({
    String? boardId,
    TaskItemInfo? draggingItem,
    TaskItemInfo? shrinkItem,
  }) =>
      DragItemDraggingState(
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
    on<DragItemSetItem>(_onSetItem);
    on<DragItemChangeTaskItem>(_onChangeTaskItem);
    on<DragItemComplete>(_onComplete);
    add(const _Init());
  }

  void _onInit(_Init event, Emitter<DragItemState> emit) {
    emit(const DragItemInitialState());
  }

  Future<void> _onSetItem(
      DragItemSetItem event, Emitter<DragItemState> emit) async {
    emit(
      DragItemDraggingState(
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
    final draggingState = state as DragItemDraggingState;
    // 他ボードからドラッグされたことを考慮し、board idを更新
    final targetDragItem = TaskItemInfo(
      boardId: event.boardId,
      taskItemId: draggingState.draggingItem!.taskItemId,
      title: draggingState.draggingItem!.title,
      description: draggingState.draggingItem!.description,
      startDate: draggingState.draggingItem!.startDate,
      endDate: draggingState.draggingItem!.endDate,
      labelList: draggingState.draggingItem!.labelList,
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
