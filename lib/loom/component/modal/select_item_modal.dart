import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme.dart';

import '../../../model/model.dart';
import 'select_item_modal_bloc.dart';
import '../../component/modal/modal.dart';

const _kListEmptyTxt = '選択可能なタグがありません。\n ボード設定 > ラベルより、ラベルを追加してください。';
const _kBorderWidth = 1.0;
const _kCheckIconSize = 20.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class SelectItemModal extends Modal {
  const SelectItemModal({
    super.key,
    required this.id,
    required this.title,
    super.height,
    required this.labelList,
    required this.selectedLabelList,
    required this.onTapListItem,
  });
  final int id;
  @override
  final String title;
  final List<LabelInfo> labelList;
  final List<LabelInfo> selectedLabelList;
  final Function(List<LabelInfo>) onTapListItem;

  @override
  Widget buildLeadingContent(BuildContext context) {
    final theme = Theme.of(context);
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
    required this.onTapListItem,
  });
  final String title;
  final List<CheckLabelInfo> checkList;
  final Function(List<LabelInfo>) onTapListItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                _Content(
                  key: key,
                  checkList: checkList,
                  onTapListItem: (_) => onTapListItem([]),
                )
              ],
            ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
    required this.checkList,
    required this.onTapListItem,
  });
  final List<CheckLabelInfo> checkList;
  final Function(List<LabelInfo>) onTapListItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final info in checkList)
          GestureDetector(
            onTap: () async {
              await _onTap(context: context, tappedItem: info);
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
              title: Padding(
                padding: _kContentPadding,
                child: Text(
                  info.labelName,
                  style: theme.textStyleBody.copyWith(color: info.themeColor),
                  overflow: TextOverflow.ellipsis,
                ),
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

  Future<void> _onTap(
      {required BuildContext context,
      required CheckLabelInfo tappedItem}) async {
    context
        .read<SelectItemModalBloc>()
        .add(SelectItemTapListItem(tappedItem: tappedItem));
  }
}
