import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../board/screens/board_modal.dart';
import '../loom/loom_theme_data.dart';

// TODO: Delete
class BoardListItemInfo {
  BoardListItemInfo({
    required this.boardId,
    required this.projectName,
    required this.themeColor,
  });

  final String boardId;
  final String projectName;
  final String themeColor;
}

// Event
abstract class BoardListBlocEvent {
  const BoardListBlocEvent();
}

class _Init extends BoardListBlocEvent {
  const _Init();
}

class BoardGetList extends BoardListBlocEvent {
  const BoardGetList();
}

class BoardTapListItem extends BoardListBlocEvent {
  const BoardTapListItem({required this.boardId});

  final String boardId;
}

class BoardTapCreate extends BoardListBlocEvent {
  const BoardTapCreate({
    required this.context,
    required this.theme,
  });

  final BuildContext context;
  final LoomThemeData theme;
}

class BoardTapEdit extends BoardListBlocEvent {
  const BoardTapEdit({
    required this.boardId,
    required this.context,
    required this.theme,
  });

  final String boardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class BoardTapDelete extends BoardListBlocEvent {
  const BoardTapDelete();
}

// State
@immutable
class BoardListBlocState extends Equatable {
  const BoardListBlocState({required this.boardList});

  final List<BoardListItemInfo> boardList;

  @override
  List<Object?> get props => [boardList];
}

// Bloc
class BoardListBloc extends Bloc<BoardListBlocEvent, BoardListBlocState> {
  BoardListBloc()
      : super(
          BoardListBlocState(
            boardList: List.generate(
              20,
              (index) => BoardListItemInfo(
                  boardId: index.toString(),
                  projectName: 'title_$index',
                  themeColor: ""),
            ),
          ),
        ) {
    on<_Init>(_onInit);
    on<BoardGetList>(_onGetList);
    on<BoardTapListItem>(_onTapListItem);
    on<BoardTapCreate>(_onTapCreate);
    on<BoardTapEdit>(_onTapEdit);
    on<BoardTapDelete>(_onTapDelete);
  }

  void _onInit(_Init event, Emitter<BoardListBlocState> emit) {
    emit(const BoardListBlocState(boardList: []));
  }

  Future<void> _onGetList(
      BoardGetList event, Emitter<BoardListBlocState> emit) async {}

  Future<void> _onTapListItem(
      BoardTapListItem event, Emitter<BoardListBlocState> emit) async {}

  Future<void> _onTapCreate(
      BoardTapCreate event, Emitter<BoardListBlocState> emit) async {
    showModalBottomSheet(
        context: event.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const BoardModal();
        });
  }

  void _onTapEdit(BoardTapEdit event, Emitter<BoardListBlocState> emit) {
    showModalBottomSheet(
        context: event.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BoardModal(boardId: event.boardId);
        });
  }

  Future<void> _onTapDelete(
      BoardTapDelete event, Emitter<BoardListBlocState> emit) async {}
}