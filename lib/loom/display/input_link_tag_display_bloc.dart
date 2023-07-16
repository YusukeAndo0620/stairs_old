import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';

// Event
abstract class InputLinkTagDisplayEvent {
  const InputLinkTagDisplayEvent();
}

class Init extends InputLinkTagDisplayEvent {
  const Init({required this.linkTagList});
  final List<LinkTagInfo> linkTagList;
}

class EditInputValue extends InputLinkTagDisplayEvent {
  EditInputValue({required this.id, required this.inputValue});
  final int id;
  final String inputValue;
}

class AddInputLinkTag extends InputLinkTagDisplayEvent {
  AddInputLinkTag();
}

class DeleteInputLinkTag extends InputLinkTagDisplayEvent {
  const DeleteInputLinkTag({
    required this.id,
    required this.inputValue,
  });
  final int id;
  final String inputValue;
}

class MoveLast extends InputLinkTagDisplayEvent {
  MoveLast({required this.scrollController});
  final ScrollController scrollController;
}

// State
@immutable
abstract class InputLinkTagDisplayState extends Equatable {
  const InputLinkTagDisplayState();

  @override
  List<Object?> get props => [];
}

class InputLinkTagDisplayInitialState extends InputLinkTagDisplayState {
  const InputLinkTagDisplayInitialState();
}

class InputLinkTagDisplayGetInfoState extends InputLinkTagDisplayState {
  const InputLinkTagDisplayGetInfoState({required this.linkTagList});

  final List<LinkTagInfo> linkTagList;

  @override
  List<Object?> get props => [linkTagList];

  InputLinkTagDisplayGetInfoState copyWith({
    List<LinkTagInfo>? linkTagList,
  }) =>
      InputLinkTagDisplayGetInfoState(
        linkTagList: linkTagList ?? this.linkTagList,
      );
}

// Bloc
class InputLinkTagDisplayBloc
    extends Bloc<InputLinkTagDisplayEvent, InputLinkTagDisplayState> {
  InputLinkTagDisplayBloc()
      : super(
          const InputLinkTagDisplayInitialState(),
        ) {
    on<Init>(_onInit);
    on<EditInputValue>(_onEditInputValue);
    on<AddInputLinkTag>(_onTapAdd);
    on<DeleteInputLinkTag>(_onTapDelete);
    on<MoveLast>(_onMoveLast);
  }

  void _onInit(Init event, Emitter<InputLinkTagDisplayState> emit) {
    emit(InputLinkTagDisplayGetInfoState(linkTagList: event.linkTagList));
  }

  void _onEditInputValue(
      EditInputValue event, Emitter<InputLinkTagDisplayState> emit) {
    final targetState = (state as InputLinkTagDisplayGetInfoState);
    final targetIndex =
        targetState.linkTagList.indexWhere((element) => element.id == event.id);
    final targetList = getList();

    final editTarget = LinkTagInfo(
        id: event.id,
        inputValue: event.inputValue,
        linkLabel: targetState.linkTagList[targetIndex].linkLabel);

    targetList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    emit(targetState.copyWith(linkTagList: targetList));
  }

  void _onTapAdd(
      AddInputLinkTag event, Emitter<InputLinkTagDisplayState> emit) {
    if (state is InputLinkTagDisplayGetInfoState) {
      final addingLinkTagInfo = LinkTagInfo(
          id: (state as InputLinkTagDisplayGetInfoState).linkTagList.length + 1,
          inputValue: '',
          linkLabel: []);
      final addedList = getList();

      addedList.add(addingLinkTagInfo);
      emit((state as InputLinkTagDisplayGetInfoState)
          .copyWith(linkTagList: addedList));
    }
  }

  void _onTapDelete(
      DeleteInputLinkTag event, Emitter<InputLinkTagDisplayState> emit) async {
    final emitDevLangList =
        (state as InputLinkTagDisplayGetInfoState).linkTagList.map((item) {
      if (item.id != event.id) {
        return item;
      }
    }).toList();
    emitDevLangList.removeWhere((element) => element == null);
    emit((state as InputLinkTagDisplayGetInfoState).copyWith(
        linkTagList: emitDevLangList.whereType<LinkTagInfo>().toList()));
  }

  void _onMoveLast(MoveLast event, Emitter<InputLinkTagDisplayState> emit) {
    event.scrollController
        .jumpTo(event.scrollController.position.maxScrollExtent);
  }

  List<LinkTagInfo> getList() {
    return (state as InputLinkTagDisplayGetInfoState)
        .linkTagList
        .map((item) => item)
        .toList();
  }
}
