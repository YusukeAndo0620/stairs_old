import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme.dart';

import '../../model/model.dart';
import '../component/input/link_tag_input.dart';
import '../display/input_link_tag_display_bloc.dart';

const _kHintTxt = '言語名を追加';
const _kSpaceHeight = 120.0;
const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class InputLinkTagDisplay extends StatelessWidget {
  const InputLinkTagDisplay({
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
  final VoidCallback onTap;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InputLinkTagDisplayBloc(),
      child: BlocBuilder<InputLinkTagDisplayBloc, InputLinkTagDisplayState>(
        builder: (context, state) {
          if (state is InputLinkTagDisplayInitialState) {
            context
                .read<InputLinkTagDisplayBloc>()
                .add(Init(linkTagList: linkTagList));
            return const SizedBox.shrink();
          } else if (state is InputLinkTagDisplayGetInfoState) {
            return _Frame(
              key: key,
              title: title,
              linkTagList: state.linkTagList,
              onTap: onTap,
              onTapBack: onTapBack,
              onTextSubmitted: onTextSubmitted,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
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
  final VoidCallback onTap;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            theme.icons.back,
            color: theme.colorFgDefault,
          ),
          onPressed: () => _onTapBack(context),
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
            _Content(
              key: key,
              linkTagList: linkTagList,
              scrollController: scrollController,
              onTap: onTap,
              onTextSubmitted: onTextSubmitted,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(theme.icons.add),
        onPressed: () {
          context.read<InputLinkTagDisplayBloc>().add(AddInputLinkTag());
          context
              .read<InputLinkTagDisplayBloc>()
              .add(MoveLast(scrollController: scrollController));
        },
      ),
    );
  }

  void _onTapBack(BuildContext context) {
    final state = context.read<InputLinkTagDisplayBloc>().state;
    if (state is InputLinkTagDisplayGetInfoState) {
      onTapBack(state.linkTagList);
    }
    Navigator.pop(context);
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            for (final info in linkTagList)
              LinkTagInput(
                id: info.id,
                inputValue: info.inputValue,
                hintText: _kHintTxt,
                linkedValue: info.linkLabel,
                onTextSubmitted: (value, id) => context
                    .read<InputLinkTagDisplayBloc>()
                    .add(EditInputValue(id: id, inputValue: value)),
                onTap: onTap,
                onDeleteItem: (inputValue) {
                  context.read<InputLinkTagDisplayBloc>().add(
                      DeleteInputLinkTag(id: info.id, inputValue: inputValue));
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
}
