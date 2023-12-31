import 'package:stairs/loom/loom_package.dart';

import '../project_detail_bloc.dart';
import '../../../model/model.dart';

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

const _kProjectAndBoardSpace = 30.0;

class ProjectEditModal extends StatelessWidget {
  const ProjectEditModal({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    if (projectId.isEmpty) {
      context.read<ProjectDetailBloc>().add(const Init());
    } else {
      context
          .read<ProjectDetailBloc>()
          .add(ProjectGetDetail(projectId: projectId));
    }
    return BlocBuilder<ProjectDetailBloc, ProjectDetailBlocState>(
      builder: (context, state) {
        return Modal(
          buildMainContent: Column(
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
                icon: Icon(
                  Icons.assessment,
                  color: theme.colorPrimary,
                ),
                inputValue: state.projectName,
                hintText: _kProjectHintTxt,
                onSubmitted: (projectName) => context
                    .read<ProjectDetailBloc>()
                    .add(ProjectChangeProjectName(projectName: projectName)),
              ),
              // 色,
              CardLstItem.labeWithIcon(
                label: _kColorTxt,
                iconColor: theme.colorPrimary,
                iconData: Icons.palette,
                hintText: _kColorHintTxt,
                itemList: [
                  ColorBox(
                    color: state.colorInfo.themeColor,
                  ),
                ],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectColorDisplay(
                        title: _kColorTxt,
                        selectedColorInfo: state.colorInfo,
                        onTap: (id) {},
                        onTapBackIcon: (colorInfo) {
                          context.read<ProjectDetailBloc>().add(
                                ProjectChangeThemeColor(colorInfo: colorInfo),
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              // 業種
              CardLstItem.input(
                icon: Icon(
                  theme.icons.trash,
                  color: theme.colorPrimary,
                ),
                inputValue: state.industry,
                hintText: _kIndustryHintTxt,
                onSubmitted: (industry) => context
                    .read<ProjectDetailBloc>()
                    .add(ProjectChangeIndustry(industry: industry)),
              ),
              // 期日
              CardLstItem.labeWithIcon(
                label: _kDueTxt,
                iconColor: theme.colorPrimary,
                iconData: theme.icons.calender,
                hintText: _kDueHintTxt,
                itemList: [
                  DateRange(
                    startDate: state.startDate,
                    endDate: state.endDate,
                  )
                ],
                onTap: () async {
                  final bloc = context.read<ProjectDetailBloc>();
                  DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(
                      start: state.startDate,
                      end: state.endDate,
                    ),
                    firstDate: DateTime(1990, 1, 1),
                    lastDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.input,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary:
                                LoomTheme.of(context).colorPrimary, // ヘッダー背景色
                            onPrimary: LoomTheme.of(context)
                                .colorBgLayer1, // ヘッダーテキストカラー
                            onSurface: LoomTheme.of(context)
                                .colorFgDefault, // カレンダーのテキストカラー
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (range != null) {
                    bloc.add(
                      ProjectChangeDueDate(
                        startDate: range.start,
                        endDate: range.end,
                      ),
                    );
                  }
                },
              ),
              // 業務内容
              CardLstItem.input(
                icon: Icon(
                  theme.icons.trash,
                  color: theme.colorPrimary,
                ),
                inputValue: state.description,
                hintText: _kContentHintTxt,
                maxLength: _kContentMaxLength,
                onSubmitted: (description) => context
                    .read<ProjectDetailBloc>()
                    .add(ProjectChangeDescription(description: description)),
              ),
              // OS
              CardLstItem.input(
                  icon: Icon(
                    Icons.laptop_chromebook,
                    color: theme.colorPrimary,
                  ),
                  inputValue: state.os,
                  hintText: _kOsHintTxt,
                  onSubmitted: (os) => context
                      .read<ProjectDetailBloc>()
                      .add(ProjectChangeOs(os: os))),
              // DB
              CardLstItem.input(
                icon: Icon(
                  Icons.data_array,
                  color: theme.colorPrimary,
                ),
                inputValue: state.db,
                hintText: _kDbHintTxt,
                onSubmitted: (db) => context
                    .read<ProjectDetailBloc>()
                    .add(ProjectChangeDb(db: db)),
              ),
              // 開発言語
              CardLstItem.labeWithIcon(
                label: _kDevLangTxt,
                iconColor: theme.colorPrimary,
                iconData: theme.icons.resume,
                hintText: _kDevLangHintTxt,
                itemList: [
                  for (final item in context
                      .read<ProjectDetailBloc>()
                      .state
                      .devLanguageList)
                    LabelTip(
                      label: item.inputValue,
                      themeColor: theme.colorFgDisabled,
                    )
                ],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LinkTagDisplay(
                        title: _kDevLangTxt,
                        linkTagList: state.devLanguageList,
                        onTextSubmitted: (value) {},
                        onTap: (id) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return SelectItemModal(
                                id: id,
                                title: getSelectItemDisplayTitle(
                                    context: context, id: id),
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                labelList: context
                                    .read<ProjectDetailBloc>()
                                    .state
                                    .tagList,
                                selectedLabelList: getDevLangSelectedLabelList(
                                    context: context, id: id),
                                onTapListItem: (linkLabelList) {
                                  context.read<LinkTagDisplayBloc>().add(
                                        UpdateLinkLabelList(
                                            id: id,
                                            linkLabelList: linkLabelList),
                                      );
                                },
                              );
                            },
                          );
                        },
                        onTapBack: (data) {
                          context.read<ProjectDetailBloc>().add(
                                ProjectChangeDevLanguageList(
                                    devLanguageList:
                                        (data as List<LinkTagInfo>)),
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
                itemList: [
                  for (final item
                      in context.read<ProjectDetailBloc>().state.toolList)
                    LabelTip(
                      label: item.labelName,
                      themeColor: theme.colorFgDisabled,
                    )
                ],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return InputToolDisplay(
                        title: _kToolTxt,
                        toolList: state.toolList,
                        onTapBack: (data) {
                          context.read<ProjectDetailBloc>().add(
                                ProjectChangeToolList(
                                    toolList: (data as List<Label>)),
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              // 作業工程
              CardLstItem.labeWithIcon(
                label: _kProgressTxt,
                iconColor: theme.colorPrimary,
                iconData: theme.icons.resume,
                hintText: _kProgressHintTxt,
                itemList: [
                  for (final item in context
                      .read<ProjectDetailBloc>()
                      .state
                      .devProgressList)
                    LabelTip(
                      label: item.labelName,
                      themeColor: theme.colorFgDisabled,
                    )
                ],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectLabelDisplay(
                        title: _kProgressTxt,
                        selectedLabelList: context
                            .read<ProjectDetailBloc>()
                            .state
                            .devProgressList,
                        onTap: (id) {},
                        onTapBackIcon: (labelList) {
                          context.read<ProjectDetailBloc>().add(
                                ProjectChangeDevProgressList(
                                    devProgressList: labelList),
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              // 開発人数
              CardLstItem.input(
                  inputType: TextInputType.number,
                  inputValue: state.devSize,
                  icon: Icon(
                    Icons.group,
                    color: theme.colorPrimary,
                  ),
                  hintText: _kDevSizeHintTxt,
                  onSubmitted: (devSize) => context
                      .read<ProjectDetailBloc>()
                      .add(ProjectChangeDevSize(devSize: devSize))),
              const SizedBox(
                height: _kProjectAndBoardSpace,
              ),
              CardLstItem.header(
                title: _kBoardTitleTxt,
                bgColor: theme.colorBgLayer1,
              ),
              // ラベル,
              CardLstItem.labeWithIcon(
                label: _kLabelTxt,
                iconColor: theme.colorPrimary,
                iconData: Icons.label,
                hintText: _kLabelHintTxt,
                itemList: [
                  for (final item
                      in context.read<ProjectDetailBloc>().state.tagList)
                    LabelTip(
                      label: item.labelName,
                      themeColor: item.themeColor,
                    )
                ],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return InputTagDisplay(
                        title: _kLabelTxt,
                        tagList: state.tagList,
                        onTapBack: (data) {
                          context.read<ProjectDetailBloc>().add(
                                ProjectChangeTagList(
                                    tagList: (data as List<ColorLabelInfo>)),
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: _kProjectAndBoardSpace,
              ),
            ],
          ),
        );
      },
    );
  }

  List<ColorLabelInfo> getDevLangSelectedLabelList(
      {required BuildContext context, required String id}) {
    return (context.read<LinkTagDisplayBloc>().state
            as LinkTagDisplayGetInfoState)
        .linkTagList
        .firstWhere(
          (element) => element.id == id,
          orElse: () => LinkTagInfo(
            id: uuid.v4(),
            inputValue: '',
            linkLabelList: [],
          ),
        )
        .linkLabelList;
  }

  String getSelectItemDisplayTitle(
      {required BuildContext context, required String id}) {
    return (context.read<LinkTagDisplayBloc>().state
            as LinkTagDisplayGetInfoState)
        .linkTagList
        .firstWhere(
          (element) => element.id == id,
          orElse: () => LinkTagInfo(
            id: uuid.v4(),
            inputValue: '',
            linkLabelList: [],
          ),
        )
        .inputValue;
  }
}
