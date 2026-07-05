import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/features/web_view/models/web_view_args.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({required this.args, super.key});

  final WebViewArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: BasicAppBar.buildPushStyle(
            context: context,
            titleAppBar: args.title,
            onBackPressed: context.pop,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          child: Text(
            args.content,
            style: AppTextStyle.body2.copyWith(height: 1.7),
          ),
        ),
      ),
    );
  }
}
