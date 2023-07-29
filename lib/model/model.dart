import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

// TODO: Delete
class BoardDetailItemInfo {
  BoardDetailItemInfo({
    required this.boardId,
    required this.projectName,
    required this.themeColor,
    required this.industry,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.os = '',
    this.db = '',
    this.devLanguage = const [],
    this.tool = const [],
    this.devProgress = '',
    this.devSize = '',
    this.tag = const [],
  });

  final String boardId;
  final String projectName;
  final String themeColor;
  final String industry;
  final String startDate;
  final String endDate;
  final String description;
  final String os;
  final String db;
  final List<LinkTagInfo> devLanguage;
  final List<ColorLabelInfo> tool;
  final String devProgress;
  final String devSize;
  final List<ColorLabelInfo> tag;
}

// TODO: Delete
class LinkTagInfo {
  LinkTagInfo({
    required this.id,
    required this.inputValue,
    this.linkLabelList = const [],
  });
  final int id;
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

  final int id;
  final String labelName;
  final Color themeColor;
}

// TODO: Delete
class ColorInfo {
  ColorInfo({
    required this.id,
    required this.themeColor,
  });

  final int id;
  final Color themeColor;
}

// TODO: Delete
class Label {
  Label({
    required this.id,
    required this.labelName,
  });

  final int id;
  final String labelName;
}

/// Dummy data
final colorList = [
  ColorInfo(
    id: 1,
    themeColor: Color.fromARGB(255, 255, 31, 31),
  ),
  ColorInfo(
    id: 2,
    themeColor: Color.fromARGB(255, 7, 77, 255),
  ),
  ColorInfo(
    id: 3,
    themeColor: Color.fromARGB(255, 239, 255, 8),
  ),
  ColorInfo(
    id: 4,
    themeColor: Color.fromARGB(255, 11, 255, 3),
  ),
  ColorInfo(
    id: 5,
    themeColor: Color.fromARGB(255, 10, 241, 161),
  ),
  ColorInfo(
    id: 6,
    themeColor: Color.fromARGB(255, 0, 253, 249),
  ),
  ColorInfo(
    id: 7,
    themeColor: Color.fromARGB(255, 255, 162, 1),
  ),
  ColorInfo(
    id: 8,
    themeColor: Color.fromARGB(255, 228, 50, 255),
  ),
  ColorInfo(
    id: 9,
    themeColor: Color.fromARGB(255, 255, 146, 146),
  ),
  ColorInfo(
    id: 10,
    themeColor: Color.fromARGB(246, 255, 182, 93),
  ),
  ColorInfo(
    id: 11,
    themeColor: Color.fromARGB(250, 247, 229, 118),
  ),
  ColorInfo(
    id: 12,
    themeColor: Color.fromARGB(255, 133, 255, 120),
  ),
  ColorInfo(
    id: 13,
    themeColor: Color.fromARGB(255, 123, 246, 252),
  ),
  ColorInfo(
    id: 14,
    themeColor: Color.fromARGB(255, 121, 145, 254),
  ),
  ColorInfo(
    id: 15,
    themeColor: Color.fromARGB(255, 255, 136, 243),
  ),
];

int getIdByColor({required Color color}) {
  final a = color.value;
  final b = colorList
      .firstWhere((item) => item.themeColor.value == color.value,
          orElse: () => colorList[0])
      .id;

  return colorList
      .firstWhere((item) => item.themeColor.value == color.value,
          orElse: () => colorList[0])
      .id;
}

ColorInfo getColorInfoById({required int id}) {
  return colorList.firstWhere((item) => item.id == id,
      orElse: () => colorList[0]);
}

final devProgressList = [
  Label(
    id: 1,
    labelName: '要件定義',
  ),
  Label(
    id: 2,
    labelName: '基本設計',
  ),
  Label(
    id: 3,
    labelName: '詳細設計',
  ),
  Label(
    id: 4,
    labelName: '開発・製造',
  ),
  Label(
    id: 5,
    labelName: '単体テスト',
  ),
  Label(
    id: 6,
    labelName: '結合テスト',
  ),
  Label(
    id: 7,
    labelName: '運用テスト',
  ),
  Label(
    id: 8,
    labelName: '保守・運用',
  ),
];

final tagList = [
  ColorLabelInfo(
    id: 1,
    labelName: '要件定義',
    themeColor: colorList[0].themeColor,
  ),
  ColorLabelInfo(
    id: 2,
    labelName: '基本設計',
    themeColor: colorList[1].themeColor,
  ),
  ColorLabelInfo(
    id: 3,
    labelName: '詳細設計',
    themeColor: colorList[2].themeColor,
  ),
  ColorLabelInfo(
    id: 4,
    labelName: '画面設計書作成',
    themeColor: colorList[3].themeColor,
  ),
  ColorLabelInfo(
    id: 5,
    labelName: 'API設計書作成',
    themeColor: colorList[4].themeColor,
  ),
  ColorLabelInfo(
    id: 6,
    labelName: '画面設計書修正',
    themeColor: colorList[5].themeColor,
  ),
  ColorLabelInfo(
    id: 7,
    labelName: 'API設計書修正',
    themeColor: colorList[6].themeColor,
  ),
  ColorLabelInfo(
    id: 8,
    labelName: '新規実装',
    themeColor: colorList[7].themeColor,
  ),
  ColorLabelInfo(
    id: 9,
    labelName: '実装修正',
    themeColor: colorList[8].themeColor,
  ),
  ColorLabelInfo(
    id: 10,
    labelName: 'バグ対応',
    themeColor: colorList[9].themeColor,
  ),
  ColorLabelInfo(
    id: 11,
    labelName: 'レビュー',
    themeColor: colorList[10].themeColor,
  ),
];
