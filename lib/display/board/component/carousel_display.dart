import 'package:stairs/loom/loom_package.dart';

import 'dart:async';
import 'carousel_display_bloc.dart';

const _kCircleWidth = 12.0;
const _kCircleHeight = 12.0;

class CarouselDisplay extends StatelessWidget {
  const CarouselDisplay({
    Key? key,
    required this.pages,
    this.indicatorColor,
    this.indicatorAlignment,
  }) : super(key: key);
  final List<Widget> pages;
  final Color? indicatorColor;
  final Alignment? indicatorAlignment;

  /// Used to trigger an event when the widget has been built
  Future<bool> initializeController() {
    Completer<bool> completer = Completer<bool>();

    /// Callback called after widget has been fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete(true);
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarouselDisplayBloc, CarouselDisplayState>(
      builder: (context, state) {
        final theme = LoomTheme.of(context);
        final color = indicatorColor ?? theme.colorDisabled;
        return Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            PageView(
              controller: state.pageController,
              onPageChanged: (index) => context
                  .read<CarouselDisplayBloc>()
                  .add(CarouselDisplayUpdatePageIndex(pageIndex: index)),
              children: pages,
            ),
            FutureBuilder(
              future: initializeController(),
              builder: (BuildContext context, AsyncSnapshot<void> snap) {
                //If we do not have data as we wait for the future to complete,
                //show any widget, eg. empty Container
                if (!snap.hasData) {
                  return Container();
                }
                return Align(
                  alignment: indicatorAlignment ??
                      const Alignment(0, 0.95), // 相対的な表示位置を決める。
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          width: _kCircleWidth,
                          height: _kCircleHeight,
                          decoration: BoxDecoration(
                            color: index == state.currentPage ? color : null,
                            shape: BoxShape.circle,
                            border: Border.all(color: color),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
