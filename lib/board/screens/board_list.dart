import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loom/theme.dart';
import '../board_list_bloc.dart';
import 'board_modal.dart';
import '../component/board_list_item.dart';

const _kBoardTitleTxt = 'ボード一覧';
const _kBoardListTitlePadding =
    EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);
const _kBoardListItemBorder = 1.0;

class BoardList extends StatelessWidget {
  const BoardList({super.key, required this.boardList});

  final List<BoardListItemInfo> boardList;

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
              return const BoardModal();
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
            padding: _kBoardListTitlePadding,
            decoration: BoxDecoration(
              color: theme.colorFgDefaultWhite,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorFgDefault,
                  width: _kBoardListItemBorder,
                ),
              ),
            ),
            child: Text(
              _kBoardTitleTxt,
              style: theme.textStyleSubHeading,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final listItem in boardList)
                    BoardListItem(
                      boardId: listItem.boardId,
                      projectName: listItem.projectName,
                      onTap: (boardId) => context.read<BoardListBloc>().add(
                            BoardTapListItem(boardId: boardId),
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
