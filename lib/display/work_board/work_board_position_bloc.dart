import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';

class PositionInfo {
  PositionInfo({
    required this.height,
    required this.width,
    required this.dx,
    required this.dy,
  });

  final double height;
  final double width;
  final double dx;
  final double dy;
}

// Event
abstract class WorkBoardPositionBlocEvent {
  const WorkBoardPositionBlocEvent();
}

class WorkBoardPositionInit extends WorkBoardPositionBlocEvent {
  const WorkBoardPositionInit({
    required this.boardId,
  });

  final String boardId;
}

/// Set WorkBoard card position
class WorkBoardSetCardPosition extends WorkBoardPositionBlocEvent {
  const WorkBoardSetCardPosition({
    required this.workBoardId,
    required this.key,
  });
  final String workBoardId;
  final GlobalKey key;
}

/// Set WorkBoard card item position
class WorkBoardSetCardItemPosition extends WorkBoardPositionBlocEvent {
  const WorkBoardSetCardItemPosition({
    required this.taskItemId,
    required this.key,
  });
  final String taskItemId;
  final GlobalKey key;
}

// State
@immutable
class WorkBoardPositionBlocState extends Equatable {
  const WorkBoardPositionBlocState({
    required this.boardId,
    required this.workBoardPositionMap,
    required this.workBoardItemPositionMap,
  });

  final String boardId;

  /// key: workBoardId
  final Map<String, PositionInfo> workBoardPositionMap;

  /// key: taskItemId
  final Map<String, PositionInfo> workBoardItemPositionMap;

  @override
  List<Object?> get props => [
        boardId,
        workBoardPositionMap,
        workBoardItemPositionMap,
      ];

  WorkBoardPositionBlocState copyWith({
    String? boardId,
    Map<String, PositionInfo>? workBoardPositionMap,
    Map<String, PositionInfo>? workBoardItemPositionMap,
  }) =>
      WorkBoardPositionBlocState(
        boardId: boardId ?? this.boardId,
        workBoardPositionMap: workBoardPositionMap ?? this.workBoardPositionMap,
        workBoardItemPositionMap:
            workBoardItemPositionMap ?? this.workBoardItemPositionMap,
      );
}

// Bloc
class WorkBoardPositionBloc
    extends Bloc<WorkBoardPositionBlocEvent, WorkBoardPositionBlocState> {
  WorkBoardPositionBloc()
      : super(
          const WorkBoardPositionBlocState(
            boardId: '',
            workBoardPositionMap: {},
            workBoardItemPositionMap: {},
          ),
        ) {
    on<WorkBoardPositionInit>(_onInit);
    on<WorkBoardSetCardPosition>(_onSetCardPosition);
    on<WorkBoardSetCardItemPosition>(_onSetCardItemPosition);
  }

  void _onInit(
      WorkBoardPositionInit event, Emitter<WorkBoardPositionBlocState> emit) {
    emit(state.copyWith(
        boardId: event.boardId,
        workBoardPositionMap: {},
        workBoardItemPositionMap: {}));
  }

  void _onSetCardPosition(WorkBoardSetCardPosition event,
      Emitter<WorkBoardPositionBlocState> emit) {
    if (event.key.currentContext == null) return;
    final position = event.key.currentContext!.findRenderObject() as RenderBox;
    final targetMap = state.workBoardPositionMap;
    final positionInfo = PositionInfo(
      height: event.key.currentContext!.size!.height,
      width: event.key.currentContext!.size!.width,
      dx: position.localToGlobal(Offset.zero).dx,
      dy: position.localToGlobal(Offset.zero).dy,
    );

    if (targetMap.containsKey(event.workBoardId)) {
      targetMap[event.workBoardId] = positionInfo;
    } else {
      targetMap.addAll(
        {event.workBoardId: positionInfo},
      );
    }
    emit(state.copyWith(workBoardPositionMap: targetMap));
  }

  void _onSetCardItemPosition(WorkBoardSetCardItemPosition event,
      Emitter<WorkBoardPositionBlocState> emit) {
    if (event.key.currentContext == null) return;
    final position = event.key.currentContext!.findRenderObject() as RenderBox;
    final targetMap = state.workBoardItemPositionMap;
    final positionInfo = PositionInfo(
      height: event.key.currentContext!.size!.height,
      width: event.key.currentContext!.size!.width,
      dx: position.localToGlobal(Offset.zero).dx,
      dy: position.localToGlobal(Offset.zero).dy,
    );

    if (targetMap.containsKey(event.taskItemId)) {
      targetMap[event.taskItemId] = positionInfo;
    } else {
      targetMap.addAll(
        {event.taskItemId: positionInfo},
      );
    }
    emit(state.copyWith(workBoardItemPositionMap: targetMap));
  }
}
