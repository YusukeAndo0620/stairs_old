import 'package:flutter/material.dart' hide Theme;
import '../../loom/theme.dart';
import 'board_modal.dart';

const _kBoardEmptyTxt = '表示可能なボードがありません。\nボードを作成してください。';

const _kBoardEmptyContentPadding =
    EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0);

class BoardEmpty extends StatelessWidget {
  const BoardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: _kBoardEmptyContentPadding,
          child: Text(
            _kBoardEmptyTxt,
            style: theme.textStyleBody,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
            onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return const BoardModal(
                      boardId: '',
                    );
                  },
                ),
            icon: Icon(
              theme.icons.add,
            )),
      ],
    );
  }
}
