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
  final List<LabelInfo> tool;
  final String devProgress;
  final String devSize;
  final List<LabelInfo> tag;
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
  final List<LabelInfo> linkLabelList;
}

// TODO: Delete
class LabelInfo {
  LabelInfo({
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
