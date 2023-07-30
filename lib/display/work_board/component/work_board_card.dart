import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../loom/theme.dart';
import '../../../model/model.dart';

const _kBorderWidth = 1.0;
const _kWorkBoardAddBtnSpace = 16.0;
const _kWorkBoardAddBtnTxt = 'カードを追加';

const _kContentPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);
const _kContentMargin = EdgeInsets.only(
  top: 24,
  bottom: 48.0,
  left: 16.0,
  right: 40.0,
);

///ワークボードカード
class WorkBoardCard extends StatelessWidget {
  const WorkBoardCard({
    super.key,
    required this.title,
    required this.themeColor,
    required this.workBoardItemList,
  });
  final String title;
  final Color themeColor;
  final List<WorkBoardItemInfo> workBoardItemList;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Container(
      padding: _kContentPadding,
      margin: _kContentMargin,
      decoration: BoxDecoration(
        color: theme.colorFgDefaultWhite,
        border: Border.all(
          color: theme.colorFgDisabled,
          width: _kBorderWidth,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(
            key: key,
            title: title,
            listSize: 2,
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          ),
          _AddingItemButton(
            key: key,
            themeColor: themeColor,
            onTapAddingBtn: () {},
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.title,
    required this.listSize,
  });
  final String title;
  final int listSize;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Container(
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: theme.colorFgDefaultWhite,
        border: Border(
          bottom: BorderSide(
            color: theme.colorFgDisabled,
            width: _kBorderWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textStyleSubHeading,
          ),
          Text('${listSize.toString()} 件'),
        ],
      ),
    );
  }
}

class _AddingItemButton extends StatelessWidget {
  const _AddingItemButton({
    super.key,
    required this.themeColor,
    required this.onTapAddingBtn,
  });
  final Color themeColor;
  final VoidCallback onTapAddingBtn;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Container(
      padding: _kContentPadding,
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.3),
        border: Border.all(
          color: theme.colorFgDisabled,
          width: _kBorderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            theme.icons.add,
            color: themeColor,
          ),
          const SizedBox(
            width: _kWorkBoardAddBtnSpace,
          ),
          Text(
            _kWorkBoardAddBtnTxt,
            style: theme.textStyleBody,
          ),
        ],
      ),
    );
  }
}
