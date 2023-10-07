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
abstract class BoardPositionBlocEvent {
  const BoardPositionBlocEvent();
}

class BoardPositionInit extends BoardPositionBlocEvent {
  const BoardPositionInit({
    required this.projectId,
  });

  final String projectId;
}

/// Set Board card position
class BoardSetCardPosition extends BoardPositionBlocEvent {
  const BoardSetCardPosition({
    required this.boardId,
    required this.key,
  });
  final String boardId;
  final GlobalKey key;
}

/// Set Board card item position
class BoardSetCardItemPosition extends BoardPositionBlocEvent {
  const BoardSetCardItemPosition({
    required this.taskItemId,
    required this.key,
  });
  final String taskItemId;
  final GlobalKey key;
}

// State
@immutable
class BoardPositionBlocState extends Equatable {
  const BoardPositionBlocState({
    required this.projectId,
    required this.boardPositionMap,
    required this.boardItemPositionMap,
  });

  final String projectId;

  /// key: boardId
  final Map<String, PositionInfo> boardPositionMap;

  /// key: taskItemId
  final Map<String, PositionInfo> boardItemPositionMap;

  @override
  List<Object?> get props => [
        projectId,
        boardPositionMap,
        boardItemPositionMap,
      ];

  BoardPositionBlocState copyWith({
    String? projectId,
    Map<String, PositionInfo>? boardPositionMap,
    Map<String, PositionInfo>? boardItemPositionMap,
  }) =>
      BoardPositionBlocState(
        projectId: projectId ?? this.projectId,
        boardPositionMap: boardPositionMap ?? this.boardPositionMap,
        boardItemPositionMap: boardItemPositionMap ?? this.boardItemPositionMap,
      );
}

// Bloc
class BoardPositionBloc
    extends Bloc<BoardPositionBlocEvent, BoardPositionBlocState> {
  BoardPositionBloc()
      : super(
          const BoardPositionBlocState(
            projectId: '',
            boardPositionMap: {},
            boardItemPositionMap: {},
          ),
        ) {
    on<BoardPositionInit>(_onInit);
    on<BoardSetCardPosition>(_onSetCardPosition);
    on<BoardSetCardItemPosition>(_onSetCardItemPosition);
  }

  void _onInit(BoardPositionInit event, Emitter<BoardPositionBlocState> emit) {
    emit(state.copyWith(
        projectId: event.projectId,
        boardPositionMap: {},
        boardItemPositionMap: {}));
  }

  void _onSetCardPosition(
      BoardSetCardPosition event, Emitter<BoardPositionBlocState> emit) {
    if (event.key.currentContext == null) return;
    final position = event.key.currentContext!.findRenderObject() as RenderBox;
    final targetMap = state.boardPositionMap;
    final positionInfo = PositionInfo(
      height: event.key.currentContext!.size!.height,
      width: event.key.currentContext!.size!.width,
      dx: position.localToGlobal(Offset.zero).dx,
      dy: position.localToGlobal(Offset.zero).dy,
    );

    if (targetMap.containsKey(event.boardId)) {
      targetMap[event.boardId] = positionInfo;
    } else {
      targetMap.addAll(
        {event.boardId: positionInfo},
      );
    }
    emit(state.copyWith(boardPositionMap: targetMap));
  }

  void _onSetCardItemPosition(
      BoardSetCardItemPosition event, Emitter<BoardPositionBlocState> emit) {
    if (event.key.currentContext == null) return;
    final position = event.key.currentContext!.findRenderObject() as RenderBox;
    final targetMap = state.boardItemPositionMap;
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
    emit(state.copyWith(boardItemPositionMap: targetMap));
  }
}
