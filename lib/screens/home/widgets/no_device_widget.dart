import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/images.dart';
import 'package:mini_home/core/themes/strings.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/features/auth/services/auth_state_service.dart';
import 'package:mini_home/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class NoDeviceWidget extends ConsumerWidget {
  final AuthState authState;
  const NoDeviceWidget(this.authState, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(appImagesProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    // iPhone SEのような小さい画面（700px未満）ではスペーシングなし、それ以上は32px
    final topSpacing = screenHeight < 700 ? 0.0 : 32.0;

    // バナーの高さ分のスペースを確保（バナー高さ約100px + bottom padding 24px + 余裕16px）
    const bannerHeight = 100.0;
    const bannerBottomPadding = 24.0;
    const bannerSpacing = 16.0;
    const bannerTotalHeight =
        bannerHeight + bannerBottomPadding + bannerSpacing;

    return Stack(
      children: [
        Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: topSpacing),
                    Image.asset(
                      images.noDevice,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      AppStrings.noDeviceDescription,
                      style: AppTextStyle.body0TextGrey,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    BasicButton.buildLarge(
                      text: AppStrings.noDeviceAddDevice,
                      onPressed: () {
                        context.pushNamed(
                          AppRoutes.deviceRegistration,
                          extra: authState,
                        );
                      },
                      shapeType: ShapeType.rounded,
                    ),
                    // バナーの高さ分のスペースを確保（文字サイズが大きくなってもスクロールしてQRスキャンボタンが押せるように)
                    const SizedBox(height: bannerTotalHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
        _promotionBanner(context, ref),
      ],
    );
  }
}

Widget _promotionBanner(BuildContext context, WidgetRef ref) {
  final images = ref.watch(appImagesProvider);

  const promotionBannerUrl = 'https://tokyo-home.mini_home.jp/';
  const padding = 24.0;
  return Positioned(
    bottom: padding,
    left: padding,
    right: padding,
    child: GestureDetector(
      onTap: () async {
        final uri = Uri.parse(promotionBannerUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              images.promotionBanner,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
      ),
    ),
  );
}
