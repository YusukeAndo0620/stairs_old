import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import '../../../model/model.dart';

class CheckLabel extends Label {
  CheckLabel({
    required super.id,
    required super.labelName,
    required this.checked,
  });

  final bool checked;
}

// Event
abstract class SelectLabelEvent {
  const SelectLabelEvent();
}

class SelectLabelInit extends SelectLabelEvent {
  const SelectLabelInit({
    required this.selectedLabelList,
  });
  final List<Label> selectedLabelList;
}

class SelectLabelListItem extends SelectLabelEvent {
  const SelectLabelListItem({required this.tappedItem});

  final CheckLabel tappedItem;
}

// State
@immutable
abstract class SelectLabelDisplayState extends Equatable {
  const SelectLabelDisplayState();
  @override
  List<Object?> get props => [];
}

@immutable
class SelectLabelInitialState extends SelectLabelDisplayState {
  const SelectLabelInitialState();
}

@immutable
class SelectLabelGetCheckListState extends SelectLabelDisplayState {
  const SelectLabelGetCheckListState({
    required this.checkList,
  });
  final List<CheckLabel> checkList;

  @override
  List<Object?> get props => [
        checkList,
      ];

  SelectLabelGetCheckListState copyWith({
    List<CheckLabel>? checkList,
  }) =>
      SelectLabelGetCheckListState(
        checkList: checkList ?? this.checkList,
      );

  // チェックリストで、選択された要素のリストを取得
  List<Label> get selectedList {
    final selectedList =
        checkList.map((item) => item.checked ? item : null).toList();
    selectedList.removeWhere((element) => element == null);
    return selectedList.whereType<Label>().toList();
  }
}

// Bloc
class SelectLabelDisplayBloc
    extends Bloc<SelectLabelEvent, SelectLabelDisplayState> {
  SelectLabelDisplayBloc()
      : super(
          const SelectLabelInitialState(),
        ) {
    on<SelectLabelInit>(_onInit);
    on<SelectLabelListItem>(_onTapListItem);
  }

  void _onInit(SelectLabelInit event, Emitter<SelectLabelDisplayState> emit) {
    final checkList = devProgressList
        .map(
          (item) => CheckLabel(
            id: item.id,
            labelName: item.labelName,
            checked: event.selectedLabelList.firstWhereOrNull(
                  (element) => element.id == item.id,
                ) !=
                null,
          ),
        )
        .toList();
    emit(SelectLabelGetCheckListState(checkList: checkList));
  }

  void _onTapListItem(
      SelectLabelListItem event, Emitter<SelectLabelDisplayState> emit) {
    final targetIndex = (state as SelectLabelGetCheckListState)
        .checkList
        .indexWhere((element) => element.id == event.tappedItem.id);
    final targetList = (state as SelectLabelGetCheckListState)
        .checkList
        .map((item) => item)
        .toList();

    final editTarget = CheckLabel(
        id: event.tappedItem.id,
        labelName: event.tappedItem.labelName,
        checked: !event.tappedItem.checked);

    targetList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    emit((state as SelectLabelGetCheckListState)
        .copyWith(checkList: targetList));
  }
}
