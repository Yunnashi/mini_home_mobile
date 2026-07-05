import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/text_style.dart';

class ErrorMessageView extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;

  const ErrorMessageView({
    Key? key,
    required this.message,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 3,
          horizontal: 16.0,
        );
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: AppTextStyle.body1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
