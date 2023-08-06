import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

// State
@immutable
class CarouselDisplayState extends Equatable {
  const CarouselDisplayState({
    required this.maxPage,
    required this.pageController,
  });

  final int maxPage;
  final PageController pageController;

  @override
  List<Object?> get props => [maxPage, pageController];

  CarouselDisplayState copyWith({
    int? maxPage,
    PageController? pageController,
  }) =>
      CarouselDisplayState(
        maxPage: maxPage ?? this.maxPage,
        pageController: pageController ?? this.pageController,
      );

  int get currentPage => pageController.page!.toInt();
}

// Bloc
class CarouselDisplayBloc
    extends Bloc<CarouselDisplayEvent, CarouselDisplayState> {
  CarouselDisplayBloc()
      : super(
          CarouselDisplayState(
              maxPage: 1,
              pageController:
                  PageController(initialPage: 0, viewportFraction: 0.8)),
        ) {
    on<CarouselDisplayInit>(_onInit);
    on<CarouselDisplayUpdatePageIndex>(_onUpdatePageIndex);
    on<CarouselDisplayMoveNextPage>(_onMoveNextPage);
    on<CarouselDisplayMovePreviousPage>(_onMovePreviousPage);
  }

  void _onInit(CarouselDisplayInit event, Emitter<CarouselDisplayState> emit) {
    emit(
      CarouselDisplayState(
        maxPage: event.maxPage,
        pageController: PageController(initialPage: 0, viewportFraction: 0.8),
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
    if (state.pageController.page!.toInt() + 1 <= state.maxPage) {
      await state.pageController.animateToPage(
        state.pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onMovePreviousPage(CarouselDisplayMovePreviousPage event,
      Emitter<CarouselDisplayState> emit) async {
    await state.pageController.animateToPage(
      state.pageController.page!.toInt() - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
