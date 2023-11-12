import 'package:collection/collection.dart';
import 'model.dart';

List<ProjectListItemInfo> dummyProjectList = [
  ProjectListItemInfo(
    projectId: '1',
    projectName: '某生命保険リプレース案件',
    themeColor: colorList[0].themeColor,
  ),
  ProjectListItemInfo(
    projectId: '2',
    projectName: '某小売業顧客管理システムリニューアル案件',
    themeColor: colorList[3].themeColor,
  ),
];

List<ProjectDetailItemInfo> dummyProjectDetailList = [
  ProjectDetailItemInfo(
    projectId: '1',
    projectName: '某生命保険リプレース案件',
    themeColorId: colorList[0].id,
    industry: '保険業',
    startDate: DateTime.parse('2011-09-01 00:00:00'),
    endDate: DateTime.parse('2011-12-01 00:00:00'),
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
  ProjectDetailItemInfo(
    projectId: '2',
    projectName: '某小売業顧客管理システムリニューアル案件',
    themeColorId: colorList[3].id,
    industry: '小売業',
    startDate: DateTime.parse('2017-06-01 00:00:00'),
    endDate: DateTime.parse('2019-12-01 00:00:00'),
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

final dummyBoardList = [
  BoardInfo(
    projectId: '1',
    boardId: '1',
    title: '作業中',
    taskItemList: [
      TaskItemInfo(
        boardId: '1',
        taskItemId: uuid.v4(),
        title: 'アカウント作成画面設計修正',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now().add(const Duration(days: 5)),
        labelList: tagList.slice(0, 2),
      ),
      TaskItemInfo(
        boardId: '1',
        taskItemId: uuid.v4(),
        title: '【TODO】',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList,
      ),
      TaskItemInfo(
        boardId: '1',
        taskItemId: uuid.v4(),
        title: 'ワークフロー一覧実装',
        description: 'ワークフロー一覧の新規実装',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList.slice(2, 4),
      ),
    ],
  ),
  BoardInfo(
    projectId: '1',
    boardId: '2',
    title: '完了',
    taskItemList: [
      TaskItemInfo(
        boardId: '2',
        taskItemId: uuid.v4(),
        title: 'Audio設定画面',
        description: 'アカウント作成画面の修正を行う。',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList.slice(1, 2),
      ),
      TaskItemInfo(
        boardId: '2',
        taskItemId: uuid.v4(),
        title: 'Voice & Search設定',
        description: 'ワークフロー一覧の新規実装',
        startDate: DateTime.parse('2023-07-30 00:00:00'),
        endDate: DateTime.now(),
        labelList: tagList.slice(3, 4),
      ),
    ],
  ),
];
