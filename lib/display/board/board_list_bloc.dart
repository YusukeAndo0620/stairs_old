import 'package:stairs/loom/loom_package.dart';
import 'package:equatable/equatable.dart';
import 'screen/board_edit_modal.dart';
import '../../loom/loom_theme_data.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

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
          const BoardListBlocState(boardList: []),
        ) {
    on<_Init>(_onInit);
    on<BoardGetList>(_onGetList);
    on<BoardTapEdit>(_onTapEdit);
    on<BoardTapDelete>(_onTapDelete);
  }

  void _onInit(_Init event, Emitter<BoardListBlocState> emit) {
    emit(const BoardListBlocState(boardList: []));
  }

  Future<void> _onGetList(
      BoardGetList event, Emitter<BoardListBlocState> emit) async {
    emit(BoardListBlocState(boardList: dummyBoardList));
  }

  void _onTapEdit(BoardTapEdit event, Emitter<BoardListBlocState> emit) {
    showModalBottomSheet(
        context: event.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BoardEditModal(boardId: event.boardId);
        });
  }

  Future<void> _onTapDelete(
      BoardTapDelete event, Emitter<BoardListBlocState> emit) async {}
}
