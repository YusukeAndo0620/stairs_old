import 'package:stairs/loom/loom_package.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

// Event
abstract class BoardEvent {
  const BoardEvent();
}

class _Init extends BoardEvent {
  const _Init();
}

class BoardSetList extends BoardEvent {
  const BoardSetList({required this.projectId});
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

  final List<BoardBaseInfo> boardList;

  @override
  List<Object?> get props => [
        boardList,
      ];

  BoardListState copyWith({
    List<BoardBaseInfo>? boardList,
  }) =>
      BoardListState(
        boardList: boardList ?? this.boardList,
      );
}

// Bloc
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc()
      : super(
          const BoardInitialState(),
        ) {
    on<_Init>(_onInit);
    on<BoardSetList>(_onSetList);
    on<BoardAddCard>(_onAddCard);
  }

  void _onInit(_Init event, Emitter<BoardState> emit) {
    emit(const BoardListState(boardList: []));
  }

  Future<void> _onSetList(BoardSetList event, Emitter<BoardState> emit) async {
    emit(BoardListState(boardList: dummyBoardList));
  }

  Future<void> _onAddCard(BoardAddCard event, Emitter<BoardState> emit) async {
    final emitList = [
      ...(state as BoardListState).boardList,
    ];

    emitList.add(
      BoardBaseInfo(
        projectId: event.projectId,
        boardId: uuid.v4(),
        title: event.title,
      ),
    );
    emit((state as BoardListState).copyWith(boardList: emitList));
  }

  List<BoardInfo> getList({required String projectId}) {
    return dummyBoardList;
  }
}
