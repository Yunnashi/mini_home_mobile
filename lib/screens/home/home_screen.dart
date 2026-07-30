import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/widgets/app_bar/basic_app_bar.dart';
import 'package:mini_home/core/widgets/basic_screen.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/screens/drawer/setting_drawer.dart';
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
    final selectedTabIndex = useState(0);
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
                leftWidget: authState.isLoggedIn && selectedTabIndex.value == 0
                    ? leftWidget.value
                    : null,
                actions: authState.isLoggedIn && selectedTabIndex.value == 0
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _AddActionButton(
                            icon: Icons.add_rounded,
                            label: AppStrings.addDevice,
                            onPressed: () {
                              context.pushNamed(
                                AppRoutes.deviceRegistration,
                                extra: authState,
                              );
                            },
                          ),
                        ),
                      ]
                    : const [],
              ),
              scaffoldKey: _scaffoldKey,
              body: authState.isLoggedIn
                  ? selectedTabIndex.value == 4
                      ? const SettingDrawer(embedded: true)
                      : DevicesWidget(
                          authState,
                          onLeftWidgetChanged: (widget) {
                            leftWidget.value = widget;
                          },
                        )
                  : const WelcomeWidget(),
              bottomNavigationBar: authState.isLoggedIn
                  ? _MiniHomeBottomBar(
                      selectedIndex: selectedTabIndex.value,
                      onDestinationSelected: (index) {
                        selectedTabIndex.value = index;
                      },
                    )
                  : null,
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

class _AddActionButton extends StatelessWidget {
  const _AddActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.text,
          size: 30,
        ),
      ),
    );
  }
}

class _MiniHomeBottomBar extends StatelessWidget {
  const _MiniHomeBottomBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomBarItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: AppStrings.homeTab,
              selected: selectedIndex == 0,
              onTap: () => onDestinationSelected(0),
            ),
            _BottomBarItem(
              icon: Icons.help_outline_rounded,
              selectedIcon: Icons.help_rounded,
              label: AppStrings.supportTab,
              selected: selectedIndex == 2,
              onTap: () => onDestinationSelected(2),
            ),
            _BottomBarItem(
              icon: Icons.shopping_bag_outlined,
              selectedIcon: Icons.shopping_bag_rounded,
              label: AppStrings.storeTab,
              selected: selectedIndex == 3,
              onTap: () => onDestinationSelected(3),
            ),
            _BottomBarItem(
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: AppStrings.myTab,
              selected: selectedIndex == 4,
              onTap: () => onDestinationSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selected ? selectedIcon : icon,
                  size: 22,
                  color: selected ? AppColors.whiteText : AppColors.greyText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? AppColors.primary : AppColors.greyText,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
