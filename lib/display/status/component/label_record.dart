import 'package:stairs/loom/loom_package.dart';

const _kStackRecordSpace = 8.0;
const _kIconSize = 24.0;
const _kTitleWidth = 120.0;

class LabelRecord extends StatelessWidget {
  const LabelRecord({
    super.key,
    this.width,
    this.leafIcon,
    required this.title,
    required this.content,
  });
  final double? width;
  final IconData? leafIcon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = LoomTheme.of(context);
    return SizedBox(
      width: width,
      child: Row(
        children: [
          if (leafIcon != null)
            Icon(
              leafIcon,
              size: _kIconSize,
            ),
          const SizedBox(
            width: _kStackRecordSpace,
          ),
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
            ':',
            style: theme.textStyleBody,
            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
