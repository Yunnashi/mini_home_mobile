import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';

/// Basic Widgets内でのみ利用する部品のため、他の画面で直接importしない
@immutable
class CustomAppBar extends HookWidget implements PreferredSizeWidget {
  final String titleBar;
  final String? subTitle;
  final Function()? onBackPressed;
  final Widget? closeIcon;
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final Widget? rightIcon;
  @override
  final Size preferredSize;

  const CustomAppBar({
    Key? key,
    required this.titleBar,
    this.subTitle,
    this.onBackPressed,
    this.closeIcon,
    this.backgroundColor = AppColors.background,
    this.titleTextStyle = AppTextStyle.heading1,
    this.rightIcon,
    this.preferredSize = const Size.fromHeight(56.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightColor = useMemoized(
      () => backgroundColor.computeLuminance() > 0.5,
      [backgroundColor],
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 8,
        right: 8,
        bottom: 6,
      ),
      child: SizedBox(
        height: preferredSize.height,
        child: Stack(
          children: [
            // タイトル・サブタイトル（中央配置）
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width - 120, // 左 48 + 右 72
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleBar,
                      style: titleTextStyle.copyWith(
                          color: isLightColor
                              ? AppColors.text
                              : AppColors.whiteText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    if (subTitle != null && subTitle!.isNotEmpty)
                      Text(
                        subTitle!,
                        style: AppTextStyle.body3TextGrey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
            // 左アイコン
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: closeIcon != null
                  ? Container(
                      alignment: Alignment.centerLeft,
                      height: preferredSize.height,
                      child: InkWell(
                        onTap: () {
                          if (onBackPressed != null) {
                            onBackPressed!();
                          } else {
                            if (GoRouter.of(context).canPop()) {
                              GoRouter.of(context).pop();
                            }
                          }
                        },
                        child: closeIcon,
                      ),
                    )
                  : Container(
                      width: 32,
                      height: preferredSize.height,
                    ),
            ),
            // 右アイコン
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: rightIcon != null
                  ? Container(
                      alignment: Alignment.center,
                      height: preferredSize.height,
                      child: rightIcon,
                    )
                  : Container(
                      width: 32,
                      height: preferredSize.height,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
