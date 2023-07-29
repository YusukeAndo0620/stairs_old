import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loom/theme.dart';
import '../board_list_bloc.dart';

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
            onPressed: () => context.read<BoardListBloc>().add(
                  BoardTapCreate(
                    context: context,
                    theme: theme,
                  ),
                ),
            icon: Icon(
              theme.icons.add,
            )),
      ],
    );
  }
}
