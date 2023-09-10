import 'package:stairs/loom/loom_package.dart';

import 'package:stairs/app/enum/screen_id.dart';
import '../../display_contents.dart';
import '../board_list_bloc.dart';
import 'board_empty.dart';
import 'board_list.dart';

class Board extends DisplayContents {
  const Board({super.key});

  @override
  ScreenId get selectScreenId => ScreenId.board;

  @override
  Widget buildContent(BuildContext context) {
    return BlocBuilder<BoardListBloc, BoardListBlocState>(
        builder: (context, state) {
      context.read<BoardListBloc>().add(const BoardGetList());
      return state.boardList.isEmpty
          ? const BoardEmpty()
          : BoardList(
              boardList: state.boardList,
            );
    });
  }
}
