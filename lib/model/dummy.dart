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
