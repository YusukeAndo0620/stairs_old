import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'app_function.dart';
import '../board/screens/board_screen.dart';
import '../board/board_list_bloc.dart';
import '../board/board_detail_bloc.dart';
import '../loom/display/link_tag_display_bloc.dart';
import '../loom/component/modal/select_item_modal_bloc.dart';

class App extends AppFunction {
  const App();

  @override
  void addProvides(List<SingleChildWidget> globalProvides) {
    globalProvides
      ..add(BlocProvider(create: (_) => BoardListBloc()))
      ..add(BlocProvider(create: (_) => BoardDetailBloc()))
      ..add(BlocProvider(create: (_) => LinkTagDisplayBloc()))
      ..add(BlocProvider(create: (_) => SelectItemModalBloc()));
  }

  @override
  Widget buildMainContents(context) {
    return const Board();
  }
}
