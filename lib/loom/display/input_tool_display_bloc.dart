import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';

// Event
abstract class InputToolDisplayEvent {
  const InputToolDisplayEvent();
}

class InputToolDisplayInit extends InputToolDisplayEvent {
  const InputToolDisplayInit({required this.toolList});
  final List<Label> toolList;
}

class UpdateInputValue extends InputToolDisplayEvent {
  UpdateInputValue({required this.id, required this.inputValue});
  final String id;
  final String inputValue;
}

class AddToolItem extends InputToolDisplayEvent {
  AddToolItem();
}

class DeleteToolItem extends InputToolDisplayEvent {
  const DeleteToolItem({
    required this.id,
  });
  final String id;
}

class MoveLast extends InputToolDisplayEvent {
  MoveLast({required this.scrollController});
  final ScrollController scrollController;
}

// State
@immutable
abstract class InputToolDisplayState extends Equatable {
  const InputToolDisplayState();

  @override
  List<Object?> get props => [];
}

class InputToolDisplayInitialState extends InputToolDisplayState {
  const InputToolDisplayInitialState();
}

class InputToolDisplayGetInfoState extends InputToolDisplayState {
  const InputToolDisplayGetInfoState({required this.toolList});

  final List<Label> toolList;

  @override
  List<Object?> get props => [toolList];

  InputToolDisplayGetInfoState copyWith({
    List<Label>? toolList,
  }) =>
      InputToolDisplayGetInfoState(
        toolList: toolList ?? this.toolList,
      );
}

// Bloc
class InputToolDisplayBloc
    extends Bloc<InputToolDisplayEvent, InputToolDisplayState> {
  InputToolDisplayBloc()
      : super(
          const InputToolDisplayInitialState(),
        ) {
    on<InputToolDisplayInit>(_onInit);
    on<UpdateInputValue>(_onUpdateInputValue);
    on<AddToolItem>(_onTapAdd);
    on<DeleteToolItem>(_onTapDelete);
    on<MoveLast>(_onMoveLast);
  }

  void _onInit(
      InputToolDisplayInit event, Emitter<InputToolDisplayState> emit) {
    emit(InputToolDisplayGetInfoState(toolList: event.toolList));
  }

  void _onUpdateInputValue(
      UpdateInputValue event, Emitter<InputToolDisplayState> emit) {
    emit(
      (state as InputToolDisplayGetInfoState).copyWith(
        toolList: getReplacedList(
          targetId: event.id,
          inputValue: event.inputValue,
        ),
      ),
    );
  }

  void _onTapAdd(AddToolItem event, Emitter<InputToolDisplayState> emit) {
    if (state is InputToolDisplayGetInfoState) {
      final addingLabelInfo = Label(
        id: uuid.v4(),
        labelName: '',
      );
      final emitToolList = getList();

      emitToolList.add(addingLabelInfo);
      emit((state as InputToolDisplayGetInfoState)
          .copyWith(toolList: emitToolList));
    }
  }

  void _onTapDelete(
      DeleteToolItem event, Emitter<InputToolDisplayState> emit) async {
    final emitToolList =
        (state as InputToolDisplayGetInfoState).toolList.map((item) {
      if (item.id != event.id) {
        return item;
      }
    }).toList();
    emitToolList.removeWhere((element) => element == null);
    emit((state as InputToolDisplayGetInfoState)
        .copyWith(toolList: emitToolList.whereType<Label>().toList()));
  }

  void _onMoveLast(MoveLast event, Emitter<InputToolDisplayState> emit) {
    event.scrollController
        .jumpTo(event.scrollController.position.maxScrollExtent);
  }

  List<Label> getReplacedList(
      {required String targetId, String? inputValue, Color? themeColor}) {
    final displayState = (state as InputToolDisplayGetInfoState);
    final targetIndex =
        displayState.toolList.indexWhere((element) => element.id == targetId);
    final replacedList = getList();

    final editTarget = Label(
      id: targetId,
      labelName: inputValue ?? displayState.toolList[targetIndex].labelName,
    );

    replacedList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    return replacedList;
  }

  List<Label> getList() {
    return (state as InputToolDisplayGetInfoState)
        .toolList
        .map((item) => item)
        .toList();
  }
}
