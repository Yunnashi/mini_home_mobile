import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';

class BasicTextField extends HookWidget {
  // --- 必須・よく使う ---
  final String? labelText;
  final String? hint;
  final String? initialValue;
  final ValueSetter<String>? onChanged;
  final List<String? Function(String?)?>? validators;

  // --- スタイル関連 ---
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry contentPadding;
  final double width;
  final bool enableShadow;

  // --- 入力制御 ---
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  // --- アイコン ---
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // --- セキュリティ・特殊動作 ---
  final bool isSecurity;
  final bool useSwitchObscureText;
  final bool clearText;

  const BasicTextField({
    super.key,
    this.labelText,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validators,
    this.textStyle = AppTextStyle.body1,
    this.hintStyle = AppTextStyle.placeHolder,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.grey,
    this.contentPadding = const EdgeInsets.all(12),
    this.width = 300,
    this.enableShadow = false,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.textCapitalization,
    this.inputFormatters,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.isSecurity = false,
    this.useSwitchObscureText = false,
    this.clearText = false,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(isSecurity);

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null
              ? Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(labelText!, style: AppTextStyle.body1),
                )
              : Container(),
          TextFormField(
            autovalidateMode:
                validators != null ? AutovalidateMode.onUserInteraction : null,
            validator: (value) {
              if (validators != null) {
                String? errorMessage;
                for (var validator in validators!) {
                  var result = validator!(value);
                  if (result != null) {
                    errorMessage = errorMessage == null
                        ? result
                        : "$errorMessage\n$result";
                  }
                }
                return errorMessage;
              }
              return null;
            },
            autofillHints: autofillHints,
            style: textStyle,
            focusNode: focusNode,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            obscureText: obscureText.value,
            onChanged: (text) {
              onChanged?.call(text);
            },
            keyboardType: keyboardType,
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              fillColor: backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              errorMaxLines: 10,
              errorStyle: const TextStyle(overflow: TextOverflow.visible),
              prefixIcon: prefixIcon,
              contentPadding: contentPadding,
              hintStyle: hintStyle,
              hintText: hint,
              suffixIcon: useSwitchObscureText
                  ? IconButton(
                      icon: Icon(
                        obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        obscureText.value = !obscureText.value;
                      },
                    )
                  : suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
