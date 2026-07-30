import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/widgets/app_bar/_custom_app_bar.dart';

class BasicAppBar {
  static final BasicAppBar _instance = BasicAppBar._internal();

  factory BasicAppBar() {
    return _instance;
  }

  BasicAppBar._internal();

  static CustomAppBar buildPushStyle({
    required BuildContext context,
    required String titleAppBar,
    String? subTitle,
    Function()? onBackPressed,
    Color backgroundColor = AppColors.background,
    List<Widget>? actions,
  }) {
    final bool isLightColor = backgroundColor.computeLuminance() > 0.5;
    return CustomAppBar(
      titleBar: titleAppBar,
      subTitle: subTitle,
      backgroundColor: backgroundColor,
      closeIcon: Icon(
        Icons.navigate_before,
        color: isLightColor ? AppColors.text : AppColors.whiteText,
        size: 32.0,
      ),
      onBackPressed: onBackPressed,
    );
  }

  static CustomAppBar buildPushStyleWithAction({
    required BuildContext context,
    required String titleAppBar,
    String? subTitle,
    Function()? onBackPressed,
    Color backgroundColor = AppColors.background,
    Widget? rightIcon,
  }) {
    final bool isLightColor = backgroundColor.computeLuminance() > 0.5;
    return CustomAppBar(
      titleBar: titleAppBar,
      subTitle: subTitle,
      backgroundColor: backgroundColor,
      closeIcon: Icon(
        Icons.navigate_before,
        color: isLightColor ? AppColors.text : AppColors.whiteText,
        size: 32.0,
      ),
      rightIcon: rightIcon,
      onBackPressed: onBackPressed,
    );
  }

  static CustomAppBar buildPresentStyle({
    required BuildContext context,
    required String titleAppBar,
    String? subTitle,
    Function()? onBackPressed,
    Color backgroundColor = AppColors.background,
  }) {
    final bool isLightColor = backgroundColor.computeLuminance() > 0.5;
    return CustomAppBar(
        titleBar: titleAppBar,
        subTitle: subTitle,
        backgroundColor: backgroundColor,
        closeIcon: Icon(
          Icons.close,
          color: isLightColor ? AppColors.text : AppColors.whiteText,
          size: 30.0,
        ),
        onBackPressed: onBackPressed);
  }

  static CustomAppBar buildPresentStyleWithAction({
    required BuildContext context,
    required String titleAppBar,
    String? subTitle,
    Function()? onBackPressed,
    Color backgroundColor = AppColors.background,
    Widget? rightIcon,
  }) {
    final bool isLightColor = backgroundColor.computeLuminance() > 0.5;
    return CustomAppBar(
        titleBar: titleAppBar,
        subTitle: subTitle,
        backgroundColor: backgroundColor,
        closeIcon: Icon(
          Icons.close,
          color: isLightColor ? AppColors.text : AppColors.whiteText,
          size: 30.0,
        ),
        rightIcon: rightIcon,
        onBackPressed: onBackPressed);
  }

  static CustomAppBar buildNoCloseStyle({required String titleAppBar}) {
    return CustomAppBar(
      titleBar: titleAppBar,
      onBackPressed: () {},
    );
  }

  static CustomAppBar buildDrawerStyle({
    required BuildContext context,
    String? titleAppBar,
    String? subTitle,
    Color backgroundColor = AppColors.background,
    Widget? leftWidget,
    List<Widget> actions = const [],
  }) {
    return CustomAppBar(
      titleBar: titleAppBar ?? '',
      subTitle: subTitle,
      backgroundColor: backgroundColor,
      closeIcon: leftWidget,
      onBackPressed: null,
      rightIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );
  }
}
