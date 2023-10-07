import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

// Event
abstract class InputTaskItemEvent {
  const InputTaskItemEvent();
}

class InputTaskItemInit extends InputTaskItemEvent {
  const InputTaskItemInit({
    required this.boardId,
    this.title,
    this.endDate,
    this.labelList,
  });

  final String boardId;

  final String? title;

  final DateTime? endDate;
  final List<ColorLabelInfo>? labelList;
}

class InputTaskItemUpdateTitle extends InputTaskItemEvent {
  const InputTaskItemUpdateTitle({required this.title});

  final String title;
}

class InputTaskItemUpdateEndDate extends InputTaskItemEvent {
  const InputTaskItemUpdateEndDate({required this.endDate});

  final DateTime endDate;
}

class InputTaskItemUpdateLabelList extends InputTaskItemEvent {
  const InputTaskItemUpdateLabelList({required this.labelList});

  final List<ColorLabelInfo> labelList;
}

// State
@immutable
class InputTaskItemState extends Equatable {
  const InputTaskItemState({
    required this.taskItemInfo,
  });

  final TaskItemInfo taskItemInfo;

  @override
  List<Object?> get props => [
        taskItemInfo,
      ];

  InputTaskItemState copyWith({
    String? boardId,
    String? taskItemId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<ColorLabelInfo>? labelList,
  }) =>
      InputTaskItemState(
        taskItemInfo: TaskItemInfo(
          boardId: boardId ?? taskItemInfo.boardId,
          taskItemId: taskItemId ?? taskItemInfo.taskItemId,
          title: title ?? taskItemInfo.title,
          description: description ?? taskItemInfo.description,
          startDate: startDate ?? taskItemInfo.startDate,
          endDate: endDate ?? taskItemInfo.endDate,
          labelList: labelList ?? taskItemInfo.labelList,
        ),
      );
}

// Bloc
class InputTaskItemBloc extends Bloc<InputTaskItemEvent, InputTaskItemState> {
  InputTaskItemBloc()
      : super(
          InputTaskItemState(
            taskItemInfo: TaskItemInfo(
              boardId: '',
              taskItemId: '',
              title: '',
              description: '',
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 7)),
              labelList: <ColorLabelInfo>[],
            ),
          ),
        ) {
    on<InputTaskItemInit>(_onInit);
    on<InputTaskItemUpdateTitle>(_onUpdateTitle);
    on<InputTaskItemUpdateEndDate>(_onUpdateEndDate);
    on<InputTaskItemUpdateLabelList>(_onUpdateLabelList);
  }

  void _onInit(InputTaskItemInit event, Emitter<InputTaskItemState> emit) {
    emit(
      InputTaskItemState(
        taskItemInfo: TaskItemInfo(
          boardId: event.boardId,
          taskItemId: uuid.v4(),
          title: event.title ?? '',
          description: '',
          startDate: DateTime.now(),
          endDate: event.endDate ?? DateTime.now().add(const Duration(days: 7)),
          labelList: event.labelList ?? <ColorLabelInfo>[],
        ),
      ),
    );
  }

  Future<void> _onUpdateTitle(
      InputTaskItemUpdateTitle event, Emitter<InputTaskItemState> emit) async {
    emit(
      state.copyWith(title: event.title),
    );
  }

  Future<void> _onUpdateEndDate(InputTaskItemUpdateEndDate event,
      Emitter<InputTaskItemState> emit) async {
    emit(
      state.copyWith(endDate: event.endDate),
    );
  }

  Future<void> _onUpdateLabelList(InputTaskItemUpdateLabelList event,
      Emitter<InputTaskItemState> emit) async {
    emit(
      state.copyWith(labelList: event.labelList),
    );
  }
}
