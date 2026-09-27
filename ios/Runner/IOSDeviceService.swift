import Foundation
import UIKit

class IOSDeviceService {

    func getDeviceInfo() -> [String: Any] {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        let fileManager = FileManager.default
        var totalStorageBytes: Int64 = 0
        var availableStorageBytes: Int64 = 0

        if let systemAttributes = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let freeSize = systemAttributes[.systemFreeSize] as? NSNumber {
                availableStorageBytes = freeSize.int64Value
            }
            if let totalSize = systemAttributes[.systemSize] as? NSNumber {
                totalStorageBytes = totalSize.int64Value
            }
        }

        let batteryLevel = Int(device.batteryLevel * 100)

        return [
            "model": device.model,
            "name": device.name,
            "systemName": device.systemName,
            "systemVersion": device.systemVersion,
            "localizedModel": device.localizedModel,
            "totalStorageBytes": totalStorageBytes,
            "availableStorageBytes": availableStorageBytes,
            "batteryLevel": batteryLevel
        ]
    }
}
