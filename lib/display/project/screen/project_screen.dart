import 'package:stairs/loom/loom_package.dart';

import 'package:stairs/app/enum/screen_id.dart';
import '../../display_contents.dart';
import '../project_list_bloc.dart';
import 'project_empty.dart';
import 'project_list.dart';

class Project extends DisplayContents {
  const Project({super.key});

  @override
  ScreenId get selectScreenId => ScreenId.board;

  @override
  Widget buildContent(BuildContext context) {
    return BlocBuilder<ProjectListBloc, ProjectListBlocState>(
        builder: (context, state) {
      context.read<ProjectListBloc>().add(const ProjectGetList());
      return state.projectList.isEmpty
          ? const ProjectEmpty()
          : ProjectList(
              projectList: state.projectList,
            );
    });
  }
}
