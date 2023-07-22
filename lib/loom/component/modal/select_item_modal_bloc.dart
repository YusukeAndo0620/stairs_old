import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

class CheckLabelInfo extends ColorLabelInfo {
  CheckLabelInfo({
    required super.id,
    required super.labelName,
    required super.themeColor,
    required this.checked,
  });

  final bool checked;
}

// Event
abstract class SelectItemModalEvent {
  const SelectItemModalEvent();
}

class SelectItemInit extends SelectItemModalEvent {
  const SelectItemInit({
    required this.id,
    required this.labelList,
    required this.selectedLabelList,
  });

  final int id;
  final List<ColorLabelInfo> labelList;
  final List<ColorLabelInfo> selectedLabelList;
}

class SelectItemTapListItem extends SelectItemModalEvent {
  const SelectItemTapListItem({required this.tappedItem});

  final CheckLabelInfo tappedItem;
}

// State
@immutable
abstract class SelectItemModalState extends Equatable {
  const SelectItemModalState();
  @override
  List<Object?> get props => [];
}

@immutable
class SelectItemInitialState extends SelectItemModalState {
  const SelectItemInitialState();
}

@immutable
class SelectItemGetCheckListState extends SelectItemModalState {
  const SelectItemGetCheckListState({
    required this.id,
    required this.checkList,
  });
  final int id;
  final List<CheckLabelInfo> checkList;

  @override
  List<Object?> get props => [
        id,
        checkList,
      ];

  SelectItemGetCheckListState copyWith({
    int? id,
    List<CheckLabelInfo>? checkList,
  }) =>
      SelectItemGetCheckListState(
        id: id ?? this.id,
        checkList: checkList ?? this.checkList,
      );

// チェックリストで、選択された要素のリストを取得
  List<ColorLabelInfo> get selectedList {
    final selectedList =
        checkList.map((item) => item.checked ? item : null).toList();
    selectedList.removeWhere((element) => element == null);
    return selectedList.whereType<ColorLabelInfo>().toList();
  }
}

// Bloc
class SelectItemModalBloc
    extends Bloc<SelectItemModalEvent, SelectItemModalState> {
  SelectItemModalBloc()
      : super(
          const SelectItemInitialState(),
        ) {
    on<SelectItemInit>(_onInit);
    on<SelectItemTapListItem>(_onTapListItem);
  }

  void _onInit(SelectItemInit event, Emitter<SelectItemModalState> emit) {
    final checkList = event.labelList
        .map(
          (item) => CheckLabelInfo(
            id: item.id,
            labelName: item.labelName,
            themeColor: item.themeColor,
            checked: event.selectedLabelList.firstWhereOrNull(
                  (element) => element.id == item.id,
                ) !=
                null,
          ),
        )
        .toList();
    emit(SelectItemGetCheckListState(id: event.id, checkList: checkList));
  }

  void _onTapListItem(
      SelectItemTapListItem event, Emitter<SelectItemModalState> emit) {
    final targetIndex = (state as SelectItemGetCheckListState)
        .checkList
        .indexWhere((element) => element.id == event.tappedItem.id);
    final targetList = (state as SelectItemGetCheckListState)
        .checkList
        .map((item) => item)
        .toList();

    final editTarget = CheckLabelInfo(
        id: event.tappedItem.id,
        labelName: event.tappedItem.labelName,
        themeColor: event.tappedItem.themeColor,
        checked: !event.tappedItem.checked);

    targetList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    emit(
        (state as SelectItemGetCheckListState).copyWith(checkList: targetList));
  }
}
