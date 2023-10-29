import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

// TODO: Delete
class ProjectListItemInfo {
  ProjectListItemInfo({
    required this.projectId,
    required this.projectName,
    required this.themeColor,
  });

  final String projectId;
  final String projectName;
  final Color themeColor;
}

// TODO: Delete
class ProjectDetailItemInfo {
  ProjectDetailItemInfo({
    required this.projectId,
    required this.projectName,
    required this.themeColorId,
    required this.industry,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.os = '',
    this.db = '',
    this.devLanguageList = const [],
    this.toolList = const [],
    this.devProgressList = const [],
    this.devSize = '',
    this.tagList = const [],
  });

  final String projectId;
  final String projectName;
  final String themeColorId;
  final String industry;
  final String startDate;
  final String endDate;
  final String description;
  final String os;
  final String db;
  final List<LinkTagInfo> devLanguageList;
  final List<Label> toolList;
  final List<Label> devProgressList;
  final String devSize;
  final List<ColorLabelInfo> tagList;
}

// TODO: Delete
class BoardInfo {
  BoardInfo({
    required this.projectId,
    required this.boardId,
    required this.title,
    required this.taskItemList,
  });
  final String projectId;
  final String boardId;
  final String title;
  final List<TaskItemInfo> taskItemList;
}

// TODO: Delete
class TaskItemInfo {
  TaskItemInfo({
    required this.boardId,
    required this.taskItemId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.labelList,
  });

  final String boardId;
  final String taskItemId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<ColorLabelInfo> labelList;

  TaskItemInfo copyWith({
    String? boardId,
    String? taskItemId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<ColorLabelInfo>? labelList,
  }) =>
      TaskItemInfo(
        boardId: boardId ?? this.boardId,
        taskItemId: taskItemId ?? this.taskItemId,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        labelList: labelList ?? this.labelList,
      );
}

// TODO: Delete
class LinkTagInfo {
  LinkTagInfo({
    required this.id,
    required this.inputValue,
    this.linkLabelList = const [],
  });
  final String id;
  final String inputValue;
  final List<ColorLabelInfo> linkLabelList;
}

// TODO: Delete
class ColorLabelInfo {
  ColorLabelInfo({
    required this.id,
    required this.labelName,
    required this.themeColor,
  });

  final String id;
  final String labelName;
  final Color themeColor;
}

// TODO: Delete
class ColorInfo {
  ColorInfo({
    required this.id,
    required this.themeColor,
  });

  final String id;
  final Color themeColor;
}

// TODO: Delete
class Label {
  Label({
    required this.id,
    required this.labelName,
  });

  final String id;
  final String labelName;
}

/// Dummy data
final colorList = [
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 255, 31, 31),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 7, 77, 255),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 239, 255, 8),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 11, 255, 3),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 10, 241, 161),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 0, 253, 249),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 255, 162, 1),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 228, 50, 255),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 255, 146, 146),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(246, 255, 182, 93),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(250, 247, 229, 118),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 133, 255, 120),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 123, 246, 252),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 121, 145, 254),
  ),
  ColorInfo(
    id: uuid.v4(),
    themeColor: const Color.fromARGB(255, 255, 136, 243),
  ),
];

String getIdByColor({required Color color}) {
  return colorList
      .firstWhere((item) => item.themeColor.value == color.value,
          orElse: () => colorList[0])
      .id;
}

ColorInfo getColorInfoById({required String id}) {
  return colorList.firstWhere((item) => item.id == id,
      orElse: () => colorList[0]);
}

final devProgressList = [
  Label(
    id: uuid.v4(),
    labelName: '要件定義',
  ),
  Label(
    id: uuid.v4(),
    labelName: '基本設計',
  ),
  Label(
    id: uuid.v4(),
    labelName: '詳細設計',
  ),
  Label(
    id: uuid.v4(),
    labelName: '開発・製造',
  ),
  Label(
    id: uuid.v4(),
    labelName: '単体テスト',
  ),
  Label(
    id: uuid.v4(),
    labelName: '結合テスト',
  ),
  Label(
    id: uuid.v4(),
    labelName: '運用テスト',
  ),
  Label(
    id: uuid.v4(),
    labelName: '保守・運用',
  ),
];

final toolList = [
  Label(
    id: uuid.v4(),
    labelName: 'VSCode',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'Intelli J',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'Eclipse',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'Git',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'Github',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'GitLab',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'Backlog',
  ),
  Label(
    id: uuid.v4(),
    labelName: 'A5',
  ),
];

final tagList = [
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '要件定義',
    themeColor: colorList[0].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '基本設計',
    themeColor: colorList[1].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '詳細設計',
    themeColor: colorList[2].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '画面設計書作成',
    themeColor: colorList[3].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: 'API設計書作成',
    themeColor: colorList[4].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '画面設計書修正',
    themeColor: colorList[5].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: 'API設計書修正',
    themeColor: colorList[6].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '新規実装',
    themeColor: colorList[7].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: '実装修正',
    themeColor: colorList[8].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: 'バグ対応',
    themeColor: colorList[9].themeColor,
  ),
  ColorLabelInfo(
    id: uuid.v4(),
    labelName: 'レビュー',
    themeColor: colorList[10].themeColor,
  ),
];
