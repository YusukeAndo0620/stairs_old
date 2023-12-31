import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';
import '../../../model/model.dart';

// Event
abstract class TaskItemEvent {
  const TaskItemEvent();
}

class TaskItemInit extends TaskItemEvent {
  const TaskItemInit({
    required this.boardId,
    this.taskItemId,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.labelList,
  });

  final String boardId;
  final String? taskItemId;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ColorLabelInfo>? labelList;
}

class TaskItemUpdateTitle extends TaskItemEvent {
  const TaskItemUpdateTitle({required this.title});

  final String title;
}

class TaskItemUpdateDescription extends TaskItemEvent {
  const TaskItemUpdateDescription({required this.description});

  final String description;
}

class TaskItemUpdateStartDate extends TaskItemEvent {
  const TaskItemUpdateStartDate({required this.startDate});

  final DateTime startDate;
}

class TaskItemUpdateEndDate extends TaskItemEvent {
  const TaskItemUpdateEndDate({required this.endDate});

  final DateTime endDate;
}

class TaskItemUpdateLabelList extends TaskItemEvent {
  const TaskItemUpdateLabelList({required this.labelList});

  final List<ColorLabelInfo> labelList;
}

// State
@immutable
class TaskItemBlocState extends Equatable {
  const TaskItemBlocState({
    required this.taskItemInfo,
  });

  final TaskItemInfo taskItemInfo;

  @override
  List<Object?> get props => [
        taskItemInfo,
      ];

  TaskItemBlocState copyWith({
    String? boardId,
    String? taskItemId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<ColorLabelInfo>? labelList,
  }) =>
      TaskItemBlocState(
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
class TaskItemBloc extends Bloc<TaskItemEvent, TaskItemBlocState> {
  TaskItemBloc()
      : super(
          TaskItemBlocState(
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
    on<TaskItemInit>(_onInit);
    on<TaskItemUpdateTitle>(_onUpdateTitle);
    on<TaskItemUpdateDescription>(_onUpdateDescription);
    on<TaskItemUpdateStartDate>(_onUpdateStartDate);
    on<TaskItemUpdateEndDate>(_onUpdateEndDate);
    on<TaskItemUpdateLabelList>(_onUpdateLabelList);
  }

  void _onInit(TaskItemInit event, Emitter<TaskItemBlocState> emit) {
    emit(
      TaskItemBlocState(
        taskItemInfo: TaskItemInfo(
          boardId: event.boardId,
          taskItemId: event.taskItemId == null ? uuid.v4() : event.taskItemId!,
          title: event.title ?? '',
          description: event.description ?? '',
          startDate: event.startDate ?? DateTime.now(),
          endDate: event.endDate ?? DateTime.now().add(const Duration(days: 7)),
          labelList: event.labelList ?? <ColorLabelInfo>[],
        ),
      ),
    );
  }

  Future<void> _onUpdateTitle(
      TaskItemUpdateTitle event, Emitter<TaskItemBlocState> emit) async {
    emit(
      state.copyWith(title: event.title),
    );
  }

  Future<void> _onUpdateDescription(
      TaskItemUpdateDescription event, Emitter<TaskItemBlocState> emit) async {
    emit(
      state.copyWith(description: event.description),
    );
  }

  Future<void> _onUpdateStartDate(
      TaskItemUpdateStartDate event, Emitter<TaskItemBlocState> emit) async {
    emit(
      state.copyWith(startDate: event.startDate),
    );
  }

  Future<void> _onUpdateEndDate(
      TaskItemUpdateEndDate event, Emitter<TaskItemBlocState> emit) async {
    emit(
      state.copyWith(endDate: event.endDate),
    );
  }

  Future<void> _onUpdateLabelList(
      TaskItemUpdateLabelList event, Emitter<TaskItemBlocState> emit) async {
    emit(
      state.copyWith(labelList: event.labelList),
    );
  }
}
