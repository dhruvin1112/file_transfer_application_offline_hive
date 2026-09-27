import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../shared/enums/file_type.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/widgets/custom_card.dart';
import 'sender_controller.dart';

class SenderView extends GetView<SenderController> {
  const SenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Files'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Selector Chips Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildCategoryButton(
                      label: 'Photos',
                      icon: Icons.image_rounded,
                      color: AppColors.primaryLight,
                      onTap: () => controller.pickFiles(FileType.image),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryButton(
                      label: 'Videos',
                      icon: Icons.movie_rounded,
                      color: AppColors.secondaryLight,
                      onTap: () => controller.pickFiles(FileType.video),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryButton(
                      label: 'Music',
                      icon: Icons.music_note_rounded,
                      color: AppColors.cyan,
                      onTap: () => controller.pickFiles(FileType.audio),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryButton(
                      label: 'Documents',
                      icon: Icons.description_rounded,
                      color: AppColors.warning,
                      onTap: () => controller.pickFiles(FileType.document),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Selected Files List or Modern Empty State
            Expanded(
              child: Obx(
                () => controller.selectedFiles.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: (isDark
                                          ? AppColors.cardDark
                                          : AppColors.surfaceLight)
                                      .withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.file_upload_outlined,
                                  size: 44,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Files Queued Yet',
                                style: AppTextStyles.headingMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap any category above to select photos, videos, audio tracks, or documents.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.selectedFiles.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final file = controller.selectedFiles[index];
                          return CustomCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            borderRadius: 16,
                            child: Row(
                              children: [
                                _buildFileIcon(file.name, isDark),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        file.size.toReadableSize(),
                                        style: AppTextStyles.telemetry.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                    color: AppColors.error,
                                    size: 22,
                                  ),
                                  onPressed: () => controller.removeFile(file),
                                  tooltip: 'Remove',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Bottom Sticky Checkout Bar
            Obx(
              () => controller.selectedFiles.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            width: 1.2,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'READY TO SEND',
                                    style: AppTextStyles.caption.copyWith(
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${controller.selectedFiles.length} files selected',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                controller.totalSelectedSize.value.toReadableSize(),
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CommonButton(
                            text: 'Next: Connect Device',
                            icon: Icons.arrow_forward_rounded,
                            gradient: AppColors.sendGradient,
                            onPressed: controller.proceedToPairing,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(String fileName, bool isDark) {
    final ext = fileName.split('.').last.toLowerCase();
    Color iconColor = AppColors.primaryLight;
    IconData iconData = Icons.insert_drive_file_rounded;

    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'].contains(ext)) {
      iconColor = AppColors.cyan;
      iconData = Icons.image_rounded;
    } else if (['mp4', 'mkv', 'mov', 'avi'].contains(ext)) {
      iconColor = AppColors.secondaryLight;
      iconData = Icons.movie_rounded;
    } else if (['mp3', 'wav', 'aac', 'm4a', 'flac'].contains(ext)) {
      iconColor = AppColors.warning;
      iconData = Icons.music_note_rounded;
    } else if (['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'].contains(ext)) {
      iconColor = AppColors.error;
      iconData = Icons.description_rounded;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: iconColor, size: 22),
    );
  }
}
