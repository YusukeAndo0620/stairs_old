import 'package:flutter/material.dart' hide Theme, Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:badges/badges.dart';

import '../../theme.dart';
import '../../../model/model.dart';
import '../../component/modal/modal.dart';
import '../item/color_box.dart';
import 'select_item_modal_bloc.dart';

const _kListEmptyTxt = '選択可能なタグがありません。\n ボード設定 > ラベルより、ラベルを追加してください。';
const _kListItemSpace = 16.0;
const _kBorderWidth = 1.0;
const _kCheckIconSize = 20.0;
const _kTileCheckIconSize = 14.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);
const _kContentMargin = EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0);

enum DisplayType { list, tile }

/// アイテム選択リスト画面(カラーボックス+タイトル)
class SelectItemModal extends Modal {
  const SelectItemModal({
    super.key,
    required this.id,
    this.type = DisplayType.list,
    required this.title,
    super.height,
    required this.labelList,
    required this.selectedLabelList,
    required this.onTapListItem,
  });
  final String id;
  final DisplayType type;
  @override
  final String title;
  final List<ColorLabelInfo> labelList;
  final List<ColorLabelInfo> selectedLabelList;
  final Function(List<ColorLabelInfo>) onTapListItem;

  @override
  List<SingleChildWidget> getPageProviders() {
    return [];
  }

  @override
  Widget buildLeadingContent(BuildContext context) {
    final theme = LoomTheme.of(context);
    return IconButton(
      icon: Icon(
        theme.icons.back,
        color: theme.colorFgDefault,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget? buildTrailingContent(BuildContext context) => null;

  @override
  Widget buildMainContent(BuildContext context) {
    return BlocBuilder<SelectItemModalBloc, SelectItemModalState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is SelectItemInitialState ||
            (state as SelectItemGetCheckListState).id != id) {
          context.read<SelectItemModalBloc>().add(SelectItemInit(
              id: id,
              labelList: labelList,
              selectedLabelList: selectedLabelList));
          return const SizedBox.shrink();
        } else {
          return _Frame(
            key: key,
            title: title,
            type: type,
            checkList: state.checkList,
            onTapListItem: (_) => onTapListItem((context
                    .read<SelectItemModalBloc>()
                    .state as SelectItemGetCheckListState)
                .selectedList),
          );
        }
      },
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    super.key,
    required this.title,
    required this.checkList,
    required this.type,
    required this.onTapListItem,
  });
  final String title;
  final List<CheckLabelInfo> checkList;
  final DisplayType type;
  final Function(List<ColorLabelInfo>) onTapListItem;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Container(
      color: theme.colorBgLayer1,
      padding: _kContentPadding,
      child: checkList.isEmpty
          ? Container(
              color: theme.colorBgLayer1,
              child: Text(
                _kListEmptyTxt,
                style: theme.textStyleBody,
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                type == DisplayType.list
                    ? _ListContent(
                        key: key,
                        checkList: checkList,
                        onTapListItem: (_) => onTapListItem([]),
                      )
                    : _TileContent(
                        key: key,
                        checkList: checkList,
                        onTapListItem: (_) => onTapListItem([]),
                      ),
              ],
            ),
    );
  }
}

/// リスト形式
class _ListContent extends StatelessWidget {
  const _ListContent({
    super.key,
    required this.checkList,
    required this.onTapListItem,
  });
  final List<CheckLabelInfo> checkList;
  final Function(List<ColorLabelInfo>) onTapListItem;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Column(
      children: [
        for (final info in checkList)
          GestureDetector(
            onTap: () {
              _onTap(context: context, tappedItem: info);
              onTapListItem([]);
            },
            child: ListTile(
              leading: info.checked
                  ? IconButton(
                      icon: Icon(
                        theme.icons.done,
                        color: theme.colorPrimary,
                      ),
                      iconSize: _kCheckIconSize,
                      onPressed: () {},
                    )
                  : const SizedBox(
                      width: _kCheckIconSize,
                    ),
              title: _ListItem(
                key: key,
                info: info,
              ),
              shape: Border(
                bottom: BorderSide(
                  color: theme.colorFgDefault,
                  width: _kBorderWidth,
                ),
              ),
            ),
          )
      ],
    );
  }
}

/// タイル形式
class _TileContent extends StatelessWidget {
  const _TileContent({
    super.key,
    required this.checkList,
    required this.onTapListItem,
  });
  final List<CheckLabelInfo> checkList;
  final Function(List<ColorLabelInfo>) onTapListItem;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Wrap(
      children: [
        for (final info in checkList)
          GestureDetector(
            onTap: () {
              _onTap(context: context, tappedItem: info);
              onTapListItem([]);
            },
            child: Badge(
              position: BadgePosition.topEnd(top: 10, end: 0),
              badgeAnimation:
                  const BadgeAnimation.scale(curve: Curves.bounceOut),
              badgeStyle: BadgeStyle(
                  shape: BadgeShape.square,
                  borderSide: info.checked
                      ? const BorderSide(width: _kBorderWidth)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                  badgeColor: info.checked
                      ? theme.colorBgLayer1
                      : theme.colorBgLayer1.withOpacity(0.0)),
              badgeContent: info.checked
                  ? Icon(
                      theme.icons.done,
                      color: theme.colorPrimary,
                      size: _kTileCheckIconSize,
                    )
                  : null,
              child: Container(
                padding: _kContentPadding,
                margin: _kContentMargin,
                decoration: BoxDecoration(
                  color: info.checked ? info.themeColor.withOpacity(0.7) : null,
                  border: Border.all(
                    color: info.themeColor,
                    width: _kBorderWidth,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  info.labelName,
                  style: theme.textStyleBody,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    super.key,
    required this.info,
  });
  final CheckLabelInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Padding(
      padding: _kContentPadding,
      child: Row(
        children: [
          ColorBox(
            color: info.themeColor,
            size: _kCheckIconSize,
          ),
          const SizedBox(width: _kListItemSpace),
          Text(
            info.labelName,
            style: theme.textStyleBody,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

void _onTap(
    {required BuildContext context, required CheckLabelInfo tappedItem}) {
  context
      .read<SelectItemModalBloc>()
      .add(SelectItemTapListItem(tappedItem: tappedItem));
}
