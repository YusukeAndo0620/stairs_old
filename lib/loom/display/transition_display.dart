import 'package:flutter/material.dart' hide Theme;
import 'package:stairs/main.dart'; // main.dartに定義された、routeObserverをインポートするため

/// 画面遷移がある画面で使用
abstract class TransitionPage extends StatefulWidget {
  const TransitionPage({Key? key}) : super(key: key);

  Widget buildMainContent(BuildContext context);
  VoidCallback onPopPage();

  @override
  TransitionPageState createState() => TransitionPageState();
}

class TransitionPageState extends State<TransitionPage> with RouteAware {
  @override
  void didChangeDependencies() {
    // 遷移時に呼ばれる関数
    // routeObserverに自身を設定
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    // routeObserverから自身を外す
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    debugPrint("popされて、この画面に戻ってきました！");
  }

  @override
  void didPush() {
    debugPrint("pushされてきました、この画面にやってきました！");
  }

  @override
  void didPop() {
    debugPrint("この画面がpopされました");
    widget.onPopPage();
  }

  @override
  void didPushNext() {
    debugPrint("この画面からpushして違う画面に遷移しました！");
  }

  @override
  Widget build(BuildContext context) => widget.buildMainContent(context);
}
