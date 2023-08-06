import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'model.dart';

List<BoardListItemInfo> dummyBoardList = [
  BoardListItemInfo(
    boardId: '1',
    projectName: '某生命保険リプレース案件',
    themeColor: colorList[0].themeColor,
  ),
  BoardListItemInfo(
    boardId: '2',
    projectName: '某小売業顧客管理システムリニューアル案件',
    themeColor: colorList[3].themeColor,
  ),
];

List<BoardDetailItemInfo> dummyBoardDetailList = [
  BoardDetailItemInfo(
    boardId: '1',
    projectName: '某生命保険リプレース案件',
    themeColorId: colorList[0].id,
    industry: '保険業',
    startDate: '2011-02-01 00:00:00',
    endDate: '2011-06-01 00:00:00',
    description: '某生命保険の社内管理システムリプレース案件に従事しました。',
    os: 'Windows10',
    db: 'MySQL',
    devLanguageList: [
      LinkTagInfo(
        id: uuid.v4(),
        inputValue: 'Java',
        linkLabelList: [
          tagList[0],
          tagList[1],
        ],
      ),
      LinkTagInfo(
        id: uuid.v4(),
        inputValue: 'Vue',
        linkLabelList: [
          tagList[4],
          tagList[5],
        ],
      ),
    ],
    toolList: toolList.slice(3),
    devProgressList: devProgressList.slice(5, 7),
    devSize: '50',
    tagList: tagList,
  ),
  BoardDetailItemInfo(
    boardId: '2',
    projectName: '某小売業顧客管理システムリニューアル案件',
    themeColorId: colorList[3].id,
    industry: '小売業',
    startDate: '2017-06-01 00:00:00',
    endDate: '2019-12-01 00:00:00',
    description: '某小売業顧客管理システムリニューアル案件に従事しました。',
    os: 'Windows10',
    db: 'MySQL, MariaDB',
    devLanguageList: [
      LinkTagInfo(
        id: uuid.v4(),
        inputValue: 'Java',
        linkLabelList: [
          tagList[0],
          tagList[1],
        ],
      ),
      LinkTagInfo(
        id: uuid.v4(),
        inputValue: 'Spring Boot',
        linkLabelList: [
          tagList[4],
          tagList[5],
        ],
      ),
    ],
    toolList: toolList.slice(3),
    devProgressList: devProgressList.slice(5, 7),
    devSize: '120',
    tagList: tagList,
  ),
];

final dummyWorkBoardList = [
  WorkBoard(
    workBoardId: '1',
    title: '作業中',
    themeColor: colorList[4].themeColor,
    workBoardItemList: [
      WorkBoardItemInfo(
        workBoardId: '1',
        workBoardItemId: uuid.v4(),
        title: 'アカウント作成画面設計修正',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
      WorkBoardItemInfo(
        workBoardId: '1',
        workBoardItemId: uuid.v4(),
        title: '【TODO】',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
      WorkBoardItemInfo(
        workBoardId: '1',
        workBoardItemId: uuid.v4(),
        title: 'ワークフロー一覧実装',
        description: 'ワークフロー一覧の新規実装',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
    ],
  ),
  WorkBoard(
    workBoardId: '2',
    title: '完了',
    themeColor: colorList[5].themeColor,
    workBoardItemList: [
      WorkBoardItemInfo(
        workBoardId: '2',
        workBoardItemId: uuid.v4(),
        title: 'Audio設定画面',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
      WorkBoardItemInfo(
        workBoardId: '2',
        workBoardItemId: uuid.v4(),
        title: 'Voice &nSearch設定',
        description: 'ワークフロー一覧の新規実装',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
    ],
  ),
];
