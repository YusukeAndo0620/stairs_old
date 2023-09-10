import 'package:stairs/loom/loom_package.dart';

import '../work_board_position_bloc.dart';

const _kItemHeight = 120.0;

class ShrinkTaskListItem extends StatelessWidget {
  const ShrinkTaskListItem({
    super.key,
    required this.id,
  });
  final String id;

  @override
  Widget build(BuildContext context) {
    final itemKey = GlobalKey();
    final theme = LoomTheme.of(context);

    context
        .read<WorkBoardPositionBloc>()
        .add(WorkBoardSetCardItemPosition(workBoardItemId: id, key: itemKey));
    return Container(
      key: itemKey,
      width: MediaQuery.of(context).size.width * 0.7,
      height: _kItemHeight,
      color: theme.colorDisabled.withOpacity(0.2),
    );
  }
}
