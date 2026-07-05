import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/screens/home/widgets/devices_widget.dart';
import 'package:mini_home/screens/home/widgets/welcome_widget.dart';
import 'package:mini_home/utils/logger.dart';

final homeScreenKey = GlobalKey();
final _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leftWidget = useState<Widget?>(null);
    final authStateAsync = ref.watch(authStateServiceProvider);

    // Logout状態はappBarにGroup名を表示しない。
    useEffect(() {
      authStateAsync.whenData((authState) {
        if (!authState.isLoggedIn) {
          leftWidget.value = null;
        }
      });
      return null;
    }, [authStateAsync]);

    return Consumer(
      builder: (context, ref, child) {
        return authStateAsync.when(
          data: (authState) {
            return BasicScreen(
              appBar: BasicAppBar.buildDrawerStyle(
                context: context,
                leftWidget: authState.isLoggedIn ? leftWidget.value : null,
              ),
              scaffoldKey: _scaffoldKey,
              body: authState.isLoggedIn
                  ? DevicesWidget(
                      authState,
                      onLeftWidgetChanged: (widget) {
                        leftWidget.value = widget;
                      },
                    )
                  : const WelcomeWidget(),
            );
          },
          loading: () => BasicScreen(
            appBar: BasicAppBar.buildDrawerStyle(
              context: context,
              leftWidget: null,
            ),
            scaffoldKey: _scaffoldKey,
            body: const CircularProgressIndicator(
              color: AppColors.lightGrey,
            ),
          ),
          error: (e, __) {
            safeDebugPrint("Error loading home screen: $e");
            return const Text("");
          },
        );
      },
    );
  }
}
