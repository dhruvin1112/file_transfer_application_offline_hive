package com.example.file_transfer_appplication

import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs

class AndroidDeviceService(private val context: Context) {

    fun getDeviceInfo(): Map<String, Any> {
        val statFs = StatFs(Environment.getDataDirectory().path)
        val blockSize = statFs.blockSizeLong
        val totalBlocks = statFs.blockCountLong
        val availableBlocks = statFs.availableBlocksLong

        val totalStorageBytes = totalBlocks * blockSize
        val availableStorageBytes = availableBlocks * blockSize

        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
        val batteryLevel = batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) ?: -1

        return mapOf(
            "model" to Build.MODEL,
            "manufacturer" to Build.MANUFACTURER,
            "brand" to Build.BRAND,
            "device" to Build.DEVICE,
            "osVersion" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "totalStorageBytes" to totalStorageBytes,
            "availableStorageBytes" to availableStorageBytes,
            "batteryLevel" to batteryLevel
        )
    }
}
