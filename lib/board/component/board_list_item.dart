import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loom/theme.dart';
import '../board_list_bloc.dart';

const _kBoardListItemContentPadding =
    EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);
const _kBoardListItemTitleMaxLine = 1;
const _kBoardListItemReaderIconSize = 24.0;
const _kBoardListItemBorder = 1.0;

class BoardListItem extends StatefulWidget {
  const BoardListItem({
    super.key,
    required this.boardId,
    required this.projectName,
    required this.onTap,
  });

  final String boardId;
  final String projectName;
  final Function(String) onTap;

  @override
  State<StatefulWidget> createState() => _BoardListItemState();
}

class _BoardListItemState extends State<BoardListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Container(
        padding: _kBoardListItemContentPadding,
        child: Text(
          widget.projectName,
          style: theme.textStyleBody,
          maxLines: _kBoardListItemTitleMaxLine,
          overflow: TextOverflow.ellipsis,
          selectionColor: _pressed ? theme.colorFgDisabled : null,
        ),
      ),
      trailing: GestureDetector(
        child: IconButton(
          icon: Icon(
            theme.icons.reader,
          ),
          iconSize: _kBoardListItemReaderIconSize,
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
                context.read<BoardListBloc>().add(
                      BoardTapEdit(
                        boardId: widget.boardId,
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
          width: _kBoardListItemBorder,
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
        context.read<BoardListBloc>().add(
              BoardTapListItem(
                boardId: widget.boardId,
              ),
            );
      },
    );

    // return GestureDetector(
    //   onTapDown: (_) {
    //     setState(() {
    //       _pressed = true;
    //     });
    //   },
    //   onTapUp: (_) {
    //     setState(() {
    //       _pressed = false;
    //     });
    //   },
    //   onTapCancel: () {
    //     setState(() {
    //       _pressed = false;
    //     });
    //   },
    //   onTap: widget.onTap(widget.boardId),
    //   behavior: HitTestBehavior.opaque,
    //   child: AnimatedContainer(
    //     duration: _kAnimatedDuration,
    //     decoration: BoxDecoration(
    //       color: _pressed ? theme.colorFgDisabled : null,
    //     ),
    //     child: Container(
    //       padding: _kBoardListItemContentPadding,
    //       decoration: BoxDecoration(
    //         border: Border(
    //           bottom: BorderSide(
    //             color: theme.colorFgDefault,
    //             width: _kBoardListItemBorder,
    //           ),
    //         ),
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             child: Text(
    //               widget.projectName,
    //               style: theme.textStyleBody,
    //               maxLines: _kBoardListItemTitleMaxLine,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //           IconButton(
    //             icon: Icon(
    //               theme.icons.reader,
    //             ),
    //             iconSize: _kBoardListItemReaderIconSize,
    //             onPressed: () {},
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
