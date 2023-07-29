import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../theme.dart';
import '../../model/model.dart';
import '../display/input_display.dart';
import '../display/select_color_display_bloc.dart';
import '../component/list_item/color_list_item.dart';

const _kSpaceHeight = 120.0;

class SelectColorDisplay extends InputDisplay {
  const SelectColorDisplay({
    super.key,
    required super.title,
    required this.selectedColorInfo,
    required this.onTapBackIcon,
    required this.onTap,
  });
  final ColorInfo selectedColorInfo;
  final Function(ColorInfo) onTapBackIcon;
  final Function(int) onTap;

  @override
  List<SingleChildWidget> getPageProviders() {
    // return [BlocProvider(create: (_) => SelectColorDisplayBloc())];
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
        final state = context.read<SelectColorDisplayBloc>().state
            as SelectColorGotCompleteState;
        onTapBackIcon(state.selectedColorInfo);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget? buildTrailingContent(BuildContext context) => null;

  @override
  Widget buildMainContent(BuildContext context) {
    return BlocBuilder<SelectColorDisplayBloc, SelectColorDisplayState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is SelectColorInitialState) {
          context.read<SelectColorDisplayBloc>().add(
                SelectColorInit(selectColorInfo: selectedColorInfo),
              );
          return const SizedBox.shrink();
        } else {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final colorInfo
                          in (state as SelectColorGotCompleteState).colorList)
                        ColorListItem(
                          selectedColorId: state.selectedColorId,
                          colorInfo: colorInfo,
                          onTap: (id) {
                            context.read<SelectColorDisplayBloc>().add(
                                  SelectColorTapListItem(colorId: id),
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
