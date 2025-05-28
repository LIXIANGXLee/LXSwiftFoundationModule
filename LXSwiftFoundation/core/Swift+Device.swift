//
//  Swift+Device.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

private let fileManager = FileManager.default

// MARK: - 设备信息扩展
extension SwiftBasics where Base: UIDevice {
    
    // MARK: - 设备类型判断
    
    /// 判断当前设备是否为 iPad
    public static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 判断当前设备是否为 iPhone
    public static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // MARK: - 系统信息
    
    /// 获取系统启动时间
    public static var systemUptime: Date {
        Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime)
    }
    
    /// 获取设备系统版本（格式示例："15.4.1"）
    public static var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    // MARK: - 存储空间信息
    
    /// 获取磁盘总空间（单位：字节）
    public static var diskSpace: Int64? {
        guard let attrs = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let size = attrs[.systemSize] as? Int64,
                size > 0 else {
            return nil
        }
        return size
    }
    
    /// 获取磁盘可用空间（单位：字节）
    public static var diskSpaceFree: Int64? {
        guard let attrs = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let free = attrs[.systemFreeSize] as? Int64,
              free > 0 else {
            return nil
        }
        return free
    }
    
    /// 获取磁盘已用空间（单位：字节）
    public static var diskSpaceUsed: Int64? {
        guard let total = diskSpace,
                let free = diskSpaceFree else {
            return nil
        }
        return total - free
    }
    
    // MARK: - 内存信息
    
    /// 获取设备物理内存总大小（单位：字节）
    public static var memoryTotal: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
    
    // MARK: - 设备标识
    
    /// 获取设备类型标识（如 "iPhone"、"iPad"）
    public static var deviceModel: String {
        UIDevice.current.model
    }
}
