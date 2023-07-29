import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';

// Event
abstract class InputTagDisplayEvent {
  const InputTagDisplayEvent();
}

class InputTagDisplayInit extends InputTagDisplayEvent {
  const InputTagDisplayInit({required this.linkTagList});
  final List<ColorLabelInfo> linkTagList;
}

class UpdateInputValue extends InputTagDisplayEvent {
  UpdateInputValue({required this.id, required this.inputValue});
  final int id;
  final String inputValue;
}

class UpdateLinkColor extends InputTagDisplayEvent {
  UpdateLinkColor({required this.id, required this.themeColor});
  final int id;
  final Color themeColor;
}

class AddLinkTag extends InputTagDisplayEvent {
  AddLinkTag();
}

class DeleteLinkTag extends InputTagDisplayEvent {
  const DeleteLinkTag({
    required this.id,
  });
  final int id;
}

class MoveLast extends InputTagDisplayEvent {
  MoveLast({required this.scrollController});
  final ScrollController scrollController;
}

// State
@immutable
abstract class InputTagDisplayState extends Equatable {
  const InputTagDisplayState();

  @override
  List<Object?> get props => [];
}

class InputTagDisplayInitialState extends InputTagDisplayState {
  const InputTagDisplayInitialState();
}

class InputTagDisplayGetInfoState extends InputTagDisplayState {
  const InputTagDisplayGetInfoState({required this.linkTagList});

  final List<ColorLabelInfo> linkTagList;

  @override
  List<Object?> get props => [linkTagList];

  InputTagDisplayGetInfoState copyWith({
    List<ColorLabelInfo>? linkTagList,
  }) =>
      InputTagDisplayGetInfoState(
        linkTagList: linkTagList ?? this.linkTagList,
      );
}

// Bloc
class InputTagDisplayBloc
    extends Bloc<InputTagDisplayEvent, InputTagDisplayState> {
  InputTagDisplayBloc()
      : super(
          const InputTagDisplayInitialState(),
        ) {
    on<InputTagDisplayInit>(_onInit);
    on<UpdateInputValue>(_onUpdateInputValue);
    on<UpdateLinkColor>(_onUpdateLinkColor);
    on<AddLinkTag>(_onTapAdd);
    on<DeleteLinkTag>(_onTapDelete);
    on<MoveLast>(_onMoveLast);
  }

  void _onInit(InputTagDisplayInit event, Emitter<InputTagDisplayState> emit) {
    emit(InputTagDisplayGetInfoState(linkTagList: event.linkTagList));
  }

  void _onUpdateInputValue(
      UpdateInputValue event, Emitter<InputTagDisplayState> emit) {
    emit(
      (state as InputTagDisplayGetInfoState).copyWith(
        linkTagList: getReplacedList(
          targetId: event.id,
          inputValue: event.inputValue,
        ),
      ),
    );
  }

  void _onUpdateLinkColor(
      UpdateLinkColor event, Emitter<InputTagDisplayState> emit) {
    emit(
      (state as InputTagDisplayGetInfoState).copyWith(
        linkTagList:
            getReplacedList(targetId: event.id, themeColor: event.themeColor),
      ),
    );
  }

  void _onTapAdd(AddLinkTag event, Emitter<InputTagDisplayState> emit) {
    if (state is InputTagDisplayGetInfoState) {
      final addingColorLabelInfo = ColorLabelInfo(
        id: (state as InputTagDisplayGetInfoState).linkTagList.length + 1,
        labelName: '',
        themeColor: colorList[0].themeColor,
      );
      final addedList = getList();

      addedList.add(addingColorLabelInfo);
      emit((state as InputTagDisplayGetInfoState)
          .copyWith(linkTagList: addedList));
    }
  }

  void _onTapDelete(
      DeleteLinkTag event, Emitter<InputTagDisplayState> emit) async {
    final emitDevLangList =
        (state as InputTagDisplayGetInfoState).linkTagList.map((item) {
      if (item.id != event.id) {
        return item;
      }
    }).toList();
    emitDevLangList.removeWhere((element) => element == null);
    emit((state as InputTagDisplayGetInfoState).copyWith(
        linkTagList: emitDevLangList.whereType<ColorLabelInfo>().toList()));
  }

  void _onMoveLast(MoveLast event, Emitter<InputTagDisplayState> emit) {
    event.scrollController
        .jumpTo(event.scrollController.position.maxScrollExtent);
  }

  List<ColorLabelInfo> getReplacedList(
      {required int targetId, String? inputValue, Color? themeColor}) {
    final displayState = (state as InputTagDisplayGetInfoState);
    final targetIndex = displayState.linkTagList
        .indexWhere((element) => element.id == targetId);
    final replacedList = getList();

    final editTarget = ColorLabelInfo(
      id: targetId,
      labelName: inputValue ?? displayState.linkTagList[targetIndex].labelName,
      themeColor:
          themeColor ?? displayState.linkTagList[targetIndex].themeColor,
    );

    replacedList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    return replacedList;
  }

  List<ColorLabelInfo> getList() {
    return (state as InputTagDisplayGetInfoState)
        .linkTagList
        .map((item) => item)
        .toList();
  }
}
