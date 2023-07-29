import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

// Event
abstract class SelectColorDisplayEvent {
  const SelectColorDisplayEvent();
}

class SelectColorInit extends SelectColorDisplayEvent {
  const SelectColorInit({
    required this.selectColorInfo,
  });
  final ColorInfo selectColorInfo;
}

class SelectColorTapListItem extends SelectColorDisplayEvent {
  const SelectColorTapListItem({required this.colorId});

  final int colorId;
}

// State
@immutable
abstract class SelectColorDisplayState extends Equatable {
  const SelectColorDisplayState();
  @override
  List<Object?> get props => [];
}

@immutable
class SelectColorInitialState extends SelectColorDisplayState {
  const SelectColorInitialState();
}

@immutable
class SelectColorGotCompleteState extends SelectColorDisplayState {
  const SelectColorGotCompleteState({
    required this.selectedColorId,
    required this.colorList,
  });
  final int selectedColorId;
  final List<ColorInfo> colorList;

  @override
  List<Object?> get props => [
        selectedColorId,
        colorList,
      ];

  SelectColorGotCompleteState copyWith({
    int? selectedColorId,
    List<ColorInfo>? colorList,
  }) =>
      SelectColorGotCompleteState(
        selectedColorId: selectedColorId ?? this.selectedColorId,
        colorList: colorList ?? this.colorList,
      );

  ColorInfo get selectedColorInfo =>
      colorList.firstWhere((item) => item.id == selectedColorId,
          orElse: () => colorList[0]);
}

// Bloc
class SelectColorDisplayBloc
    extends Bloc<SelectColorDisplayEvent, SelectColorDisplayState> {
  SelectColorDisplayBloc()
      : super(
          const SelectColorInitialState(),
        ) {
    on<SelectColorInit>(_onInit);
    on<SelectColorTapListItem>(_onTapListItem);
  }

  void _onInit(SelectColorInit event, Emitter<SelectColorDisplayState> emit) {
    emit(SelectColorGotCompleteState(
      selectedColorId: event.selectColorInfo.id,
      colorList: colorList,
    ));
  }

  void _onTapListItem(
      SelectColorTapListItem event, Emitter<SelectColorDisplayState> emit) {
    emit(
      (state as SelectColorGotCompleteState)
          .copyWith(selectedColorId: event.colorId),
    );
  }
}
