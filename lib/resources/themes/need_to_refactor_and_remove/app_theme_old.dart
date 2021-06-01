import 'app_colors_old.dart';
import 'app_text_styles_old.dart';

class AppThemeOld {
  final AppColorsOld colors;
  final AppTextStylesOld textStyles;

  AppThemeOld({this.colors, this.textStyles});

  factory AppThemeOld.defaultTheme() {
    return _default();
  }

  AppThemeOld copyWith({
    AppColorsOld colors,
    AppTextStylesOld textStyles,
  }) {
    return AppThemeOld(
      colors: colors ?? this.colors,
      textStyles: textStyles ?? this.textStyles,
    );
  }
}

AppThemeOld _default() {
  return AppThemeOld(
    colors: AppColorsOld.defaultColors(),
    textStyles: AppTextStylesOld.defaultTextStyles(),
  );
}
