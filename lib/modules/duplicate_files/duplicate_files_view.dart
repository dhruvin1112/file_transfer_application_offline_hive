import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/widgets/common_loader.dart';
import '../../shared/widgets/custom_card.dart';
import 'duplicate_files_controller.dart';

class DuplicateFilesView extends GetView<DuplicateFilesController> {
  const DuplicateFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate Cleaner'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Scan CTA Card
              CustomCard(
                padding: const EdgeInsets.all(18),
                borderRadius: 20,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.auto_delete_rounded,
                            color: AppColors.warning,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deep Duplicate Audit',
                                style: AppTextStyles.headingSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Identifies identical files using exact SHA-256 cryptographic hashes.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CommonButton(
                      text: 'Select Files to Scan',
                      icon: Icons.find_in_page_rounded,
                      gradient: AppColors.primaryGradient,
                      borderRadius: 16,
                      onPressed: controller.scanForDuplicates,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Duplicates Result List or Empty State
              Expanded(
                child: Obx(
                  () {
                    if (controller.isScanning.value) {
                      return const CommonLoader(
                        message: 'Scanning file streams & calculating SHA-256 hashes...',
                      );
                    }

                    if (controller.duplicateGroups.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 88,
                                height: 88,
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
                                  Icons.cleaning_services_rounded,
                                  size: 40,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Duplicates Found',
                                style: AppTextStyles.headingMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Select files above to verify whether duplicate identical copies exist on your device.',
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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DUPLICATE GROUPS (${controller.duplicateGroups.length})',
                              style: AppTextStyles.caption.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.duplicateGroups.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final group = controller.duplicateGroups[index];
                              final reclaimable =
                                  (group.files.length - 1) * group.fileSize;

                              return CustomCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Group #${index + 1} (${group.files.length} copies)',
                                          style:
                                              AppTextStyles.bodyMedium.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Save ${reclaimable.toReadableSize()}',
                                            style:
                                                AppTextStyles.caption.copyWith(
                                              color: AppColors.warning,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Divider(height: 1),
                                    ),
                                    ...group.files.map(
                                      (f) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.insert_drive_file_outlined,
                                              size: 18,
                                              color: AppColors.primaryLight,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    f.name,
                                                    style: AppTextStyles
                                                        .bodySmall
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    f.path,
                                                    style: AppTextStyles
                                                        .caption
                                                        .copyWith(
                                                      color: isDark
                                                          ? AppColors
                                                              .textSecondaryDark
                                                          : AppColors
                                                              .textSecondaryLight,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
