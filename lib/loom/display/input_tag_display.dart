import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart';
import '../../model/model.dart';
import 'input_tag_display_bloc.dart';
import '../component/list_item/link_list_item.dart';
import '../component/item/color_box.dart';
import 'select_color_display.dart';

const _kTagHintTxt = 'タグ名を追加';
const _kColorHintText = '色を選択';
const _kColorTxt = '色';

const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

///タグ入力・追加画面
class InputTagDisplay extends StatelessWidget {
  const InputTagDisplay({
    super.key,
    required this.title,
    required this.linkTagList,
    required this.onTextSubmitted,
    required this.onTapBack,
  });
  final String title;
  final List<ColorLabelInfo> linkTagList;
  final Function(String) onTextSubmitted;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<InputTagDisplayBloc, InputTagDisplayState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is InputTagDisplayInitialState) {
          context.read<InputTagDisplayBloc>().add(
                InputTagDisplayInit(linkTagList: linkTagList),
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
                  onTapBack(state.linkTagList);
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
                              in (state as InputTagDisplayGetInfoState)
                                  .linkTagList)
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
                                        context.read<InputTagDisplayBloc>().add(
                                              UpdateLinkColor(
                                                  id: info.id,
                                                  themeColor:
                                                      colorInfo.themeColor),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ),
                              onDeleteItem: (inputValue) {
                                context
                                    .read<InputTagDisplayBloc>()
                                    .add(DeleteLinkTag(id: info.id));
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
