import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';

// Event
abstract class CarouselDisplayEvent {
  const CarouselDisplayEvent();
}

class CarouselDisplayInit extends CarouselDisplayEvent {
  const CarouselDisplayInit({required this.maxPage});
  final int maxPage;
}

class CarouselDisplayUpdatePageIndex extends CarouselDisplayEvent {
  const CarouselDisplayUpdatePageIndex({required this.pageIndex});
  final int pageIndex;
}

class CarouselDisplayMoveNextPage extends CarouselDisplayEvent {
  const CarouselDisplayMoveNextPage();
}

class CarouselDisplayMovePreviousPage extends CarouselDisplayEvent {
  const CarouselDisplayMovePreviousPage();
}

class CarouselDisplayMoveLastPage extends CarouselDisplayEvent {
  const CarouselDisplayMoveLastPage();
}

class _CarouselDisplaySetReady extends CarouselDisplayEvent {
  const _CarouselDisplaySetReady();
}

// State
@immutable
class CarouselDisplayState extends Equatable {
  const CarouselDisplayState({
    required this.isReady,
    required this.maxPage,
    required this.pageController,
  });

  final bool isReady;
  final int maxPage;
  final PageController pageController;

  @override
  List<Object?> get props => [isReady, maxPage, pageController];

  CarouselDisplayState copyWith({
    bool? isReady,
    int? maxPage,
    PageController? pageController,
  }) =>
      CarouselDisplayState(
        isReady: isReady ?? this.isReady,
        maxPage: maxPage ?? this.maxPage,
        pageController: pageController ?? this.pageController,
      );

  int get currentPage {
    if (pageController.positions.isEmpty || pageController.page == null) {
      return 0;
    }
    return pageController.page!.toInt();
    // return currentPage == maxPage ? 0 : currentPage;
  }
}

// Bloc
class CarouselDisplayBloc
    extends Bloc<CarouselDisplayEvent, CarouselDisplayState> {
  CarouselDisplayBloc()
      : super(
          CarouselDisplayState(
              isReady: true,
              maxPage: 1,
              pageController:
                  PageController(initialPage: 0, viewportFraction: 0.8)),
        ) {
    on<CarouselDisplayInit>(_onInit);
    on<CarouselDisplayUpdatePageIndex>(_onUpdatePageIndex);
    on<CarouselDisplayMoveNextPage>(_onMoveNextPage);
    on<CarouselDisplayMovePreviousPage>(_onMovePreviousPage);
    on<CarouselDisplayMoveLastPage>(_onMoveLastPage);
    on<_CarouselDisplaySetReady>(_onSetReady);
  }

  void _onInit(CarouselDisplayInit event, Emitter<CarouselDisplayState> emit) {
    emit(
      state.copyWith(
        maxPage: event.maxPage,
        pageController: PageController(
            initialPage: state.currentPage, viewportFraction: 0.8),
      ),
    );
  }

  void _onUpdatePageIndex(CarouselDisplayUpdatePageIndex event,
      Emitter<CarouselDisplayState> emit) {
    emit(
      state.copyWith(
        pageController:
            PageController(initialPage: event.pageIndex, viewportFraction: 0.8),
      ),
    );
  }

  Future<void> _onMoveNextPage(CarouselDisplayMoveNextPage event,
      Emitter<CarouselDisplayState> emit) async {
    if (state.pageController.positions.isEmpty) return;
    if (state.pageController.page!.toInt() + 1 <= state.maxPage &&
        state.isReady) {
      emit(state.copyWith(isReady: false));

      state.pageController.animateToPage(
        state.pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      add(const _CarouselDisplaySetReady());
    }
  }

  Future<void> _onMovePreviousPage(CarouselDisplayMovePreviousPage event,
      Emitter<CarouselDisplayState> emit) async {
    if (state.pageController.positions.isEmpty && !state.isReady) return;
    emit(state.copyWith(isReady: false));

    state.pageController.animateToPage(
      state.pageController.page!.toInt() - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    add(const _CarouselDisplaySetReady());
  }

  Future<void> _onMoveLastPage(CarouselDisplayMoveLastPage event,
      Emitter<CarouselDisplayState> emit) async {
    if (state.pageController.positions.isEmpty) return;
    if (state.pageController.page!.toInt() != state.maxPage && state.isReady) {
      emit(state.copyWith(isReady: false));

      state.pageController.animateToPage(
        state.maxPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      add(const _CarouselDisplaySetReady());
    }
  }

  Future<void> _onSetReady(_CarouselDisplaySetReady event,
      Emitter<CarouselDisplayState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500))
        .then((value) => emit(state.copyWith(isReady: true)));
  }
}
