import 'package:collection/collection.dart';
import 'package:stairs/loom/loom_package.dart';

import '../board_bloc.dart';
import '../board_position_bloc.dart';
import '../component/carousel_display_bloc.dart';
import '../component/carousel_display.dart';
import '../component/board_card.dart';
import '../board_card_bloc.dart';
import '../drag_item_bloc.dart';
import '../component/board_adding_card.dart';

enum PageAction {
  next,
  previous,
}

class BoardScreen extends StatelessWidget {
  const BoardScreen({
    super.key,
    required this.projectId,
    required this.title,
    required this.themeColor,
  });

  final String projectId;
  final String title;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BoardBloc(),
        ),
        BlocProvider(
          create: (_) => DragItemBloc(),
        ),
        BlocProvider(
          create: (_) => BoardPositionBloc(),
        ),
        BlocProvider(
          create: (_) => CarouselDisplayBloc(),
        ),
      ],
      child: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) {
          if (state is BoardInitialState) {
            context.read<BoardBloc>().add(BoardSetList(projectId: projectId));
            return const SizedBox.shrink();
          } else {
            context
                .read<BoardPositionBloc>()
                .add(BoardPositionInit(projectId: projectId));
            context.read<CarouselDisplayBloc>().add(
                  CarouselDisplayInit(
                    maxPage: (state as BoardListState).boardList.length,
                  ),
                );

            final theme = LoomTheme.of(context);
            final boardList =
                context.read<BoardBloc>().getList(projectId: projectId);

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
                  style: theme.textStyleHeading
                      .copyWith(color: theme.colorFgDefault.withOpacity(0.9)),
                ),
              ),
              body: Container(
                color: themeColor.withOpacity(0.1),
                child: CarouselDisplay(
                  pages: [
                    for (final item in state.boardList)
                      BoardCard(
                        projectId: projectId,
                        boardId: item.boardId,
                        displayedBoardId: state
                            .boardList[context
                                .read<CarouselDisplayBloc>()
                                .state
                                .currentPage]
                            .boardId,
                        title: item.title,
                        themeColor: themeColor,
                        taskItemList: boardList.indexWhere((element) =>
                                    element.boardId == item.boardId) ==
                                -1
                            ? []
                            : boardList[boardList.indexWhere((element) =>
                                    element.boardId == item.boardId)]
                                .taskItemList,
                        onPageChanged: (pageAction) {
                          final carouselDisplayState =
                              context.read<CarouselDisplayBloc>().state;
                          //すでにページ番号が更新されていた場合、処理を行わない
                          if (state
                                  .boardList[context
                                      .read<CarouselDisplayBloc>()
                                      .state
                                      .currentPage]
                                  .boardId !=
                              item.boardId) {
                            return;
                          }
                          final currentBoardIdIndex = state.boardList.indexOf(
                              state.boardList.firstWhere((element) =>
                                  element.boardId == item.boardId));

                          switch (pageAction) {
                            case PageAction.next:
                              if (carouselDisplayState.currentPage <
                                  state.boardList.length - 1) {
                                context
                                    .read<CarouselDisplayBloc>()
                                    .add(const CarouselDisplayMoveNextPage());

                                context.read<DragItemBloc>().add(
                                      DragItemChangeTaskItem(
                                        boardId: state
                                            .boardList[currentBoardIdIndex + 1]
                                            .boardId,
                                      ),
                                    );
                              }
                            case PageAction.previous:
                              if (carouselDisplayState.currentPage > 0) {
                                context.read<CarouselDisplayBloc>().add(
                                    const CarouselDisplayMovePreviousPage());
                                context.read<DragItemBloc>().add(
                                      DragItemChangeTaskItem(
                                        boardId: state
                                            .boardList[currentBoardIdIndex - 1]
                                            .boardId,
                                      ),
                                    );
                              }
                          }
                        },
                      ),
                    BoardAddingCard(
                      themeColor: themeColor,
                      onOpenCard: () => context.read<CarouselDisplayBloc>().add(
                            const CarouselDisplayMoveLastPage(),
                          ),
                      onTapAddingBtn: (inputValue) {
                        context.read<BoardBloc>().add(
                              BoardAddCard(
                                  projectId: projectId, title: inputValue),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
