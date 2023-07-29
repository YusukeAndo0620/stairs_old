import 'package:provider/single_child_widget.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:provider/provider.dart';

import '../theme.dart';

const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

abstract class InputDisplay extends StatelessWidget {
  const InputDisplay({
    super.key,
    required this.title,
  });
  final String title;

  List<SingleChildWidget> getPageProviders();
  Widget buildLeadingContent(BuildContext context);
  Widget buildMainContent(BuildContext context);
  Widget? buildTrailingContent(BuildContext context);

  // If use floating btn, set this event
  VoidCallback? onTapAddingBtn(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return getPageProviders().isEmpty
        ? _InputDisplayContent(
            title: title,
            leadingContent: buildLeadingContent(context),
            mainContent: buildMainContent(context),
            trailContent: buildTrailingContent(context),
            onTapAddingBtn: onTapAddingBtn(context) == null
                ? null
                : () => onTapAddingBtn(context),
          )
        : MultiProvider(
            key: ValueKey<int>(buildMainContent(context).hashCode),
            providers: getPageProviders(),
            child: _InputDisplayContent(
              title: title,
              leadingContent: buildLeadingContent(context),
              mainContent: buildMainContent(context),
              trailContent: buildTrailingContent(context),
              onTapAddingBtn: onTapAddingBtn(context) == null
                  ? null
                  : () => onTapAddingBtn(context),
            ),
          );
  }
}

class _InputDisplayContent extends StatelessWidget {
  const _InputDisplayContent({
    super.key,
    required this.title,
    required this.leadingContent,
    required this.mainContent,
    this.trailContent,
    this.onTapAddingBtn,
  });
  final String title;
  final Widget leadingContent;
  final Widget mainContent;
  final Widget? trailContent;
  final VoidCallback? onTapAddingBtn;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: leadingContent,
        actions: trailContent != null ? [trailContent!] : null,
        backgroundColor: theme.colorBgLayer1,
        title: Text(
          title,
          style: theme.textStyleHeading,
        ),
      ),
      body: Padding(
        padding: _kContentPadding,
        child: mainContent,
      ),
      floatingActionButton: onTapAddingBtn != null
          ? FloatingActionButton(
              child: Icon(theme.icons.add),
              onPressed: () => onTapAddingBtn!,
            )
          : null,
    );
  }
}
