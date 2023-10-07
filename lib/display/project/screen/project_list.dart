import 'package:stairs/loom/loom_package.dart';
import '../../../model/model.dart';
import '../component/project_list_item.dart';
import '../../board/screen/board_screen.dart';
import 'project_edit_modal.dart';

const _kProjectTitleTxt = 'プロジェクト一覧';
const _kProjectListTitlePadding =
    EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);
const _kProjectListItemBorder = 1.0;

class ProjectList extends StatelessWidget {
  const ProjectList({super.key, required this.projectList});

  final List<ProjectListItemInfo> projectList;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(theme.icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const ProjectEditModal(
                projectId: '',
              );
            },
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: _kProjectListTitlePadding,
            decoration: BoxDecoration(
              color: theme.colorFgDefaultWhite,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorFgDefault,
                  width: _kProjectListItemBorder,
                ),
              ),
            ),
            child: Text(
              _kProjectTitleTxt,
              style: theme.textStyleSubHeading,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final listItem in projectList)
                    ProjectListItem(
                      projectId: listItem.projectId,
                      projectName: listItem.projectName,
                      themeColor: listItem.themeColor,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return BoardScreen(
                              projectId: listItem.projectId,
                              title: listItem.projectName,
                              themeColor: listItem.themeColor,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
