import 'package:flutter/material.dart' hide Theme;
import 'loom/theme.dart';
import 'app/enum/screen_id.dart';

const _kFooterButtons = [
  _FooterInfo(
    screenId: ScreenId.board,
    title: 'ボード',
  ),
  _FooterInfo(
    screenId: ScreenId.status,
    title: 'ステータス',
  ),
  _FooterInfo(
    screenId: ScreenId.resume,
    title: '経歴書',
  ),
  _FooterInfo(
    screenId: ScreenId.account,
    title: 'アカウント',
  ),
];

const _kAppBarTitle = 'Stairs';

abstract class DisplayContents extends StatelessWidget {
  const DisplayContents({super.key});

  Widget buildContent(BuildContext context);
  ScreenId get selectScreenId => ScreenId.board;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorBgLayer1,
        title: Text(
          _kAppBarTitle,
          style: theme.textStyleHeading,
        ),
      ),
      body: buildContent(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _kFooterButtons.indexOf(_kFooterButtons
            .firstWhere((element) => element.screenId == selectScreenId)),
        showUnselectedLabels: true,
        selectedItemColor: theme.colorPrimary,
        unselectedItemColor: theme.colorFgDisabled,
        items: [
          for (final footerInfo in _kFooterButtons)
            BottomNavigationBarItem(
              icon: Icon(footerInfo.screenId.iconData(themeData: theme)),
              activeIcon: Icon(footerInfo.screenId.iconData(themeData: theme)),
              label: footerInfo.title,
              tooltip: footerInfo.title,
            ),
        ],
      ),
    );
  }
}

class _FooterInfo {
  const _FooterInfo({
    required this.screenId,
    required this.title,
  });
  final ScreenId screenId;
  final String title;
}
