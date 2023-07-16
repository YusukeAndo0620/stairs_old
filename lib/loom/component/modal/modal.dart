import 'package:flutter/material.dart' hide Theme;
import '../../theme.dart';

const _kModalPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0);

abstract class Modal extends StatelessWidget {
  const Modal({
    super.key,
  });

  Widget buildLeadingContent(BuildContext context);
  Widget buildTrailingContent(BuildContext context);
  Widget buildMainContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
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
              buildLeadingContent(context),
              buildTrailingContent(context),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: buildMainContent(context),
            ),
          ),
        ],
      ),
    );
  }
}
