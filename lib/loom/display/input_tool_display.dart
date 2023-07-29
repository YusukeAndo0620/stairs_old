import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'input_tool_display_bloc.dart';
import '../theme.dart';
import '../component/list_item/input_list_item.dart';
import '../component/item/empty_display.dart';
import '../../model/model.dart';

const _kToolHintTxt = 'ツール名を入力';
const _kToolListEmptyTxt = '開発ツールが登録されていません。\n開発ツールを追加してください';

const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

///ツール入力画面
class InputToolDisplay extends StatelessWidget {
  const InputToolDisplay({
    super.key,
    required this.title,
    required this.toolList,
    required this.onTapBack,
  });
  final String title;
  final List<Label> toolList;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    final scrollController = ScrollController();

    return BlocProvider(
      create: (_) => InputToolDisplayBloc(),
      child: BlocBuilder<InputToolDisplayBloc, InputToolDisplayState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is InputToolDisplayInitialState) {
            context.read<InputToolDisplayBloc>().add(
                  InputToolDisplayInit(toolList: toolList),
                );
            return const SizedBox.shrink();
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    theme.icons.back,
                    color: theme.colorFgDefault,
                  ),
                  onPressed: () {
                    final state = context.read<InputToolDisplayBloc>().state
                        as InputToolDisplayGetInfoState;
                    onTapBack(state.toolList);
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: theme.colorBgLayer1,
                title: Text(
                  title,
                  style: theme.textStyleHeading,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(theme.icons.add),
                onPressed: () {
                  context.read<InputToolDisplayBloc>().add(AddToolItem());
                  context
                      .read<InputToolDisplayBloc>()
                      .add(MoveLast(scrollController: scrollController));
                },
              ),
              body: Padding(
                padding: _kContentPadding,
                child: (state as InputToolDisplayGetInfoState).toolList.isEmpty
                    ? const EmptyDisplay(
                        message: _kToolListEmptyTxt,
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  for (final info
                                      in (state as InputToolDisplayGetInfoState)
                                          .toolList)
                                    InputListItem(
                                      id: info.id,
                                      inputValue: info.labelName,
                                      hintText: _kToolHintTxt,
                                      onTextSubmitted: (value, id) => context
                                          .read<InputToolDisplayBloc>()
                                          .add(UpdateInputValue(
                                              id: id, inputValue: value)),
                                      onDeleteItem: (inputValue) {
                                        context
                                            .read<InputToolDisplayBloc>()
                                            .add(DeleteToolItem(id: info.id));
                                      },
                                    ),
                                  const SizedBox(
                                    height: _kSpaceHeight,
                                  ),
                                ],
                              ),
                            ),
                          )
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
