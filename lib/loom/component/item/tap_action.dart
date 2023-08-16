import 'package:flutter/material.dart';

const _kAnimatedDuration = Duration(milliseconds: 100);

///タップ時にアニメーションがあるクラスはこのクラスを使用
class TapAction extends StatefulWidget {
  const TapAction({
    super.key,
    this.width,
    this.minWidth,
    required this.widget,
    required this.tappedColor,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius,
    required this.onTap,
  });
  final double? width;
  final double? minWidth;
  final Widget widget;
  final Color tappedColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => _TappedActionState();
}

class _TappedActionState extends State<TapAction> {
  bool _pressed = false;
  final itemKey = GlobalKey<_TappedActionState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: itemKey,
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding,
        duration: _kAnimatedDuration,
        constraints: BoxConstraints(minWidth: widget.minWidth ?? 0.0),
        decoration: BoxDecoration(
          color: _pressed ? widget.tappedColor.withOpacity(0.7) : null,
          border: widget.border,
          borderRadius: widget.borderRadius,
        ),
        child: widget.widget,
      ),
    );
  }
}
