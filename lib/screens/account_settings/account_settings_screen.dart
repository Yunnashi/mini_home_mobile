import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/features/user/services/user_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/basic_item_setting.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';

class AccountSettingsScreen extends HookConsumerWidget {
  const AccountSettingsScreen({super.key});

  void _onBackWhenWithdrawComplete(BuildContext context) {
    context.pop("withdraw complete");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState<String?>("");
    final userService = ref.read(userServiceProvider.notifier);

    // useEffectでemailを取得
    useEffect(() {
      Future<void> getEmail() async {
        final user = await userService.getCurrentUser();
        email.value = user?.email;
      }

      getEmail();
      return null;
    }, []);

    return BasicScreen(
        appBar: BasicAppBar.buildPushStyle(
            context: context, titleAppBar: AppStrings.accountSettingsTitle),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Column(
                  children: [
                    BasicItemSetting(
                      onTap: () {},
                      title: AppStrings.lblEmail,
                      detailTxt: email.value,
                    ),
                    BasicItemSetting(
                        onTap: () {
                          context.pushNamed(AppRoutes.passwordChange);
                        },
                        title: AppStrings.passwordChangeTitle,
                        icon: Icons.navigate_next,
                        isEndOfItem: true),
                    const SizedBox(height: 40),
                    BasicItemSetting(
                        onTap: () async {
                          final result =
                              await context.pushNamed(AppRoutes.withdrawal);
                          if (result != null && result == "withdraw complete") {
                            if (context.mounted) {
                              _onBackWhenWithdrawComplete(context);
                            }
                          }
                        },
                        title: AppStrings.withdrawalTitle,
                        icon: Icons.navigate_next,
                        isEndOfItem: true),
                  ],
                ))));
  }
}
