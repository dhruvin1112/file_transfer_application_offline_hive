import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../shared/enums/file_type.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/widgets/common_loader.dart';
import '../../shared/widgets/custom_card.dart';
import 'file_selection_controller.dart';

class FileSelectionView extends GetView<FileSelectionController> {
  const FileSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Content'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Media Categories Horizontal Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildCategoryChip(
                      label: 'Photos',
                      icon: Icons.image_rounded,
                      color: AppColors.primaryLight,
                      onTap: () => controller.pickMedia(FileType.image),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Videos',
                      icon: Icons.movie_rounded,
                      color: AppColors.secondaryLight,
                      onTap: () => controller.pickMedia(FileType.video),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Music',
                      icon: Icons.music_note_rounded,
                      color: AppColors.cyan,
                      onTap: () => controller.pickMedia(FileType.audio),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Docs',
                      icon: Icons.description_rounded,
                      color: AppColors.warning,
                      onTap: () => controller.pickMedia(FileType.document),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: 'Contacts',
                      icon: Icons.contacts_rounded,
                      color: AppColors.success,
                      onTap: controller.pickContacts,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Content List or Empty State
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const CommonLoader(message: 'Accessing media storage...');
                  }

                  if (controller.selectedFiles.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
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
                                Icons.queue_music_rounded,
                                size: 44,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Queue is Empty',
                              style: AppTextStyles.headingMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap any category above to add files to your transfer queue.',
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
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.selectedFiles.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
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
                            _buildFileIcon(file.name),
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
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Confirm Button Bar
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      width: 1.2,
                    ),
                  ),
                ),
                child: CommonButton(
                  text: 'Confirm Selection (${controller.selectedFiles.length})',
                  icon: Icons.check_circle_outline_rounded,
                  gradient: controller.selectedFiles.isNotEmpty
                      ? AppColors.primaryGradient
                      : null,
                  backgroundColor: controller.selectedFiles.isEmpty
                      ? Colors.grey.withValues(alpha: 0.3)
                      : null,
                  onPressed: controller.selectedFiles.isNotEmpty
                      ? controller.confirmSelection
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
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

  Widget _buildFileIcon(String fileName) {
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
    } else if (ext == 'vcf') {
      iconColor = AppColors.success;
      iconData = Icons.contacts_rounded;
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
