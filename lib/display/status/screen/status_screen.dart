import 'package:collection/collection.dart';
import 'package:stairs/loom/loom_package.dart';
import '../status_bloc.dart';
import '../component/stack_record.dart';
import '../component/label_record.dart';

const _kProjectTxt = 'プロジェクト名';
const _kDueTxt = '期間';
const _kRangeSpaceTxt = '-';
const _kOsTxt = '使用OS・機種';
const _kDevLangTxt = '開発言語';
const _kProgressTxt = '作業工程';
const _kDevSizeTxt = '開発人数';

const _kStackRecordSpace = 8.0;
const _kStatusContentPadding = EdgeInsets.symmetric(
  vertical: 8.0,
  horizontal: 24.0,
);
const _kLabelExpandedPadding = EdgeInsets.symmetric(
  vertical: 0.0,
  horizontal: 16.0,
);

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => StatusBloc(),
        ),
      ],
      child: BlocBuilder<StatusBloc, StatusState>(builder: (context, state) {
        final theme = LoomTheme.of(context);
        if (state is StatusInitialState) {
          context.read<StatusBloc>().add(const StatusInit());
          context.read<StatusBloc>().add(const StatusGetList(projectId: ''));
          return const SizedBox.shrink();
        } else if (state is StatusReadyState) {
          return Container(
            padding: _kStatusContentPadding,
            child: Column(
              children: [
                _ProjectContent(
                  projectName: state.selectedProjectDetail.projectName,
                  dueDate:
                      '${getFormattedDate(state.selectedProjectDetail.startDate)} $_kRangeSpaceTxt ${getFormattedDate(state.selectedProjectDetail.endDate)}',
                  devSize: state.selectedProjectDetail.devSize,
                  os: state.selectedProjectDetail.os,
                  devLanguage: state.selectedProjectDetail.devLanguageList
                      .map((e) => e.inputValue)
                      .join(', '),
                  devProgress: state.selectedProjectDetail.devProgressList
                      .map((e) => e.labelName)
                      .join(', '),
                ),
                ExpansionTile(
                  title: _LabelCountArea(
                    labelStatusList: state.labelStatusList.slice(
                        0,
                        state.labelStatusList.length > 6
                            ? 6
                            : state.labelStatusList.length),
                  ),
                  children: [
                    Padding(
                      padding: _kLabelExpandedPadding,
                      child: _LabelCountArea(
                        labelStatusList: state.labelStatusList
                            .slice(6, state.labelStatusList.length),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}

class _ProjectContent extends StatelessWidget {
  const _ProjectContent({
    required this.projectName,
    required this.dueDate,
    required this.devSize,
    required this.os,
    required this.devLanguage,
    required this.devProgress,
  });

  final String projectName;
  final String dueDate;
  final String devSize;
  final String os;
  final String devLanguage;
  final String devProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StackRecord(
          key: key,
          title: _kProjectTxt,
          content: projectName,
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
        StackRecord(
          key: key,
          title: _kDueTxt,
          content: dueDate,
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
        StackRecord(
          key: key,
          title: _kDevSizeTxt,
          content: '$devSize 人',
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
        StackRecord(
          key: key,
          title: _kOsTxt,
          content: os,
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
        StackRecord(
          key: key,
          title: _kDevLangTxt,
          content: devLanguage,
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
        StackRecord(
          key: key,
          title: _kProgressTxt,
          content: devProgress,
        ),
        const SizedBox(
          height: _kStackRecordSpace,
        ),
      ],
    );
  }
}

class _LabelCountArea extends StatelessWidget {
  const _LabelCountArea({
    required this.labelStatusList,
  });

  final List<LabelStatusInfo> labelStatusList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in labelStatusList) ...[
          LabelRecord(
            title: item.labelName,
            content: item.taskStatusList.length.toString(),
          )
        ]
      ],
    );
  }
}

String getFormattedDate(DateTime date) =>
    '${date.year}/${date.month}/${date.day}';
