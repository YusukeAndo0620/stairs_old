import 'package:flutter/material.dart';
import '../../../loom/theme.dart';

const _kCircleWidth = 12.0;
const _kCircleHeight = 12.0;

class CarouselDisplay extends StatefulWidget {
  const CarouselDisplay({
    Key? key,
    required this.pages,
    this.indicatorColor,
    this.indicatorAlignment,
  }) : super(key: key);
  final List<Widget> pages;
  final Color? indicatorColor;
  final Alignment? indicatorAlignment;

  @override
  State<CarouselDisplay> createState() => _CarouselState();
}

class _CarouselState extends State<CarouselDisplay> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    final pageController =
        PageController(initialPage: currentIndex, viewportFraction: 0.8);

    final pages = widget.pages;
    final pageLength = pages.length;
    final color = widget.indicatorColor ?? theme.colorDisabled;
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          children: widget.pages,
        ),
        Align(
          alignment: widget.indicatorAlignment ??
              const Alignment(0, 0.95), // 相対的な表示位置を決める。
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageLength,
              (index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: _kCircleWidth,
                  height: _kCircleHeight,
                  decoration: BoxDecoration(
                    color: index == currentIndex ? color : null,
                    shape: BoxShape.circle,
                    border: Border.all(color: color),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
