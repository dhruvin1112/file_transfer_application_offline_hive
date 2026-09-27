import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/widgets/custom_card.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Hero Brand Visual
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Transfer Anything,\nInstantly.',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Seamless, zero-data peer-to-peer file sharing between Android & iOS devices.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 28),

              // Value Proposition Feature Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildFeatureCard(
                      icon: Icons.speed_rounded,
                      color: AppColors.primaryLight,
                      title: 'Hyper-Speed Local Wi-Fi',
                      subtitle:
                          'Transfer full-resolution photos, 4K videos & large files up to 40 MB/s without cellular data.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.devices_other_rounded,
                      color: AppColors.cyan,
                      title: 'Cross-Platform Freedom',
                      subtitle:
                          'Flawless peer pairing between Android and iOS with instant QR code scanning or network discovery.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      icon: Icons.lock_outline_rounded,
                      color: AppColors.success,
                      title: '100% Private & Direct P2P',
                      subtitle:
                          'Files never touch external servers or the cloud. All transfers happen directly over local encrypted sockets.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action CTA
              CommonButton(
                text: 'Get Started',
                icon: Icons.arrow_forward_rounded,
                gradient: AppColors.primaryGradient,
                borderRadius: 18,
                height: 54,
                onPressed: controller.completeOnboarding,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
