import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/model.dart';
import '../model/dummy.dart';

final initialState = BoardDetailBlocState(
    boardId: uuid.v4(),
    projectName: '',
    colorInfo: ColorInfo(
      id: uuid.v4(),
      themeColor: Color.fromARGB(255, 10, 241, 161),
    ),
    industry: '',
    startDate: DateTime(2010, 1, 1),
    endDate: DateTime.now(),
    devLanguageList: const [],
    toolList: toolList,
    devProgressList: [
      devProgressList[1],
      devProgressList[2],
      devProgressList[3],
      devProgressList[4],
    ],
    devSize: '100',
    tagList: tagList);

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
  const BoardChangThemeColor({required this.colorInfo});

  final ColorInfo colorInfo;
}

// Change industry and set state
class BoardChangIndustry extends BoardDetailBlocEvent {
  const BoardChangIndustry({required this.industry});

  final String industry;
}

// Change due date and set state
class BoardChangeDueDate extends BoardDetailBlocEvent {
  const BoardChangeDueDate({required this.startDate, required this.endDate});

  final DateTime startDate;
  final DateTime endDate;
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

  final List<Label> toolList;
}

// Change development Progress and set state
class BoardChangeDevProgressList extends BoardDetailBlocEvent {
  const BoardChangeDevProgressList({required this.devProgressList});

  final List<Label> devProgressList;
}

// Change development Size and set state
class BoardChangeDevSize extends BoardDetailBlocEvent {
  const BoardChangeDevSize({required this.devSize});

  final String devSize;
}

// Change label and set state
class BoardChangeTagList extends BoardDetailBlocEvent {
  const BoardChangeTagList({required this.tagList});

  final List<ColorLabelInfo> tagList;
}

// State
@immutable
class BoardDetailBlocState extends Equatable {
  const BoardDetailBlocState({
    required this.boardId,
    required this.projectName,
    required this.colorInfo,
    required this.industry,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.os = '',
    this.db = '',
    this.devLanguageList = const [],
    this.toolList = const [],
    this.devProgressList = const [],
    this.devSize = '',
    this.tagList = const [],
  });

  final String boardId;
  final String projectName;
  final ColorInfo colorInfo;
  final String industry;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String os;
  final String db;
  final List<LinkTagInfo> devLanguageList;
  final List<Label> toolList;
  final List<Label> devProgressList;
  final String devSize;
  final List<ColorLabelInfo> tagList;

  @override
  List<Object?> get props => [
        boardId,
        projectName,
        colorInfo,
        industry,
        startDate,
        endDate,
        description,
        os,
        db,
        devLanguageList,
        toolList,
        devProgressList,
        devSize,
        tagList,
      ];
  BoardDetailBlocState copyWith({
    String? boardId,
    String? projectName,
    ColorInfo? colorInfo,
    String? industry,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? os,
    String? db,
    List<LinkTagInfo>? devLanguageList,
    List<Label>? toolList,
    List<Label>? devProgressList,
    String? devSize,
    List<ColorLabelInfo>? tagList,
  }) =>
      BoardDetailBlocState(
        boardId: boardId ?? this.boardId,
        projectName: projectName ?? this.projectName,
        colorInfo: colorInfo ?? this.colorInfo,
        industry: industry ?? this.industry,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        os: os ?? this.os,
        db: db ?? this.db,
        devLanguageList: devLanguageList ?? this.devLanguageList,
        toolList: toolList ?? this.toolList,
        devProgressList: devProgressList ?? this.devProgressList,
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
    on<BoardChangeDevProgressList>(_onChangeDevProgressList);
    on<BoardChangeDevSize>(_onChangeDevSize);
    on<BoardChangeTagList>(_onChangeTagList);
  }

  void _onInit(Init event, Emitter<BoardDetailBlocState> emit) {
    emit(initialState);
  }

  Future<void> _onGetDetail(
      BoardGetDetail event, Emitter<BoardDetailBlocState> emit) async {
    if (event.boardId.isEmpty) {
      emit(initialState);
    } else {
      final detailInfo = dummyBoardDetailList
          .firstWhereOrNull((item) => item.boardId == event.boardId);
      if (detailInfo == null) {
        emit(initialState);
      } else {
        emit(BoardDetailBlocState(
          boardId: detailInfo.boardId,
          projectName: detailInfo.projectName,
          colorInfo: colorList
              .firstWhere((element) => element.id == detailInfo.themeColorId),
          industry: detailInfo.industry,
          startDate: DateTime.parse(detailInfo.startDate),
          endDate: DateTime.parse(detailInfo.endDate),
          description: detailInfo.description,
          os: detailInfo.os,
          db: detailInfo.db,
          devLanguageList: detailInfo.devLanguageList,
          toolList: detailInfo.toolList,
          devProgressList: detailInfo.devProgressList,
          devSize: detailInfo.devSize,
          tagList: detailInfo.tagList,
        ));
      }
    }
  }

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
    emit(state.copyWith(colorInfo: event.colorInfo));
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
    final emitDevLangList = event.devLanguageList
        .where((item) => item.inputValue.isNotEmpty)
        .toList();
    emit(state.copyWith(devLanguageList: emitDevLangList));
  }

  void _onChangeToolList(
      BoardChangeToolList event, Emitter<BoardDetailBlocState> emit) {
    final emitToolList =
        event.toolList.where((item) => item.labelName.isNotEmpty).toList();
    emit(state.copyWith(toolList: emitToolList));
  }

  void _onChangeDevProgressList(
      BoardChangeDevProgressList event, Emitter<BoardDetailBlocState> emit) {
    emit(state.copyWith(devProgressList: event.devProgressList));
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
