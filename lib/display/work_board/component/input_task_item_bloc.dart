import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

// Event
abstract class InputTaskItemBlocEvent {
  const InputTaskItemBlocEvent();
}

class Init extends InputTaskItemBlocEvent {
  const Init();
}

class UpdateInputValue extends InputTaskItemBlocEvent {
  const UpdateInputValue({required this.inputValue});

  final String inputValue;
}

class UpdateDueDate extends InputTaskItemBlocEvent {
  const UpdateDueDate({required this.dueDate});

  final DateTime dueDate;
}

class UpdateLabelList extends InputTaskItemBlocEvent {
  const UpdateLabelList({required this.labelList});

  final List<ColorLabelInfo> labelList;
}

// State
@immutable
class InputTaskItemBlocState extends Equatable {
  const InputTaskItemBlocState({
    required this.inputValue,
    required this.dueDate,
    required this.labelList,
  });

  final String inputValue;
  final DateTime dueDate;
  final List<ColorLabelInfo> labelList;

  @override
  List<Object?> get props => [
        inputValue,
        dueDate,
        labelList,
      ];

  InputTaskItemBlocState copyWith({
    String? inputValue,
    DateTime? dueDate,
    List<ColorLabelInfo>? labelList,
  }) =>
      InputTaskItemBlocState(
        inputValue: inputValue ?? this.inputValue,
        dueDate: dueDate ?? this.dueDate,
        labelList: labelList ?? this.labelList,
      );
}

// Bloc
class InputTaskItemBloc
    extends Bloc<InputTaskItemBlocEvent, InputTaskItemBlocState> {
  InputTaskItemBloc()
      : super(
          InputTaskItemBlocState(
            inputValue: '',
            dueDate: DateTime.now().add(const Duration(days: 7)),
            labelList: const [],
          ),
        ) {
    on<Init>(_onInit);
    on<UpdateInputValue>(_onUpdateInputValue);
    on<UpdateDueDate>(_onUpdateDueDate);
    on<UpdateLabelList>(_onUpdateLabelList);
  }

  void _onInit(Init event, Emitter<InputTaskItemBlocState> emit) {
    emit(
      InputTaskItemBlocState(
        inputValue: '',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        labelList: const [],
      ),
    );
  }

  Future<void> _onUpdateInputValue(
      UpdateInputValue event, Emitter<InputTaskItemBlocState> emit) async {
    emit(
      state.copyWith(inputValue: event.inputValue),
    );
  }

  Future<void> _onUpdateDueDate(
      UpdateDueDate event, Emitter<InputTaskItemBlocState> emit) async {
    emit(
      state.copyWith(dueDate: event.dueDate),
    );
  }

  Future<void> _onUpdateLabelList(
      UpdateLabelList event, Emitter<InputTaskItemBlocState> emit) async {
    emit(
      state.copyWith(labelList: event.labelList),
    );
  }
}
