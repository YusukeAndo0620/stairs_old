import 'package:provider/single_child_widget.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppFunction {
  const AppFunction();

  void addProvides(List<SingleChildWidget> globalProvides);
  Widget buildMainContents(BuildContext context);
  void init() {}
  void dispose() {}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFunction && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
