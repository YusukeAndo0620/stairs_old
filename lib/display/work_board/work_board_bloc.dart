import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../board/screens/board_modal.dart';
import '../../loom/loom_theme_data.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

// Event
abstract class WorkBoardBlocEvent {
  const WorkBoardBlocEvent();
}

class _Init extends WorkBoardBlocEvent {
  const _Init();
}

class WorkBoardGetList extends WorkBoardBlocEvent {
  const WorkBoardGetList({required this.boardId});
  final String boardId;
}

class WorkBoardTapListItem extends WorkBoardBlocEvent {
  const WorkBoardTapListItem({required this.workBoardItemId});

  final String workBoardItemId;
}

class WorkBoardTapEdit extends WorkBoardBlocEvent {
  const WorkBoardTapEdit({
    required this.workBoardId,
    required this.context,
    required this.theme,
  });

  final String workBoardId;
  final BuildContext context;
  final LoomThemeData theme;
}

class WorkBoardTapDelete extends WorkBoardBlocEvent {
  const WorkBoardTapDelete();
}

// State
@immutable
class WorkBoardBlocState extends Equatable {
  const WorkBoardBlocState({required this.workBoardList});

  final List<WorkBoard> workBoardList;

  @override
  List<Object?> get props => [workBoardList];
}

// Bloc
class WorkBoardBloc extends Bloc<WorkBoardBlocEvent, WorkBoardBlocState> {
  WorkBoardBloc()
      : super(
          const WorkBoardBlocState(workBoardList: []),
        ) {
    on<_Init>(_onInit);
    on<WorkBoardGetList>(_onGetList);
    on<WorkBoardTapListItem>(_onTapListItem);
    on<WorkBoardTapEdit>(_onTapEdit);
    on<WorkBoardTapDelete>(_onTapDelete);
  }

  void _onInit(_Init event, Emitter<WorkBoardBlocState> emit) {
    emit(const WorkBoardBlocState(workBoardList: []));
  }

  Future<void> _onGetList(
      WorkBoardGetList event, Emitter<WorkBoardBlocState> emit) async {
    emit(WorkBoardBlocState(workBoardList: dummyWorkBoardList));
  }

  Future<void> _onTapListItem(
      WorkBoardTapListItem event, Emitter<WorkBoardBlocState> emit) async {}

  void _onTapEdit(WorkBoardTapEdit event, Emitter<WorkBoardBlocState> emit) {
    // showModalBottomSheet(
    //   context: event.context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) {
    //     return BoardModal(boardId: event.boardId);
    //   },
    // );
  }

  Future<void> _onTapDelete(
      WorkBoardTapDelete event, Emitter<WorkBoardBlocState> emit) async {}
}
