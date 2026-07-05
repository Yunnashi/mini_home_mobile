import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';

enum ButtonType { text, outlined, contained }

enum ShapeType { square, rounded }

/// Basic Widgets内でのみ利用する部品のため、他の画面で直接importしない
class CustomButton extends StatelessWidget {
  final double _borderRadius = 8;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final ButtonType buttonType;

  const CustomButton(
      {Key? key,
      required this.text,
      this.backgroundColor = AppColors.white,
      this.textColor = AppColors.text,
      this.textStyle = const TextStyle(),
      this.borderRadius,
      this.margin,
      this.padding,
      this.width,
      this.buttonType = ButtonType.contained,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: MaterialButton(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? _borderRadius),
          side: buttonType == ButtonType.outlined
              ? BorderSide(width: 1, color: textStyle.color ?? textColor)
              : BorderSide.none,
        ),
        color: backgroundColor,
        padding: padding ??
            const EdgeInsets.only(left: 11, right: 11, top: 14, bottom: 14),
        textColor: textColor,
        minWidth: 52,
        onPressed: onPressed,
        child: Center(
          // Centerウィジェットでラップしてテキストを中央揃えにする
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

// normal, selectd, disable - text, titleColor, backgroundColor, font
