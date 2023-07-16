import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loom/theme.dart';
import '../../loom/component/modal/modal.dart';
import '../../loom/component/list_item/card_list_item.dart';
import '../board_detail_bloc.dart';
import '../../loom/display/input_link_tag_display.dart';
import '../../model/model.dart';

const _kProjectTitleTxt = 'プロジェクト';
const _kProjectHintTxt = 'プロジェクト名';
const _kColorTxt = '色';
const _kColorHintTxt = 'メインテーマを設定';
const _kIndustryHintTxt = '業種';
const _kDueTxt = '期間';
const _kDueHintTxt = '期間を設定';
const _kContentHintTxt = '業務内容';
const _kContentMaxLength = 500;
const _kOsHintTxt = '使用OS・機種';
const _kDbHintTxt = '使用DB';
const _kDevLangTxt = '開発言語';
const _kDevLangHintTxt = '開発言語、フレームワークを設定';

const _kToolTxt = '開発ツール';
const _kToolHintTxt = '使用したツールを設定（Backlog, Miro, Figmaなど）';
const _kProgressTxt = '作業工程';
const _kProgressHintTxt = '携わった作業工程を設定';
const _kDevSizeHintTxt = '開発人数を設定';

const _kBoardTitleTxt = 'ボード';
const _kLabelTxt = 'ラベル';
const _kLabelHintTxt = 'ラベルを設定';

const _kTrailingWidth = 30.0;
const _kIconSize = 24.0;

const _kProjectAndBoardSpace = 30.0;

class BoardModal extends Modal {
  const BoardModal({
    super.key,
    this.boardId,
  });

  final String? boardId;

  @override
  Widget buildLeadingContent(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        theme.icons.close,
      ),
      iconSize: _kIconSize,
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildTrailingContent(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: _kTrailingWidth,
      child: IconButton(
        icon: Icon(
          theme.icons.done,
        ),
        color: theme.colorPrimary,
        iconSize: _kIconSize,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget buildMainContent(BuildContext context) {
    final theme = Theme.of(context);
    // if (boardId == null) {
    //   context.read<BoardDetailBloc>().add(const Init());
    // } else {
    //   context.read<BoardDetailBloc>().add(BoardGetDetail(boardId: boardId!));
    // }
    return
        // BlocProvider(
        //   create: (_) => BoardDetailBloc(),
        //   child:
        BlocBuilder<BoardDetailBloc, BoardDetailBlocState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CardLstItem.header(
              title: _kProjectTitleTxt,
              bgColor: theme.colorBgLayer1,
            ),
            // プロジェクト名,
            CardLstItem.input(
              iconColor: theme.colorPrimary,
              iconData: Icons.assessment,
              inputValue: state.projectName,
              hintText: _kProjectHintTxt,
              onSubmitted: (projectName) => context
                  .read<BoardDetailBloc>()
                  .add(BoardChangeProjectName(projectName: projectName)),
            ),
            // 色,
            CardLstItem.labeWithIcon(
              label: _kColorTxt,
              iconColor: theme.colorPrimary,
              iconData: Icons.palette,
              hintText: _kColorHintTxt,
              itemList: [],
              onTap: () {},
            ),
            // 業種
            CardLstItem.input(
              iconColor: theme.colorPrimary,
              iconData: theme.icons.trash,
              inputValue: state.industry,
              hintText: _kIndustryHintTxt,
              onSubmitted: (industry) => context
                  .read<BoardDetailBloc>()
                  .add(BoardChangIndustry(industry: industry)),
            ),
            // 期日
            CardLstItem.labeWithIcon(
              label: _kDueTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.calender,
              hintText: _kDueHintTxt,
              itemList: [],
              onTap: () {},
            ),
            // 業務内容
            CardLstItem.input(
              iconColor: theme.colorPrimary,
              iconData: theme.icons.trash,
              inputValue: state.description,
              hintText: _kContentHintTxt,
              maxLength: _kContentMaxLength,
              onSubmitted: (description) => context
                  .read<BoardDetailBloc>()
                  .add(BoardChangDescription(description: description)),
            ),
            // OS
            CardLstItem.input(
                iconColor: theme.colorPrimary,
                iconData: Icons.laptop_chromebook,
                inputValue: state.os,
                hintText: _kOsHintTxt,
                onSubmitted: (os) =>
                    context.read<BoardDetailBloc>().add(BoardChangeOs(os: os))),
            // DB
            CardLstItem.input(
              iconColor: theme.colorPrimary,
              iconData: Icons.data_array,
              inputValue: state.db,
              hintText: _kDbHintTxt,
              onSubmitted: (db) =>
                  context.read<BoardDetailBloc>().add(BoardChangeDb(db: db)),
            ),
            // 開発言語
            CardLstItem.labeWithIcon(
              label: _kDevLangTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.resume,
              hintText: _kDevLangHintTxt,
              itemList: [],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InputLinkTagDisplay(
                      title: _kDevLangTxt,
                      linkTagList: state.devLanguageList,
                      onTextSubmitted: (value) {},
                      onTap: () {},
                      onTapBack: (data) {
                        context.read<BoardDetailBloc>().add(
                              BoardChangDevLanguageList(
                                  devLanguageList: (data as List<LinkTagInfo>)),
                            );
                      },
                    );
                  },
                ),
              ),
            ),
            // 開発ツール,
            CardLstItem.labeWithIcon(
              label: _kToolTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.resume,
              hintText: _kToolHintTxt,
              itemList: [],
              onTap: () {},
            ),
            // 作業工程
            CardLstItem.labeWithIcon(
              label: _kProgressTxt,
              iconColor: theme.colorPrimary,
              iconData: theme.icons.resume,
              hintText: _kProgressHintTxt,
              itemList: [],
              onTap: () {},
            ),
            // 開発人数
            CardLstItem.input(
                inputType: TextInputType.number,
                iconColor: theme.colorPrimary,
                inputValue: state.devSize,
                iconData: Icons.group,
                hintText: _kDevSizeHintTxt,
                onSubmitted: (devSize) => context
                    .read<BoardDetailBloc>()
                    .add(BoardChangeDevSize(devSize: devSize))),
            const SizedBox(
              height: _kProjectAndBoardSpace,
            ),
            CardLstItem.header(
              title: _kBoardTitleTxt,
              bgColor: theme.colorBgLayer1,
            ),
            // ラベル
            CardLstItem.labeWithIcon(
              label: _kLabelTxt,
              iconColor: theme.colorPrimary,
              iconData: Icons.label,
              hintText: _kLabelHintTxt,
              itemList: [],
              onTap: () {},
            ),
            const SizedBox(
              height: _kProjectAndBoardSpace,
            ),
          ],
        );
      },
    );
  }
}
