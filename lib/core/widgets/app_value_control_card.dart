import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/widgets/app_surface_card.dart';

class AppValueControlCard extends StatelessWidget {
  const AppValueControlCard({
    super.key,
    required this.value,
    required this.suffix,
    required this.onDecrease,
    required this.onIncrease,
    this.compact = false,
  });

  final String value;
  final String suffix;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            )
          : const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RoundControlButton(
            icon: Icons.remove,
            onTap: onDecrease,
            compact: compact,
          ),
          Expanded(
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                        fontSize: compact ? 32 : null,
                      ),
                  children: [
                    TextSpan(text: value),
                    TextSpan(
                      text: suffix,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _RoundControlButton(
            icon: Icons.add,
            onTap: onIncrease,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  const _RoundControlButton({
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        minimumSize: compact ? const Size.square(40) : null,
        padding: compact ? const EdgeInsets.all(AppSpacing.xs) : null,
      ),
      icon: Icon(icon),
    );
  }
}
