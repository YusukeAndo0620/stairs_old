import 'package:equatable/equatable.dart';
import '../../loom/loom_package.dart';
import 'screen/project_edit_modal.dart';
import '../../model/model.dart';
import '../../model/dummy.dart';

// Event
abstract class ProjectListBlocEvent {
  const ProjectListBlocEvent();
}

class _Init extends ProjectListBlocEvent {
  const _Init();
}

class ProjectGetList extends ProjectListBlocEvent {
  const ProjectGetList();
}

class ProjectTapEdit extends ProjectListBlocEvent {
  const ProjectTapEdit({
    required this.projectId,
    required this.context,
    required this.theme,
  });

  final String projectId;
  final BuildContext context;
  final LoomThemeData theme;
}

class ProjectTapDelete extends ProjectListBlocEvent {
  const ProjectTapDelete();
}

// State
@immutable
class ProjectListBlocState extends Equatable {
  const ProjectListBlocState({required this.projectList});

  final List<ProjectListItemInfo> projectList;

  @override
  List<Object?> get props => [projectList];
}

// Bloc
class ProjectListBloc extends Bloc<ProjectListBlocEvent, ProjectListBlocState> {
  ProjectListBloc()
      : super(
          const ProjectListBlocState(projectList: []),
        ) {
    on<_Init>(_onInit);
    on<ProjectGetList>(_onGetList);
    on<ProjectTapEdit>(_onTapEdit);
    on<ProjectTapDelete>(_onTapDelete);
  }

  void _onInit(_Init event, Emitter<ProjectListBlocState> emit) {
    emit(const ProjectListBlocState(projectList: []));
  }

  Future<void> _onGetList(
      ProjectGetList event, Emitter<ProjectListBlocState> emit) async {
    emit(ProjectListBlocState(projectList: dummyProjectList));
  }

  void _onTapEdit(ProjectTapEdit event, Emitter<ProjectListBlocState> emit) {
    showModalBottomSheet(
        context: event.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ProjectEditModal(projectId: event.projectId);
        });
  }

  Future<void> _onTapDelete(
      ProjectTapDelete event, Emitter<ProjectListBlocState> emit) async {}
}
