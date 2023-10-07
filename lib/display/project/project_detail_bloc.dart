import 'package:collection/collection.dart';
import 'package:stairs/loom/loom_package.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

final initialState = ProjectDetailBlocState(
    projectId: uuid.v4(),
    projectName: '',
    colorInfo: ColorInfo(
      id: uuid.v4(),
      themeColor: const Color.fromARGB(255, 10, 241, 161),
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
abstract class ProjectDetailBlocEvent {
  const ProjectDetailBlocEvent();
}

//Init
class Init extends ProjectDetailBlocEvent {
  const Init();
}

// Get detail info
class ProjectGetDetail extends ProjectDetailBlocEvent {
  const ProjectGetDetail({required this.projectId});

  final String projectId;
}

// Request of creating project
class ProjectCreate extends ProjectDetailBlocEvent {}

// Request of editing project
class BoarEdit extends ProjectDetailBlocEvent {
  const BoarEdit({required this.projectId});

  final String projectId;
}

/// State change event
// Change project name and set state
class ProjectChangeProjectName extends ProjectDetailBlocEvent {
  const ProjectChangeProjectName({required this.projectName});

  final String projectName;
}

// Change theme color and set state
class ProjectChangeThemeColor extends ProjectDetailBlocEvent {
  const ProjectChangeThemeColor({required this.colorInfo});

  final ColorInfo colorInfo;
}

// Change industry and set state
class ProjectChangeIndustry extends ProjectDetailBlocEvent {
  const ProjectChangeIndustry({required this.industry});

  final String industry;
}

// Change due date and set state
class ProjectChangeDueDate extends ProjectDetailBlocEvent {
  const ProjectChangeDueDate({required this.startDate, required this.endDate});

  final DateTime startDate;
  final DateTime endDate;
}

// Change description and set state
class ProjectChangeDescription extends ProjectDetailBlocEvent {
  const ProjectChangeDescription({required this.description});

  final String description;
}

// Change os and set state
class ProjectChangeOs extends ProjectDetailBlocEvent {
  const ProjectChangeOs({required this.os});

  final String os;
}

// Change db and set state
class ProjectChangeDb extends ProjectDetailBlocEvent {
  const ProjectChangeDb({required this.db});

  final String db;
}

// Change development language and set state
class ProjectChangeDevLanguageList extends ProjectDetailBlocEvent {
  const ProjectChangeDevLanguageList({required this.devLanguageList});

  final List<LinkTagInfo> devLanguageList;
}

// Change toolList and set state
class ProjectChangeToolList extends ProjectDetailBlocEvent {
  const ProjectChangeToolList({required this.toolList});

  final List<Label> toolList;
}

// Change development Progress and set state
class ProjectChangeDevProgressList extends ProjectDetailBlocEvent {
  const ProjectChangeDevProgressList({required this.devProgressList});

  final List<Label> devProgressList;
}

// Change development Size and set state
class ProjectChangeDevSize extends ProjectDetailBlocEvent {
  const ProjectChangeDevSize({required this.devSize});

  final String devSize;
}

// Change label and set state
class ProjectChangeTagList extends ProjectDetailBlocEvent {
  const ProjectChangeTagList({required this.tagList});

  final List<ColorLabelInfo> tagList;
}

// State
@immutable
class ProjectDetailBlocState extends Equatable {
  const ProjectDetailBlocState({
    required this.projectId,
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

  final String projectId;
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
        projectId,
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
  ProjectDetailBlocState copyWith({
    String? projectId,
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
      ProjectDetailBlocState(
        projectId: projectId ?? this.projectId,
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
class ProjectDetailBloc
    extends Bloc<ProjectDetailBlocEvent, ProjectDetailBlocState> {
  ProjectDetailBloc() : super(initialState) {
    on<Init>(_onInit);
    on<ProjectGetDetail>(_onGetDetail);
    on<ProjectCreate>(_onCreate);
    on<BoarEdit>(_onEdit);

    /// Change state
    on<ProjectChangeProjectName>(_onChangeProjectName);
    on<ProjectChangeThemeColor>(_onChangeThemeColor);
    on<ProjectChangeIndustry>(_onChangeIndustry);
    on<ProjectChangeDueDate>(_onChangeDueDate);
    on<ProjectChangeDescription>(_onChangeDescription);
    on<ProjectChangeOs>(_onChangeOs);
    on<ProjectChangeDb>(_onChangeDb);
    on<ProjectChangeDevLanguageList>(_onChangeDevLanguageList);
    on<ProjectChangeToolList>(_onChangeToolList);
    on<ProjectChangeDevProgressList>(_onChangeDevProgressList);
    on<ProjectChangeDevSize>(_onChangeDevSize);
    on<ProjectChangeTagList>(_onChangeTagList);
  }

  void _onInit(Init event, Emitter<ProjectDetailBlocState> emit) {
    emit(initialState);
  }

  Future<void> _onGetDetail(
      ProjectGetDetail event, Emitter<ProjectDetailBlocState> emit) async {
    if (event.projectId.isEmpty) {
      emit(initialState);
    } else {
      final detailInfo = dummyProjectDetailList
          .firstWhereOrNull((item) => item.projectId == event.projectId);
      if (detailInfo == null) {
        emit(initialState);
      } else {
        emit(ProjectDetailBlocState(
          projectId: detailInfo.projectId,
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
      ProjectCreate event, Emitter<ProjectDetailBlocState> emit) async {}

  Future<void> _onEdit(
      BoarEdit event, Emitter<ProjectDetailBlocState> emit) async {}

  // state change event
  void _onChangeProjectName(
      ProjectChangeProjectName event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(projectName: event.projectName));
  }

  void _onChangeThemeColor(
      ProjectChangeThemeColor event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(colorInfo: event.colorInfo));
  }

  void _onChangeIndustry(
      ProjectChangeIndustry event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(industry: event.industry));
  }

  void _onChangeDueDate(
      ProjectChangeDueDate event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
  }

  void _onChangeDescription(
      ProjectChangeDescription event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onChangeOs(
      ProjectChangeOs event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(os: event.os));
  }

  void _onChangeDb(
      ProjectChangeDb event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(db: event.db));
  }

  void _onChangeDevLanguageList(ProjectChangeDevLanguageList event,
      Emitter<ProjectDetailBlocState> emit) {
    final emitDevLangList = event.devLanguageList
        .where((item) => item.inputValue.isNotEmpty)
        .toList();
    emit(state.copyWith(devLanguageList: emitDevLangList));
  }

  void _onChangeToolList(
      ProjectChangeToolList event, Emitter<ProjectDetailBlocState> emit) {
    final emitToolList =
        event.toolList.where((item) => item.labelName.isNotEmpty).toList();
    emit(state.copyWith(toolList: emitToolList));
  }

  void _onChangeDevProgressList(ProjectChangeDevProgressList event,
      Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(devProgressList: event.devProgressList));
  }

  void _onChangeDevSize(
      ProjectChangeDevSize event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(devSize: event.devSize));
  }

  void _onChangeTagList(
      ProjectChangeTagList event, Emitter<ProjectDetailBlocState> emit) {
    emit(state.copyWith(tagList: event.tagList));
  }

// ボードで設定したラベル（開発言語＋タグ）リスト取得
  List<ColorLabelInfo> getLabelList({required String projectId}) {
    //TODO: API使用予定
    final projectDetail = dummyProjectDetailList
        .firstWhere((element) => element.projectId == projectId);
    final labelList = <ColorLabelInfo>[];

    for (final devItem in projectDetail.devLanguageList) {
      final targetList = devItem.linkLabelList
          .map(
            (item) => ColorLabelInfo(
              id: devItem.inputValue + item.id,
              labelName: devItem.inputValue + ' - ' + item.labelName,
              themeColor: item.themeColor,
            ),
          )
          .toList();
      labelList.addAll(targetList);
    }
    return [...projectDetail.tagList, ...labelList];
  }
}
