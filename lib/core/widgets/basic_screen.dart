import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/widgets/app_bar/_custom_app_bar.dart';
import 'package:mini_home/router/router.dart';

class BasicScreen extends StatelessWidget {
  final Widget body;
  final CustomAppBar? appBar;
  final Color? backgroundColor;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? bottomNavigationBar;

  const BasicScreen({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor = AppColors.background,
    this.scaffoldKey,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return PopScope(
      canPop: false,
      // Androidの端末に存在する戻るボタンの制御
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (context.canPop()) {
          context.pop();
        } else {
          // 戻る画面がない場合の処理
          final currentRoute = GoRouterState.of(context).name;
          if (currentRoute == AppRoutes.home) {
            // 現在がホーム画面の場合はアプリを最小化
            SystemNavigator.pop();
          } else {
            // その他の場合はアプリのホーム画面に遷移
            context.goNamed(AppRoutes.home);
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appBar?.backgroundColor ?? Colors.transparent,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: backgroundColor ?? Colors.transparent,
            child: Stack(children: <Widget>[
              body,
            ]),
          ),
        ),
      ),
    );
  }
}
