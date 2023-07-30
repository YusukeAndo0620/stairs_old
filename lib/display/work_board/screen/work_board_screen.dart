import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../loom/theme.dart';
import '../work_board_bloc.dart';
import '../component/carousel_display.dart';
import '../component/work_board_card.dart';

class WorkBoardScreen extends StatelessWidget {
  const WorkBoardScreen({
    super.key,
    required this.boardId,
    required this.title,
  });

  final String boardId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkBoardBloc(),
      child: BlocBuilder<WorkBoardBloc, WorkBoardBlocState>(
        builder: (context, state) {
          context.read<WorkBoardBloc>().add(WorkBoardGetList(boardId: boardId));
          final theme = LoomTheme.of(context);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  theme.icons.back,
                  color: theme.colorFgDefault,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: theme.colorBgLayer1,
              title: Text(
                title,
                style: theme.textStyleHeading,
              ),
            ),
            body: CarouselDisplay(
              pages: [
                for (final item in state.workBoardList)
                  WorkBoardCard(
                    title: item.title,
                    themeColor: item.themeColor,
                    workBoardItemList: item.workBoardItemList,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
