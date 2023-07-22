import 'package:flutter/material.dart' hide Theme;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../theme.dart';

const _kModalPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0);

abstract class Modal extends StatelessWidget {
  const Modal({
    super.key,
    this.height,
  });
  String? get title;
  final double? height;

  List<SingleChildWidget> getPageProviders();
  Widget buildLeadingContent(BuildContext context);
  Widget? buildTrailingContent(BuildContext context);
  Widget buildMainContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return getPageProviders().isEmpty
        ? ModalContent(
            title: title,
            height: height,
            leadingContent: buildLeadingContent(context),
            mainContent: buildMainContent(context),
            trailContent: buildTrailingContent(context),
          )
        : MultiProvider(
            key: ValueKey<int>(buildMainContent(context).hashCode),
            providers: getPageProviders(),
            child: ModalContent(
              title: title,
              height: height,
              leadingContent: buildLeadingContent(context),
              mainContent: buildMainContent(context),
              trailContent: buildTrailingContent(context),
            ));
  }
}

class ModalContent extends StatelessWidget {
  const ModalContent({
    super.key,
    this.title,
    this.height,
    required this.leadingContent,
    required this.mainContent,
    this.trailContent,
  });
  final String? title;
  final double? height;
  final Widget leadingContent;
  final Widget mainContent;
  final Widget? trailContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      padding: _kModalPadding,
      decoration: BoxDecoration(
        color: theme.colorBgLayer1,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingContent,
              if (title != null)
                Text(
                  title!,
                  style: theme.textStyleTitle,
                ),
              trailContent != null
                  ? trailContent!
                  : const SizedBox(
                      width: 60.0,
                    )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: mainContent,
            ),
          ),
        ],
      ),
    );
  }
}
