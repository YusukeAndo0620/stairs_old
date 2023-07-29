import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart';
import '../../model/model.dart';
import '../display/select_color_display_bloc.dart';
import '../component/list_item/color_list_item.dart';

const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

///カラー選択画面
class SelectColorDisplay extends StatelessWidget {
  const SelectColorDisplay({
    super.key,
    required this.title,
    required this.selectedColorInfo,
    required this.onTapBackIcon,
    required this.onTap,
  });
  final String title;
  final ColorInfo selectedColorInfo;
  final Function(ColorInfo) onTapBackIcon;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => SelectColorDisplayBloc(),
      child: BlocBuilder<SelectColorDisplayBloc, SelectColorDisplayState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is SelectColorInitialState) {
            context.read<SelectColorDisplayBloc>().add(
                  SelectColorInit(selectColorInfo: selectedColorInfo),
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
                    final state = context.read<SelectColorDisplayBloc>().state
                        as SelectColorGotCompleteState;
                    onTapBackIcon(state.selectedColorInfo);
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
                            for (final colorInfo
                                in (state as SelectColorGotCompleteState)
                                    .colorList)
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
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
