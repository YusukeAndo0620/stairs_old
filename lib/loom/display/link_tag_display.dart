import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme.dart';

import '../../model/model.dart';
import '../component/list_item/link_list_item.dart';
import '../component/label_tip.dart';
import 'link_tag_display_bloc.dart';

const _kHintTxt = '言語名を追加';
const _kTagHintText = 'タグを追加';
const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

/// タグ紐付け画面
class LinkTagDisplay extends StatelessWidget {
  const LinkTagDisplay({
    super.key,
    required this.title,
    required this.linkTagList,
    required this.onTextSubmitted,
    required this.onTap,
    required this.onTapBack,
  });
  final String title;
  final List<LinkTagInfo> linkTagList;
  final Function(String) onTextSubmitted;
  final Function(String) onTap;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LinkTagDisplayBloc, LinkTagDisplayState>(
      builder: (context, state) {
        if (state is LinkTagDisplayInitialState) {
          context
              .read<LinkTagDisplayBloc>()
              .add(LinkTagDisplayInit(linkTagList: linkTagList));
          return const SizedBox.shrink();
        } else if (state is LinkTagDisplayGetInfoState) {
          return _Frame(
            key: key,
            title: title,
            linkTagList: state.linkTagList,
            onTap: (id) => onTap(id),
            onTapBack: onTapBack,
            onTextSubmitted: onTextSubmitted,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    super.key,
    required this.title,
    required this.linkTagList,
    required this.onTextSubmitted,
    required this.onTap,
    required this.onTapBack,
  });
  final String title;
  final List<LinkTagInfo> linkTagList;
  final Function(String) onTextSubmitted;
  final Function(String) onTap;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    final scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            theme.icons.back,
            color: theme.colorFgDefault,
          ),
          onPressed: () => _onTapBack(context: context, isMovingBack: true),
        ),
        backgroundColor: theme.colorBgLayer1,
        title: Text(
          title,
          style: theme.textStyleHeading,
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 25) {
            _onTapBack(context: context, isMovingBack: true);
          }
        },
        child: Padding(
          padding: _kContentPadding,
          child: Column(
            children: [
              _Content(
                key: key,
                linkTagList: linkTagList,
                scrollController: scrollController,
                onTap: (id) => onTap(id),
                onTextSubmitted: onTextSubmitted,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(theme.icons.add),
        onPressed: () {
          context.read<LinkTagDisplayBloc>().add(AddLinkTag());
          context
              .read<LinkTagDisplayBloc>()
              .add(MoveLast(scrollController: scrollController));
        },
      ),
    );
  }

  void _onTapBack({required BuildContext context, required bool isMovingBack}) {
    final state = context.read<LinkTagDisplayBloc>().state;
    if (state is LinkTagDisplayGetInfoState) {
      onTapBack(state.linkTagList);
    }
    if (isMovingBack) Navigator.pop(context);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
    required this.linkTagList,
    required this.scrollController,
    required this.onTextSubmitted,
    required this.onTap,
  });
  final List<LinkTagInfo> linkTagList;
  final ScrollController scrollController;
  final Function(String) onTextSubmitted;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            for (final info in linkTagList)
              LinkListItem(
                id: info.id,
                inputValue: info.inputValue,
                hintText: _kHintTxt,
                linkHintText: _kTagHintText,
                linkedWidgets: getLinkValueList(
                  context: context,
                  linkedValue: info.linkLabelList,
                ),
                onTextSubmitted: (value, id) => context
                    .read<LinkTagDisplayBloc>()
                    .add(UpdateInputValue(id: id, inputValue: value)),
                onTap: (id) => onTap(id),
                onDeleteItem: (inputValue) {
                  context
                      .read<LinkTagDisplayBloc>()
                      .add(DeleteLinkTag(id: info.id));
                },
              ),
            const SizedBox(
              height: _kSpaceHeight,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getLinkValueList({
    required BuildContext context,
    required List<ColorLabelInfo> linkedValue,
  }) {
    return linkedValue
        .map((item) => LabelTip(
              label: item.labelName,
              themeColor: item.themeColor,
            ))
        .toList();
  }
}
