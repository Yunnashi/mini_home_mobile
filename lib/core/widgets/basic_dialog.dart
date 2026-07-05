import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';

class BasicDialog {
  static final BasicDialog _instance = BasicDialog._internal();
  static final Set<String> _openDialogs = {}; // 現在表示されているダイアログのタイトルを保持

  BasicDialog._internal();

  factory BasicDialog() {
    return _instance;
  }

  /// 現在、何らかのBasicDialogが表示中かどうか
  static bool get hasOpenDialog => _openDialogs.isNotEmpty;

  /// カスタマイズ可能なダイアログ。
  ///
  /// [context] ダイアログを表示するためのビルドコンテキスト
  /// [title] ダイアログのタイトル
  /// [content] ダイアログのコンテンツ
  /// [buttons] ダイアログのボタンウェジットを配列として格納
  /// [barrierDismissible] ダイアログの外側をタップして閉じることができるかどうか(デフォルトはtrue)
  /// [onNavigatorReady] ダイアログのNavigatorStateが取得できた時に呼ばれるコールバック（プログラムから閉じる必要がある場合に使用）
  static Future<void> show({
    required BuildContext context,
    required String title,
    Widget? content,
    List<Widget>? buttons,
    bool barrierDismissible = true,
    void Function(NavigatorState)? onNavigatorReady,
  }) async {
    if (_openDialogs.contains(title)) return; // 同じタイトルのダイアログがすでに表示されていたらスキップ

    _openDialogs.add(title); // ダイアログのタイトルを登録

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        // NavigatorStateを取得してコールバックで渡す
        if (onNavigatorReady != null) {
          final navigator = Navigator.of(dialogContext);
          onNavigatorReady(navigator);
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - (16 * 2 + 20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final hasButtons = buttons != null && buttons.isNotEmpty;
                // 実高さ・パディングのばらつきでオーバーフローしないよう余裕を持たせる
                const buttonAreaBuffer = 12.0;
                final buttonHeight = hasButtons
                    ? (buttons.length * 56.0 + (buttons.length - 1) * 12.0) +
                        buttonAreaBuffer
                    : 0.0;
                final spacingAboveButtons = 44.0;
                final maxScrollHeight = hasButtons
                    ? (constraints.maxHeight -
                            buttonHeight -
                            spacingAboveButtons)
                        .clamp(0.0, double.infinity)
                    : constraints.maxHeight;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxScrollHeight,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  title,
                                  style: AppTextStyle.heading1,
                                ),
                              ),
                              if (content != null) ...[
                                const SizedBox(height: 44),
                                content,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (hasButtons) ...[
                      const SizedBox(height: 44),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...buttons.map((button) => Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: button,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    _openDialogs.remove(title); // ダイアログが閉じられたら削除
  }

  static Future<void> showError({
    required BuildContext context,
    String title = "",
    String? customMessage,
    String? errorMessage,
    String? errorCode,
    bool barrierDismissible = false,
    String? retryButtonText,
    VoidCallback? retryAction,
    VoidCallback? dismissAction,
  }) async {
    if (title.isEmpty) {
      title = AppStrings.error;
    }

    if (_openDialogs.contains(title)) return; // 同じタイトルのエラーがすでに表示されていたらスキップ

    _openDialogs.add(title);

    final contents = [
      if (errorMessage != null) errorMessage,
      if (errorCode != null) "($errorCode)",
      if (customMessage != null && (errorMessage != null || errorCode != null))
        "\n",
      if (customMessage != null) customMessage,
    ].join();

    final buttons = retryAction != null
        ? <Widget>[
            BasicDialogButton(retryButtonText ?? AppStrings.retry, retryAction,
                ButtonType.contained, AppColors.primary),
            BasicDialogButton.cancel(
              text: AppStrings.close,
              callback: dismissAction,
            ),
          ]
        : <Widget>[BasicDialogButton.ok(callback: dismissAction)];

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    title,
                    style: AppTextStyle.heading1,
                  ),
                ),
                if (contents.isNotEmpty) ...[
                  const SizedBox(height: 44),
                  Text(contents),
                ],
                if (buttons.isNotEmpty) ...[
                  const SizedBox(height: 44),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...buttons.map((button) => Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: button,
                            )),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    _openDialogs.remove(title);
  }
}

/// 頻出度の高いシンプルアクションボタン（OKボタン、キャンセルボタンなど）を定義。
/// BasicDialogのButtonsの配列内に格納する。
/// Buttonsには、BasicButtonをいれてカスタマイズするしたり、BasicDialogButtonと併用することも可能。
///
/// 使用例:
/// ```
/// BasicDialog.show(
///   context: context,
///   title: AppStrings.titleDialogRetryPayment,
///   content: Text(AppStrings.contentDialogRetryPayment),
///   barrierDismissible: true,
///   buttons: [
///     BasicButton.buildLarge(
///       text: AppStrings.retryPaymentWithCurrentCreditCard,
///       buttonType: ButtonType.contained,
///       onPressed: () {
///         // 処理を記述
///       },
///     ),
///     BasicButton.buildLarge(
///       text: AppStrings.retryPaymentWithNewMethod,
///       buttonType: ButtonType.outlined,
///       onPressed: () {
///         // 処理を記述
///       },
///     ),
///     BasicDialogButton.cancel(),
///   ],
/// );
/// ```
class BasicDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback? callback;
  final ButtonType buttonType;
  final Color color;
  final bool autoClose;
  final EdgeInsetsGeometry? padding;

  const BasicDialogButton(this.text, this.callback, this.buttonType, this.color,
      {super.key, this.autoClose = true, this.padding});

  @override
  Widget build(BuildContext context) {
    return BasicButton.buildLarge(
      text: text,
      shapeType: ShapeType.rounded,
      buttonType: buttonType,
      color: color,
      padding: padding,
      onPressed: () {
        // autoCloseがtrueの場合、ボタン押下時に自動的にダイアログを閉じる
        if (GoRouter.of(context).canPop() && autoClose) {
          GoRouter.of(context).pop();
        }
        callback?.call();
      },
    );
  }

  /// OKボタン
  /// [text] ボタンのテキスト
  /// [callback] ボタンが押されたときに実行されるコールバック関数。
  /// [color] ボタンの色
  static BasicDialogButton ok({
    String text = '',
    VoidCallback? callback,
    Color color = AppColors.primary,
    bool autoClose = true,
  }) {
    if (text == '') {
      text = AppStrings.ok;
    }
    ButtonType buttonType = ButtonType.contained;
    return BasicDialogButton(text, callback, buttonType, color,
        autoClose: autoClose);
  }

  /// キャンセルボタン
  static BasicDialogButton cancel({
    String text = '',
    VoidCallback? callback,
    Color color = AppColors.text,
    bool autoClose = true,
  }) {
    if (text == '') {
      text = AppStrings.cancel;
    }
    ButtonType buttonType = ButtonType.text;
    return BasicDialogButton(
      text,
      callback,
      buttonType,
      color,
      autoClose: autoClose,
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 11),
    );
  }
}
