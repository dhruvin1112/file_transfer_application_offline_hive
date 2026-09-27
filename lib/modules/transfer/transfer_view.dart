import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/extensions.dart';
import '../../shared/enums/transfer_status.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/widgets/custom_card.dart';
import 'transfer_controller.dart';

class TransferView extends GetView<TransferController> {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: !controller.isTransferring.value,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.transferStatus.value.displayName,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          automaticallyImplyLeading: !controller.isTransferring.value,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Obx(() {
              final status = controller.transferStatus.value;
              final isCompleted = status == TransferStatus.completed;
              final isFailed = status == TransferStatus.failed;
              final isCancelled = status == TransferStatus.cancelled;
              final progress = controller.transferProgress.value.clamp(0.0, 1.0);
              final device = controller.connectedDevice.value;
              final isIos = device?.platform == 'iOS';

              Color statusColor = AppColors.primary;
              IconData statusIcon = Icons.sync_rounded;

              if (isCompleted) {
                statusColor = AppColors.success;
                statusIcon = Icons.check_circle_rounded;
              } else if (isFailed || isCancelled) {
                statusColor = AppColors.error;
                statusIcon = Icons.error_rounded;
              }

              return Column(
                children: [
                  // Peer Device Header Card
                  CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    borderRadius: 18,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isIos ? Icons.phone_iphone_rounded : Icons.phone_android_rounded,
                            color: statusColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device?.deviceName ?? 'Connected Peer',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                controller.isSender ? 'Sending to device' : 'Receiving from device',
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.displayName,
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Circular Progress HUD Gauge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Background
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.18),
                              blurRadius: 36,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      // Background Track
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 12,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      // Active Progress Track
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      ),
                      // Center Stats
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 36),
                          const SizedBox(height: 6),
                          Text(
                            '${(progress * 100).toStringAsFixed(1)}%',
                            style: AppTextStyles.displayMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              controller.transferSpeed.value.toReadableSpeed(),
                              style: AppTextStyles.telemetry.copyWith(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Current File Details Card
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file_outlined,
                              size: 18,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'CURRENT FILE',
                              style: AppTextStyles.caption.copyWith(
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.currentFileName.value.isNotEmpty
                              ? controller.currentFileName.value
                              : (isCompleted
                                  ? 'All files transferred successfully'
                                  : 'Preparing payload stream...'),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error Text if any
                  if (controller.transferError.value != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        controller.transferError.value!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action Buttons
                  if (controller.isTransferring.value)
                    CommonButton(
                      text: 'Cancel Transfer',
                      icon: Icons.cancel_outlined,
                      backgroundColor: AppColors.error,
                      borderRadius: 18,
                      onPressed: controller.cancelTransfer,
                    )
                  else
                    CommonButton(
                      text: 'Done',
                      icon: Icons.check_rounded,
                      gradient: isCompleted
                          ? AppColors.primaryGradient
                          : null,
                      backgroundColor: isCompleted ? null : AppColors.primary,
                      borderRadius: 18,
                      onPressed: controller.finishSession,
                    ),
                  const SizedBox(height: 12),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
