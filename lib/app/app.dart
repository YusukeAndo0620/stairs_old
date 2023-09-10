import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'app_function.dart';
import '../display/board/screen/board_screen.dart';
import '../display/board/board_list_bloc.dart';
import '../display/board/board_detail_bloc.dart';
import '../display/work_board/task_item_bloc.dart';
import '../loom/component/modal/select_item_modal_bloc.dart';
import '../loom/display/link_tag_display_bloc.dart';
import '../loom/display/select_color_display_bloc.dart';
import '../loom/display/select_label_display_bloc.dart';
import '../loom/display/input_tag_display_bloc.dart';

class App extends AppFunction {
  const App();

  @override
  void addProvides(List<SingleChildWidget> globalProvides) {
    globalProvides
      ..add(BlocProvider(create: (_) => BoardListBloc()))
      ..add(BlocProvider(create: (_) => BoardDetailBloc()))
      ..add(BlocProvider(create: (_) => SelectItemModalBloc()))
      ..add(BlocProvider(create: (_) => TaskItemBloc()))
      ..add(BlocProvider(create: (_) => InputTagDisplayBloc()))
      ..add(BlocProvider(create: (_) => LinkTagDisplayBloc()));
  }

  @override
  Widget buildMainContents(context) {
    return const Board();
  }
}
