import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/pulse_radar_widget.dart';
import 'device_connection_controller.dart';

class DeviceConnectionView extends GetView<DeviceConnectionController> {
  const DeviceConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Device'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // QR Code Fast Connect Banner Card
              CustomCard(
                gradient: AppColors.primaryGradient,
                borderRadius: 20,
                padding: const EdgeInsets.all(18),
                onTap: controller.openQrScanner,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scan Receiver QR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Instant connection with zero setup',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Divider / Section Heading
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DISCOVERED NEARBY DEVICES',
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

              // Device List or Searching Animation
              Expanded(
                child: Obx(
                  () => controller.nearbyDevices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PulseRadarWidget(
                                size: 180,
                                pulseColor: AppColors.primaryLight,
                                rings: 3,
                                centerChild: Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.cardDark
                                        : AppColors.surfaceLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryLight,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.wifi_tethering_rounded,
                                    color: AppColors.primaryLight,
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Scanning Wi-Fi Network...',
                                style: AppTextStyles.headingSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: Text(
                                  'Make sure the receiver device has DropShare open on the same network, or scan its QR code above.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.nearbyDevices.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final device = controller.nearbyDevices[index];
                            final isIos = device.platform == 'iOS';

                            return CustomCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: 18,
                              onTap: () => controller.selectDevice(device),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: (isIos
                                              ? AppColors.secondary
                                              : AppColors.primary)
                                          .withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      isIos
                                          ? Icons.phone_iphone_rounded
                                          : Icons.phone_android_rounded,
                                      color: isIos
                                          ? AppColors.secondaryLight
                                          : AppColors.primaryLight,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          device.deviceName,
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${device.platform} • ${device.connectionAddress}',
                                          style: AppTextStyles.telemetry.copyWith(
                                            color: isDark
                                                ? AppColors.textSecondaryDark
                                                : AppColors.textSecondaryLight,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Connect',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.primaryLight,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 14,
                                          color: AppColors.primaryLight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
