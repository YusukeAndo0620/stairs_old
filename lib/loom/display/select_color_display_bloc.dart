import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

final _colorList = [
  ColorInfo(
    id: 1,
    themeColor: Color.fromARGB(255, 255, 31, 31),
  ),
  ColorInfo(
    id: 2,
    themeColor: Color.fromARGB(255, 7, 77, 255),
  ),
  ColorInfo(
    id: 3,
    themeColor: Color.fromARGB(255, 239, 255, 8),
  ),
  ColorInfo(
    id: 4,
    themeColor: Color.fromARGB(255, 11, 255, 3),
  ),
  ColorInfo(
    id: 5,
    themeColor: Color.fromARGB(255, 10, 241, 161),
  ),
  ColorInfo(
    id: 6,
    themeColor: Color.fromARGB(255, 0, 253, 249),
  ),
  ColorInfo(
    id: 7,
    themeColor: Color.fromARGB(255, 255, 162, 1),
  ),
  ColorInfo(
    id: 8,
    themeColor: Color.fromARGB(255, 228, 50, 255),
  ),
  ColorInfo(
    id: 9,
    themeColor: Color.fromARGB(255, 255, 146, 146),
  ),
  ColorInfo(
    id: 10,
    themeColor: Colors.black,
  ),
];

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
      colorList: _colorList,
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
