import 'package:stairs/loom/loom_package.dart';

import 'package:equatable/equatable.dart';
import '../../model/dummy.dart';

// Event
abstract class StatusEvent {
  const StatusEvent();
}

class StatusInit extends StatusEvent {
  const StatusInit();
}

class StatusGetList extends StatusEvent {
  const StatusGetList({required this.projectId});

  final String projectId;
}

// State
@immutable
abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object?> get props => [];
}

class StatusInitialState extends StatusState {
  const StatusInitialState();

  @override
  List<Object?> get props => [];
}

class StatusReadyState extends StatusState {
  const StatusReadyState({
    required this.projectId,
    required this.projectDetailList,
    required this.labelStatusList,
  });

  final String projectId;
  final List<ProjectDetailItemInfo> projectDetailList;
  final List<LabelStatusInfo> labelStatusList;

  @override
  List<Object?> get props => [
        projectId,
        projectDetailList,
        labelStatusList,
      ];

  StatusReadyState copyWith({
    String? projectId,
    List<ProjectDetailItemInfo>? projectDetailList,
    List<LabelStatusInfo>? labelStatusList,
  }) =>
      StatusReadyState(
        projectId: projectId ?? this.projectId,
        projectDetailList: projectDetailList ?? this.projectDetailList,
        labelStatusList: labelStatusList ?? this.labelStatusList,
      );

  ProjectDetailItemInfo get selectedProjectDetail {
    return projectDetailList
        .firstWhere((element) => element.projectId == projectId);
  }
}

// Bloc
class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc()
      : super(
          const StatusInitialState(),
        ) {
    on<StatusInit>(_onInit);
    on<StatusGetList>(_onGetList);
  }

  void _onInit(StatusInit event, Emitter<StatusState> emit) {
    // TODO: 最初にproject一覧を取得してセット。
    emit(
      StatusReadyState(
        projectId: dummyProjectDetailList[0].projectId,
        projectDetailList: dummyProjectDetailList,
        labelStatusList: const [],
      ),
    );
  }

  Future<void> _onGetList(
      StatusGetList event, Emitter<StatusState> emit) async {
    // TODO: project idより、対象のboard一覧を取得。

    final tempDummyBoardList = dummyBoardList;
    final targetProjectId = event.projectId.isEmpty
        ? (state as StatusReadyState).projectId
        : event.projectId;

    // key; label id
    Map<String, List<TaskStatusInfo>> taskStatusMap = {};

    for (final board in tempDummyBoardList) {
      for (final taskItem in board.taskItemList) {
        if (taskItem.labelList.isEmpty) return;
        final targetTaskStatus = TaskStatusInfo(
          taskItemId: taskItem.taskItemId,
          startDate: taskItem.startDate,
          endDate: taskItem.endDate,
          doneDate: taskItem.doneDate,
        );
        for (final label in taskItem.labelList) {
          if (taskStatusMap.containsKey(label.id)) {
            taskStatusMap[label.id]!.add(targetTaskStatus);
          } else {
            taskStatusMap[label.id] = [targetTaskStatus];
          }
        }
      }
    }

    // ラベルの情報設定
    final targetLabelStatusList = (state as StatusReadyState)
        .projectDetailList
        .firstWhere((element) => element.projectId == targetProjectId)
        .allLabelList
        .map(
          (label) => LabelStatusInfo(
            projectId: targetProjectId,
            labelId: label.id,
            labelName: label.labelName,
            isDevLanguage: label.isDevLanguage,
            taskStatusList: taskStatusMap.containsKey(label.id)
                ? taskStatusMap[label.id]!.whereType<TaskStatusInfo>().toList()
                : const [],
          ),
        )
        .toList();

    // 降順でソート
    targetLabelStatusList.sort(
      (a, b) => -1 * a.taskStatusList.length.compareTo(b.taskStatusList.length),
    );

    // 使用されていないラベルを削除
    final emitList = targetLabelStatusList
        .map((element) => element.taskStatusList.isNotEmpty ? element : null)
        .toList()
        .whereType<LabelStatusInfo>()
        .toList();

    emit(
      (state as StatusReadyState).copyWith(
        labelStatusList: emitList,
      ),
    );
  }
}
