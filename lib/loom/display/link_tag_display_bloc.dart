import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/model.dart';

// Event
abstract class LinkTagDisplayEvent {
  const LinkTagDisplayEvent();
}

class LinkTagDisplayInit extends LinkTagDisplayEvent {
  const LinkTagDisplayInit({required this.linkTagList});
  final List<LinkTagInfo> linkTagList;
}

class UpdateInputValue extends LinkTagDisplayEvent {
  UpdateInputValue({required this.id, required this.inputValue});
  final int id;
  final String inputValue;
}

class UpdateLinkLabelList extends LinkTagDisplayEvent {
  UpdateLinkLabelList({required this.id, required this.linkLabelList});
  final int id;
  final List<LabelInfo> linkLabelList;
}

class AddLinkTag extends LinkTagDisplayEvent {
  AddLinkTag();
}

class DeleteLinkTag extends LinkTagDisplayEvent {
  const DeleteLinkTag({
    required this.id,
    required this.inputValue,
  });
  final int id;
  final String inputValue;
}

class MoveLast extends LinkTagDisplayEvent {
  MoveLast({required this.scrollController});
  final ScrollController scrollController;
}

// State
@immutable
abstract class LinkTagDisplayState extends Equatable {
  const LinkTagDisplayState();

  @override
  List<Object?> get props => [];
}

class LinkTagDisplayInitialState extends LinkTagDisplayState {
  const LinkTagDisplayInitialState();
}

class LinkTagDisplayGetInfoState extends LinkTagDisplayState {
  const LinkTagDisplayGetInfoState({required this.linkTagList});

  final List<LinkTagInfo> linkTagList;

  @override
  List<Object?> get props => [linkTagList];

  LinkTagDisplayGetInfoState copyWith({
    List<LinkTagInfo>? linkTagList,
  }) =>
      LinkTagDisplayGetInfoState(
        linkTagList: linkTagList ?? this.linkTagList,
      );
}

// Bloc
class LinkTagDisplayBloc
    extends Bloc<LinkTagDisplayEvent, LinkTagDisplayState> {
  LinkTagDisplayBloc()
      : super(
          const LinkTagDisplayInitialState(),
        ) {
    on<LinkTagDisplayInit>(_onInit);
    on<UpdateInputValue>(_onUpdateInputValue);
    on<UpdateLinkLabelList>(_onUpdateLinkTag);
    on<AddLinkTag>(_onTapAdd);
    on<DeleteLinkTag>(_onTapDelete);
    on<MoveLast>(_onMoveLast);
  }

  void _onInit(LinkTagDisplayInit event, Emitter<LinkTagDisplayState> emit) {
    emit(LinkTagDisplayGetInfoState(linkTagList: event.linkTagList));
  }

  void _onUpdateInputValue(
      UpdateInputValue event, Emitter<LinkTagDisplayState> emit) {
    emit(
      (state as LinkTagDisplayGetInfoState).copyWith(
        linkTagList: getReplacedList(
          targetId: event.id,
          inputValue: event.inputValue,
        ),
      ),
    );
  }

  void _onUpdateLinkTag(
      UpdateLinkLabelList event, Emitter<LinkTagDisplayState> emit) {
    emit(
      (state as LinkTagDisplayGetInfoState).copyWith(
        linkTagList: getReplacedList(
            targetId: event.id, linkLabelList: event.linkLabelList),
      ),
    );
  }

  void _onTapAdd(AddLinkTag event, Emitter<LinkTagDisplayState> emit) {
    if (state is LinkTagDisplayGetInfoState) {
      final addingLinkTagInfo = LinkTagInfo(
          id: (state as LinkTagDisplayGetInfoState).linkTagList.length + 1,
          inputValue: '',
          linkLabelList: []);
      final addedList = getList();

      addedList.add(addingLinkTagInfo);
      emit((state as LinkTagDisplayGetInfoState)
          .copyWith(linkTagList: addedList));
    }
  }

  void _onTapDelete(
      DeleteLinkTag event, Emitter<LinkTagDisplayState> emit) async {
    final emitDevLangList =
        (state as LinkTagDisplayGetInfoState).linkTagList.map((item) {
      if (item.id != event.id) {
        return item;
      }
    }).toList();
    emitDevLangList.removeWhere((element) => element == null);
    emit((state as LinkTagDisplayGetInfoState).copyWith(
        linkTagList: emitDevLangList.whereType<LinkTagInfo>().toList()));
  }

  void _onMoveLast(MoveLast event, Emitter<LinkTagDisplayState> emit) {
    event.scrollController
        .jumpTo(event.scrollController.position.maxScrollExtent);
  }

  List<LinkTagInfo> getReplacedList({
    required int targetId,
    String? inputValue,
    List<LabelInfo>? linkLabelList,
  }) {
    final displayState = (state as LinkTagDisplayGetInfoState);
    final targetIndex = displayState.linkTagList
        .indexWhere((element) => element.id == targetId);
    final replacedList = getList();

    final editTarget = LinkTagInfo(
      id: targetId,
      inputValue:
          inputValue ?? displayState.linkTagList[targetIndex].inputValue,
      linkLabelList:
          linkLabelList ?? displayState.linkTagList[targetIndex].linkLabelList,
    );

    replacedList.replaceRange(targetIndex, targetIndex + 1, [editTarget]);
    return replacedList;
  }

  List<LinkTagInfo> getList() {
    return (state as LinkTagDisplayGetInfoState)
        .linkTagList
        .map((item) => item)
        .toList();
  }
}
