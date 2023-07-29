import 'package:flutter/material.dart' hide Theme;
import '../theme.dart';

const _kContentPadding = EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

class InputTooltipDisplay extends StatelessWidget {
  const InputTooltipDisplay({
    super.key,
    required this.title,
    required this.firstLabel,
    required this.secondLabel,
    required this.onTapBack,
  });
  final String title;
  final String firstLabel;
  final String? secondLabel;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return _Frame(
      title: title,
      onTapBack: onTapBack,
    );
  }

  void _onTapBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    super.key,
    required this.title,
    required this.onTapBack,
  });
  final String title;
  final Function(Object) onTapBack;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
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
      body: const Padding(
        padding: _kContentPadding,
        child: Column(
          children: [],
        ),
      ),
    );
  }

  void _onTapBack(BuildContext context) {
    Navigator.pop(context);
  }
}
