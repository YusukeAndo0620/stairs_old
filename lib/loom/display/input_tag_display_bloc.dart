import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';

// Event
abstract class InputTagDisplayEvent {
  const InputTagDisplayEvent();
}

class InputTagDisplayInit extends InputTagDisplayEvent {
  const InputTagDisplayInit({required this.tagList});
  final List<ColorLabelInfo> tagList;
}

class UpdateInputValue extends InputTagDisplayEvent {
  UpdateInputValue({required this.id, required this.inputValue});
  final String id;
  final String inputValue;
}

class UpdateLinkColor extends InputTagDisplayEvent {
  UpdateLinkColor({required this.id, required this.themeColor});
  final String id;
  final Color themeColor;
}

class AddTag extends InputTagDisplayEvent {
  AddTag();
}

class DeleteTag extends InputTagDisplayEvent {
  const DeleteTag({
    required this.id,
  });
  final String id;
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
  const InputTagDisplayGetInfoState({required this.tagList});

  final List<ColorLabelInfo> tagList;

  @override
  List<Object?> get props => [tagList];

  InputTagDisplayGetInfoState copyWith({
    List<ColorLabelInfo>? tagList,
  }) =>
      InputTagDisplayGetInfoState(
        tagList: tagList ?? this.tagList,
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
    on<AddTag>(_onTapAdd);
    on<DeleteTag>(_onTapDelete);
    on<MoveLast>(_onMoveLast);
  }

  void _onInit(InputTagDisplayInit event, Emitter<InputTagDisplayState> emit) {
    emit(InputTagDisplayGetInfoState(tagList: event.tagList));
  }

  void _onUpdateInputValue(
      UpdateInputValue event, Emitter<InputTagDisplayState> emit) {
    emit(
      (state as InputTagDisplayGetInfoState).copyWith(
        tagList: getReplacedList(
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
        tagList:
            getReplacedList(targetId: event.id, themeColor: event.themeColor),
      ),
    );
  }

  void _onTapAdd(AddTag event, Emitter<InputTagDisplayState> emit) {
    if (state is InputTagDisplayGetInfoState) {
      final addingColorLabelInfo = ColorLabelInfo(
        id: uuid.v4(),
        labelName: '',
        themeColor: colorList[0].themeColor,
      );
      final emitTagList = getList();

      emitTagList.add(addingColorLabelInfo);
      emit((state as InputTagDisplayGetInfoState)
          .copyWith(tagList: emitTagList));
    }
  }

  void _onTapDelete(DeleteTag event, Emitter<InputTagDisplayState> emit) async {
    final emitTagList =
        (state as InputTagDisplayGetInfoState).tagList.map((item) {
      if (item.id != event.id) {
        return item;
      }
    }).toList();
    emitTagList.removeWhere((element) => element == null);
    emit((state as InputTagDisplayGetInfoState)
        .copyWith(tagList: emitTagList.whereType<ColorLabelInfo>().toList()));
  }

  void _onMoveLast(MoveLast event, Emitter<InputTagDisplayState> emit) {
    event.scrollController
        .jumpTo(event.scrollController.position.maxScrollExtent);
  }

  List<ColorLabelInfo> getReplacedList(
      {required String targetId, String? inputValue, Color? themeColor}) {
    final displayState = (state as InputTagDisplayGetInfoState);
    final targetIndex =
        displayState.tagList.indexWhere((element) => element.id == targetId);
    final replacedList = getList();

    final editTarget = ColorLabelInfo(
      id: targetId,
      labelName: inputValue ?? displayState.tagList[targetIndex].labelName,
      themeColor: themeColor ?? displayState.tagList[targetIndex].themeColor,
    );

    replacedList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    return replacedList;
  }

  List<ColorLabelInfo> getList() {
    return (state as InputTagDisplayGetInfoState)
        .tagList
        .map((item) => item)
        .toList();
  }
}
