import 'package:stairs/loom/loom_package.dart';

const _kStackRecordSpace = 16.0;
const _kTitleWidth = 120.0;

class StackRecord extends StatelessWidget {
  const StackRecord({
    super.key,
    this.width,
    required this.title,
    required this.content,
  });
  final double? width;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return Row(
      children: [
        SizedBox(
          width: _kTitleWidth,
          child: Text(
            title,
            style: theme.textStyleBody,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          width: _kStackRecordSpace,
        ),
        Text(
          content,
          style: theme.textStyleBody,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
