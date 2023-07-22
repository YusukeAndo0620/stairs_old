import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../theme.dart';
import '../../model/model.dart';
import '../display/input_display.dart';
import '../component/list_item/check_list_item.dart';
import 'select_label_display_bloc.dart';

const _kSpaceHeight = 120.0;

class SelectLabelDisplay extends InputDisplay {
  const SelectLabelDisplay({
    super.key,
    required super.title,
    required this.selectedLabelList,
    required this.onTapBackIcon,
    required this.onTap,
  });
  final List<Label> selectedLabelList;
  final Function(List<Label>) onTapBackIcon;
  final Function(int) onTap;

  @override
  List<SingleChildWidget> getPageProviders() {
    return [];
  }

  @override
  VoidCallback? onTapAddingBtn(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeadingContent(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
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
    );
  }

  @override
  Widget? buildTrailingContent(BuildContext context) => null;

  @override
  Widget buildMainContent(BuildContext context) {
    return BlocBuilder<SelectLabelDisplayBloc, SelectLabelDisplayState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is SelectLabelInitialState) {
          context.read<SelectLabelDisplayBloc>().add(
                SelectLabelInit(selectedLabelList: selectedLabelList),
              );
          return const SizedBox.shrink();
        } else {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final info
                          in (state as SelectLabelGetCheckListState).checkList)
                        CheckListItem(
                          info: info,
                          onTap: (tappedItem) {
                            context.read<SelectLabelDisplayBloc>().add(
                                  SelectLabelListItem(tappedItem: tappedItem),
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
          );
        }
      },
    );
  }
}
