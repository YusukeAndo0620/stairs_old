import 'dart:ui';

import 'package:flutter/material.dart' hide Theme;
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'package:meta/meta.dart';
import 'package:provider/single_child_widget.dart';
import 'loom/theme.dart';

const _kAppName = 'Stairs';

final _scaffoldKey = GlobalKey();
BuildContext get scaffoldContext {
  return _scaffoldKey.currentContext!;
}

void main() {
  runApp(const AppLaunch(app: App()));
}

@sealed
class AppLaunch extends StatefulWidget {
  const AppLaunch({super.key, required this.app});

  final App app;

  @override
  State<StatefulWidget> createState() => _AppLaunchState();
}

class _AppLaunchState extends State<AppLaunch> {
  Widget? _cache;
  late BuildContext _mainContext;

  @override
  void initState() {
    super.initState();
    widget.app.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cache = null;
  }

  @override
  void didUpdateWidget(covariant AppLaunch oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.app == oldWidget.app, 'App Launch is changed.');
  }

  @override
  void dispose() {
    widget.app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _cache ?? _themeBuilder(context);
  }

  List<SingleChildWidget> get _providers {
    final func = <SingleChildWidget>[];
    widget.app.addProvides(func);
    final providers = [...func];
    return providers;
  }

  Widget _buildMainContents(BuildContext context) {
    _mainContext = context;
    return ScrollConfiguration(
      behavior: const ScrollBehavior()
          .copyWith(dragDevices: {...PointerDeviceKind.values}),
      child: MultiProvider(
        providers: _providers,
        child: MaterialApp(
          title: _kAppName,
          home: widget.app.buildMainContents(context),
        ),
      ),
    );
  }

  Widget _themeBuilder(BuildContext context) {
    return Theme.loomTheme(
        key: _scaffoldKey, child: _buildMainContents(context));
  }
}
