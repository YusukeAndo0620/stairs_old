import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/model.dart';

final initialState = BoardDetailBlocState(
  boardId: '',
  projectName: '',
  themeColor: Color.fromARGB(255, 10, 241, 161),
  industry: '',
  startDate: '',
  endDate: '',
  devLanguageList: List.generate(
    10,
    (index) => LinkTagInfo(
      id: index,
      inputValue: 'java_$index',
      linkLabel: List.generate(
        4,
        (labelIndex) => LabelInfo(
          id: labelIndex,
          labelName: labelIndex.isEven
              ? '$index 画面設計_$labelIndex'
              : '$index API設計書修正対応',
          themeColor: labelIndex.isEven ? Colors.blue : Colors.purple,
        ),
      ),
    ),
  ),
);

// Event
abstract class BoardDetailBlocEvent {
  const BoardDetailBlocEvent();
}

//Init
class Init extends BoardDetailBlocEvent {
  const Init();
}

// Get detail info
class BoardGetDetail extends BoardDetailBlocEvent {
  const BoardGetDetail({required this.boardId});

  final String boardId;
}

// Request of creating board
class BoardCreate extends BoardDetailBlocEvent {}

// Request of editing board
class BoarEdit extends BoardDetailBlocEvent {
  const BoarEdit({required this.boardId});

  final String boardId;
}

/// State change event
// Change project name and set state
class BoardChangeProjectName extends BoardDetailBlocEvent {
  const BoardChangeProjectName({required this.projectName});

  final String projectName;
}

// Change theme color and set state
class BoardChangThemeColor extends BoardDetailBlocEvent {
  const BoardChangThemeColor({required this.themeColor});

  final Color themeColor;
}

// Change industry and set state
class BoardChangIndustry extends BoardDetailBlocEvent {
  const BoardChangIndustry({required this.industry});

  final String industry;
}

// Change due date and set state
class BoardChangeDueDate extends BoardDetailBlocEvent {
  const BoardChangeDueDate({required this.startDate, required this.endDate});

  final String startDate;
  final String endDate;
}

// Change description and set state
class BoardChangDescription extends BoardDetailBlocEvent {
  const BoardChangDescription({required this.description});

  final String description;
}

// Change os and set state
class BoardChangeOs extends BoardDetailBlocEvent {
  const BoardChangeOs({required this.os});

  final String os;
}

// Change db and set state
class BoardChangeDb extends BoardDetailBlocEvent {
  const BoardChangeDb({required this.db});

  final String db;
}

// Change development language and set state
class BoardChangDevLanguageList extends BoardDetailBlocEvent {
  const BoardChangDevLanguageList({required this.devLanguageList});

  final List<LinkTagInfo> devLanguageList;
}

// Change toolList and set state
class BoardChangeToolList extends BoardDetailBlocEvent {
  const BoardChangeToolList({required this.toolList});

  final List<LabelInfo> toolList;
}

// Change development Progress and set state
class BoardChangeDevProgress extends BoardDetailBlocEvent {
  const BoardChangeDevProgress({required this.devProgress});

  final String devProgress;
}

// Change development Size and set state
class BoardChangeDevSize extends BoardDetailBlocEvent {
  const BoardChangeDevSize({required this.devSize});

  final String devSize;
}

// Change label and set state
class BoardChangeTagList extends BoardDetailBlocEvent {
  const BoardChangeTagList({required this.tagList});

  final List<LabelInfo> tagList;
}

// State
@immutable
class BoardDetailBlocState extends Equatable {
  const BoardDetailBlocState({
    required this.boardId,
    required this.projectName,
    required this.themeColor,
    required this.industry,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.os = '',
    this.db = '',
    this.devLanguageList = const [],
    this.toolList = const [],
    this.devProgress = '',
    this.devSize = '',
    this.tagList = const [],
  });

  final String boardId;
  final String projectName;
  final Color themeColor;
  final String industry;
  final String startDate;
  final String endDate;
  final String description;
  final String os;
  final String db;
  final List<LinkTagInfo> devLanguageList;
  final List<LabelInfo> toolList;
  final String devProgress;
  final String devSize;
  final List<LabelInfo> tagList;

  @override
  List<Object?> get props => [
        boardId,
        projectName,
        themeColor,
        industry,
        startDate,
        endDate,
        description,
        os,
        db,
        devLanguageList,
        toolList,
        devProgress,
        devSize,
        tagList,
      ];
  BoardDetailBlocState copyWith({
    String? boardId,
    String? projectName,
    Color? themeColor,
    String? industry,
    String? startDate,
    String? endDate,
    String? description,
    String? os,
    String? db,
    List<LinkTagInfo>? devLanguageList,
    List<LabelInfo>? toolList,
    String? devProgress,
    String? devSize,
    List<LabelInfo>? tagList,
  }) =>
      BoardDetailBlocState(
        boardId: boardId ?? this.boardId,
        projectName: projectName ?? this.projectName,
        themeColor: themeColor ?? this.themeColor,
        industry: industry ?? this.industry,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        os: os ?? this.os,
        db: db ?? this.db,
        devLanguageList: devLanguageList ?? this.devLanguageList,
        toolList: toolList ?? this.toolList,
        devProgress: devProgress ?? this.devProgress,
        devSize: devSize ?? this.devSize,
        tagList: tagList ?? this.tagList,
      );
}

// Bloc
class BoardDetailBloc extends Bloc<BoardDetailBlocEvent, BoardDetailBlocState> {
  BoardDetailBloc() : super(initialState) {
    on<Init>(_onInit);
    on<BoardGetDetail>(_onGetDetail);
    on<BoardCreate>(_onCreate);
    on<BoarEdit>(_onEdit);

    /// Change state
    on<BoardChangeProjectName>(_onChangeProjectName);
    on<BoardChangThemeColor>(_onChangeThemeColor);
    on<BoardChangIndustry>(_onChangeIndustry);
    on<BoardChangeDueDate>(_onChangeDueDate);
    on<BoardChangDescription>(_onChangeDescription);
    on<BoardChangeOs>(_onChangeOs);
    on<BoardChangeDb>(_onChangeDb);
    on<BoardChangDevLanguageList>(_onChangeDevLanguageList);
    on<BoardChangeToolList>(_onChangeToolList);
    on<BoardChangeDevProgress>(_onChangeDevProgress);
    on<BoardChangeDevSize>(_onChangeDevSize);
    on<BoardChangeTagList>(_onChangeTagList);
  }

  void _onInit(Init event, Emitter<BoardDetailBlocState> emit) {
    emit(initialState);
  }

  Future<void> _onGetDetail(
      BoardGetDetail event, Emitter<BoardDetailBlocState> emit) async {}

  Future<void> _onCreate(
      BoardCreate event, Emitter<BoardDetailBlocState> emit) async {}

  Future<void> _onEdit(
      BoarEdit event, Emitter<BoardDetailBlocState> emit) async {}

  // state change event
  void _onChangeProjectName(
      BoardChangeProjectName event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(projectName: event.projectName));
  }

  void _onChangeThemeColor(
      BoardChangThemeColor event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(themeColor: event.themeColor));
  }

  void _onChangeIndustry(
      BoardChangIndustry event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(industry: event.industry));
  }

  void _onChangeDueDate(
      BoardChangeDueDate event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
  }

  void _onChangeDescription(
      BoardChangDescription event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onChangeOs(BoardChangeOs event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(os: event.os));
  }

  void _onChangeDb(BoardChangeDb event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(db: event.db));
  }

  void _onChangeDevLanguageList(
      BoardChangDevLanguageList event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(devLanguageList: event.devLanguageList));
  }

  void _onChangeToolList(
      BoardChangeToolList event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(toolList: event.toolList));
  }

  void _onChangeDevProgress(
      BoardChangeDevProgress event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(devProgress: event.devProgress));
  }

  void _onChangeDevSize(
      BoardChangeDevSize event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(devSize: event.devSize));
  }

  void _onChangeTagList(
      BoardChangeTagList event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(tagList: event.tagList));
  }
}
