import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? textColor;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final double? width;
  final bool outline;
  final Color? borderColor;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.gradient,
    this.textColor,
    this.icon,
    this.height = 52,
    this.borderRadius = 16,
    this.width,
    this.outline = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = outline
        ? null
        : (gradient ??
            (backgroundColor == null ? AppColors.primaryGradient : null));
    final effectiveBg = outline
        ? Colors.transparent
        : (effectiveGradient != null ? null : (backgroundColor ?? AppColors.primary));
    final effectiveTextColor = textColor ??
        (outline
            ? (borderColor ?? AppColors.primary)
            : Colors.white);

    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: effectiveBg,
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: outline
            ? Border.all(
                color: borderColor ?? AppColors.primary,
                width: 1.5,
              )
            : null,
        boxShadow: (onPressed != null && !outline)
            ? [
                BoxShadow(
                  color: (backgroundColor ?? AppColors.primary).withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: effectiveTextColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.button.copyWith(
                          color: effectiveTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
