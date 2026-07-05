import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_home/core/themes/images.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/button/_custom_button.dart';
import 'package:mini_home/core/widgets/button/basic_button.dart';
import 'package:mini_home/router/router.dart';
import 'package:mini_home/core/themes/strings.dart';

class WelcomeWidget extends ConsumerWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(appImagesProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final dynamicSpacing = (screenHeight * 0.12).clamp(50.0, 150.0);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      images.mainImage,
                      width: 325,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.welcomeTitle,
                      style: AppTextStyle.body0.copyWith(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.welcomeDescription,
                      style: AppTextStyle.body1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: dynamicSpacing),
                    BasicButton.buildLarge(
                      text: AppStrings.welcomeLoginButton,
                      onPressed: () {
                        context.pushNamed(AppRoutes.signIn);
                      },
                      shapeType: ShapeType.rounded,
                    ),
                    const SizedBox(height: 16),
                    BasicButton.buildLarge(
                      text: AppStrings.welcomeRegisterButton,
                      onPressed: () {
                        context.pushNamed(AppRoutes.signUp);
                      },
                      shapeType: ShapeType.rounded,
                      buttonType: ButtonType.outlined,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
