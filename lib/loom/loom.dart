import 'package:stairs/loom/loom_theme_data.dart';
import 'constant/day_color.dart';
import 'constant/icons.dart';
import 'constant/text_style.dart';

class Loom {
  const Loom._();

// ダークモードの対応をするなら修正
  static final themeDataFor = LoomThemeData(
    icons: loomIcons,
    colorBgLayer1: colorBgLayer1,
    colorPrimary: colorPrimary,
    colorSecondary: colorSecondary,
    colorDisabled: colorDisabled,
    colorDangerBgDefault: colorDangerBgDefault,
    colorFgDefault: colorFgDefault,
    colorFgDefaultWhite: colorFgDefaultWhite,
    colorFgDisabled: colorFgDisabled,
    colorFgStrong: colorFgStrong,
    colorFgSubtitle: colorFgSubtitle,
    textStyleBody: textStyleBody(colorFgDefault),
    textStyleFootnote: textStyleFootnote(colorFgDisabled),
    textStyleTitle: textStyleTitle(colorPrimary),
    textStyleSubtitle: textStyleSubtitle(colorPrimary),
    textStyleHeading: textStyleHeading(colorPrimary),
    textStyleSubHeading: textStyleSubHeading(colorPrimary),
  );
}
