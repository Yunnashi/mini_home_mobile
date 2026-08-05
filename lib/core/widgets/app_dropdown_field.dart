import 'package:flutter/material.dart';
import 'package:mini_home/core/themes/colors.dart';
import 'package:mini_home/core/themes/design_tokens.dart';
import 'package:mini_home/core/themes/text_style.dart';
import 'package:mini_home/core/widgets/app_surface_card.dart';

class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.icon,
    this.isDense = false,
    this.hideUnderline = false,
    this.contentPadding,
  });

  final T? value;
  final List<AppDropdownOption<T>> items;
  final ValueChanged<T> onChanged;
  final String? labelText;
  final IconData? icon;
  final bool isDense;
  final bool hideUnderline;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    if (hideUnderline) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: isDense,
          borderRadius: BorderRadius.circular(AppRadius.card),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
              ),
          items: _buildItems(),
          onChanged: (value) {
            if (value == null) return;
            onChanged(value);
          },
        ),
      );
    }

    final field = DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      isDense: true,
      borderRadius: BorderRadius.circular(AppRadius.card),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
      decoration: InputDecoration(
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 20, color: AppColors.greyText),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: contentPadding ?? const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      items: _buildItems(),
      onChanged: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );

    if (labelText == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(labelText!, style: AppTextStyle.body1),
        ),
        field,
      ],
    );
  }

  List<DropdownMenuItem<T>> _buildItems() {
    return [
      for (final item in items)
        DropdownMenuItem<T>(
          value: item.value,
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ];
  }
}

class AppDropdownControlCard<T> extends StatelessWidget {
  const AppDropdownControlCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<AppDropdownOption<T>> items;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            )
          : const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.greyText),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.xxs : AppSpacing.xs),
          AppDropdownField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            isDense: compact,
            hideUnderline: true,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
