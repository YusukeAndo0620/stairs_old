import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../loom/theme.dart';
import '../work_board_bloc.dart';
import '../work_board_position_bloc.dart';
import '../component/carousel_display_bloc.dart';
import '../component/carousel_display.dart';
import '../component/work_board_card.dart';

enum PageAction {
  next,
  previous,
}

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WorkBoardBloc(),
        ),
        BlocProvider(
          create: (_) => WorkBoardPositionBloc(),
        ),
        BlocProvider(
          create: (_) => CarouselDisplayBloc(),
        )
      ],
      child: BlocConsumer<WorkBoardBloc, WorkBoardBlocState>(
        listenWhen: (previous, current) =>
            previous.workBoardList.length != current.workBoardList.length,
        listener: (context, state) {},
        builder: (context, state) {
          context.read<WorkBoardBloc>().add(WorkBoardGetList(boardId: boardId));
          context
              .read<WorkBoardPositionBloc>()
              .add(WorkBoardPositionInit(boardId: boardId));

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
                    workBoardId: item.workBoardId,
                    displayedWorkBoardId: state
                        .workBoardList[context
                            .read<CarouselDisplayBloc>()
                            .state
                            .currentPage]
                        .workBoardId,
                    title: item.title,
                    themeColor: item.themeColor,
                    workBoardItemList: item.workBoardItemList,
                    onPageChanged: (pageAction) {
                      final carouselDisplayState =
                          context.read<CarouselDisplayBloc>().state;
                      //すでにページ番号が更新されていた場合、処理を行わない
                      if (state
                              .workBoardList[context
                                  .read<CarouselDisplayBloc>()
                                  .state
                                  .currentPage]
                              .workBoardId !=
                          item.workBoardId) {
                        return;
                      }
                      switch (pageAction) {
                        case PageAction.next:
                          if (carouselDisplayState.currentPage <
                              state.workBoardList.length) {
                            context
                                .read<CarouselDisplayBloc>()
                                .add(const CarouselDisplayMoveNextPage());
                          }
                        case PageAction.previous:
                          if (carouselDisplayState.currentPage > 0) {
                            context
                                .read<CarouselDisplayBloc>()
                                .add(const CarouselDisplayMovePreviousPage());
                          }
                      }
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}