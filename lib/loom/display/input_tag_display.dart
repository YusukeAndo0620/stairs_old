import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart';
import '../../model/model.dart';
import 'input_tag_display_bloc.dart';
import '../component/list_item/link_list_item.dart';
import '../component/item/color_box.dart';
import '../component/item/empty_display.dart';
import 'select_color_display.dart';

const _kTagHintTxt = 'タグ名を追加';
const _kColorHintText = '色を選択';
const _kTagListEmptyTxt = 'ラベルが登録されていません。\nラベルを登録してください。';

const _kColorTxt = '色';

const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

///タグ（ラベル）入力・追加画面
class InputTagDisplay extends StatelessWidget {
  const InputTagDisplay({
    super.key,
    required this.title,
    required this.tagList,
    required this.onTapBack,
  });
  final String title;
  final List<ColorLabelInfo> tagList;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    final scrollController = ScrollController();

    return BlocBuilder<InputTagDisplayBloc, InputTagDisplayState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is InputTagDisplayInitialState) {
          context.read<InputTagDisplayBloc>().add(
                InputTagDisplayInit(tagList: tagList),
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
                  final state = context.read<InputTagDisplayBloc>().state
                      as InputTagDisplayGetInfoState;
                  context.read<InputTagDisplayBloc>().add(FormattedTagList());
                  onTapBack(state.formattedTagList);
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
                context.read<InputTagDisplayBloc>().add(AddTag());
                context
                    .read<InputTagDisplayBloc>()
                    .add(MoveLast(scrollController: scrollController));
              },
            ),
            body: Padding(
              padding: _kContentPadding,
              child: (state as InputTagDisplayGetInfoState).tagList.isEmpty
                  ? const EmptyDisplay(
                      message: _kTagListEmptyTxt,
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                for (final info
                                    in (state as InputTagDisplayGetInfoState)
                                        .tagList)
                                  LinkListItem(
                                    id: info.id,
                                    inputValue: info.labelName,
                                    hintText: _kTagHintTxt,
                                    linkHintText: _kColorHintText,
                                    linkedWidgets: [
                                      ColorBox(
                                        color: info.themeColor,
                                      ),
                                    ],
                                    onTextSubmitted: (value, id) => context
                                        .read<InputTagDisplayBloc>()
                                        .add(UpdateInputValue(
                                            id: id, inputValue: value)),
                                    onTap: (id) => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SelectColorDisplay(
                                            title: _kColorTxt,
                                            selectedColorInfo: getColorInfoById(
                                              id: getIdByColor(
                                                  color: info.themeColor),
                                            ),
                                            onTap: (id) {},
                                            onTapBackIcon: (colorInfo) {
                                              context
                                                  .read<InputTagDisplayBloc>()
                                                  .add(
                                                    UpdateLinkColor(
                                                        id: info.id,
                                                        themeColor: colorInfo
                                                            .themeColor),
                                                  );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    onDeleteItem: (inputValue) {
                                      context
                                          .read<InputTagDisplayBloc>()
                                          .add(DeleteTag(id: info.id));
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
    );
  }
}
