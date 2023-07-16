// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'transition_page.dart';
// import 'package:equatable/equatable.dart';

// // Event
// abstract class _TransitionBlocEvent {
//   const _TransitionBlocEvent();
// }

// class _PushPage extends _TransitionBlocEvent {
//   const _PushPage(this.page);

//   final TransitionPage page;
// }

// class _PopPage extends _TransitionBlocEvent {
//   const _PopPage({required this.doEmit});

//   final bool doEmit;
// }

// class _PopToEntryPage extends _TransitionBlocEvent {}

// class _ReplacePage extends _TransitionBlocEvent {
//   const _ReplacePage(this.page);

//   final TransitionPage page;
// }

// // State
// @immutable
// class TransitionBlocState extends Equatable {
//   const TransitionBlocState({required this.pages});

//   final List<TransitionPage> pages;
//   TransitionPage get visiblePage => pages.last;

//   @override
//   List<Object?> get props => [pages];
// }

// // Bloc

// class TransitionBloc extends Bloc<_TransitionBlocEvent, TransitionBlocState> {
//   TransitionBloc(super.initialState) : entry = initialState.pages.first {
//     on<_PushPage>(_onPushPage);
//     on<_PopPage>(_onPopPage);
//     on<_PopToEntryPage>(_onPopToEntryPage);
//     on<_ReplacePage>(_onReplacePage);
//   }

//   final TransitionPage entry;

//   void push(TransitionPage page) => add(_PushPage(page));
//   void pop(bool doEmit) => add(_PopPage(doEmit: doEmit));
//   void popToEntryPage() => add(_PopToEntryPage());
//   void replace(TransitionPage page) => add(_ReplacePage(page));

//   void _onPushPage(_PushPage event, Emitter<TransitionBlocState> emit) {
//     emit(TransitionBlocState(pages: [...state.pages, event.page]));
//   }

//   void _onPopPage(_PopPage event, Emitter<TransitionBlocState> emit) {
//     if (event.doEmit) {
//       emit(TransitionBlocState(pages: [...state.pages]..removeLast()));
//       return;
//     }
//     state.pages.removeLast();
//   }

//   void _onPopToEntryPage(
//       _PopToEntryPage event, Emitter<TransitionBlocState> emit) {
//     emit(TransitionBlocState(pages: [entry]));
//   }

//   void _onReplacePage(_ReplacePage event, Emitter<TransitionBlocState> emit) {
//     emit(TransitionBlocState(pages: [event.page]));
//   }
// }
