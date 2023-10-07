import 'package:stairs/loom/loom_package.dart';
import '../project_list_bloc.dart';

const _kProjectListItemContentPadding =
    EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);
const _kProjectListItemTitleMaxLine = 1;
const _kProjectListItemReaderIconSize = 24.0;
const _kProjectListItemBorder = 1.0;

class ProjectListItem extends StatefulWidget {
  const ProjectListItem({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.themeColor,
    required this.onTap,
  });

  final String projectId;
  final String projectName;
  final Color themeColor;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return ListTile(
      leading: Icon(
        Icons.table_chart,
        color: widget.themeColor,
        size: 45,
      ),
      title: Container(
        padding: _kProjectListItemContentPadding,
        child: Text(
          widget.projectName,
          style: theme.textStyleBody,
          maxLines: _kProjectListItemTitleMaxLine,
          overflow: TextOverflow.ellipsis,
          selectionColor: _pressed ? theme.colorFgDisabled : null,
        ),
      ),
      trailing: GestureDetector(
        child: IconButton(
          icon: Icon(
            theme.icons.reader,
          ),
          iconSize: _kProjectListItemReaderIconSize,
          onPressed: () {},
        ),
        onTapDown: (details) {
          final position = details.globalPosition;
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
            items: [
              PopupMenuItem(
                value: 1,
                child: Text(
                  '編集',
                  style: theme.textStyleBody,
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  '削除',
                  style: theme.textStyleBody,
                ),
              ),
            ],
            elevation: 8.0,
          ).then((value) {
            debugPrint('menuItem $value tapped');
            switch (value) {
              case 1:
                context.read<ProjectListBloc>().add(
                      ProjectTapEdit(
                        projectId: widget.projectId,
                        context: context,
                        theme: theme,
                      ),
                    );
              case 2:
                return;
              default:
                return;
            }
          });
        },
      ),
      shape: Border(
        bottom: BorderSide(
          color: theme.colorFgDefault,
          width: _kProjectListItemBorder,
        ),
      ),
      onFocusChange: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTap: () {
        setState(() {
          _pressed = true;
        });
        widget.onTap();
      },
    );
  }
}
