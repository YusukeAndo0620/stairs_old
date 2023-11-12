import 'package:stairs/loom/loom_package.dart';

import '../project_list_bloc.dart';
import 'project_empty.dart';
import 'project_list.dart';

class Project extends StatelessWidget {
  const Project({super.key});

  @override
  Widget build(BuildContext context) {
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
