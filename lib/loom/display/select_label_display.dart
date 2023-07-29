import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart';
import '../../model/model.dart';
import '../component/list_item/check_list_item.dart';
import 'select_label_display_bloc.dart';

const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

// ラベル選択画面
class SelectLabelDisplay extends StatelessWidget {
  const SelectLabelDisplay({
    super.key,
    required this.title,
    required this.selectedLabelList,
    required this.onTapBackIcon,
    required this.onTap,
  });
  final String title;
  final List<Label> selectedLabelList;
  final Function(List<Label>) onTapBackIcon;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return BlocProvider(
      create: (_) => SelectLabelDisplayBloc(),
      child: BlocBuilder<SelectLabelDisplayBloc, SelectLabelDisplayState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is SelectLabelInitialState) {
            context.read<SelectLabelDisplayBloc>().add(
                  SelectLabelInit(selectedLabelList: selectedLabelList),
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
                    final state = context.read<SelectLabelDisplayBloc>().state
                        as SelectLabelGetCheckListState;
                    onTapBackIcon(state.selectedList);
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: theme.colorBgLayer1,
                title: Text(
                  title,
                  style: theme.textStyleHeading,
                ),
              ),
              body: Padding(
                padding: _kContentPadding,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (final info
                                in (state as SelectLabelGetCheckListState)
                                    .checkList)
                              CheckListItem(
                                info: info,
                                onTap: (tappedItem) {
                                  context.read<SelectLabelDisplayBloc>().add(
                                        SelectLabelListItem(
                                            tappedItem: tappedItem),
                                      );
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
