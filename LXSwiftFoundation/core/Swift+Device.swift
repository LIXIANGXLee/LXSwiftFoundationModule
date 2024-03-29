//
//  Swift+Device.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

private let fileManagerDefault = FileManager.default

//MARK: -  Extending methods  for UIDevice is ipad or iphone
extension SwiftBasics where Base: UIDevice {
    
    /// 是否为ipad
    public static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    /// 是否为iphone
    public static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// 是否为模拟器
    public var isSimulator: Bool {
        base.model.range(of: "Simulator") != nil
    }
    
    /// 是否能打电话
    public static var isCanCallTel: Bool {
        UIApplication.lx.isCanOpen(URL(string: "tel://")!)
    }
}

//MARK: -  Extending methods  for UIDevice is ipad or iphone
extension SwiftBasics where Base: UIDevice {
    
    /// 获取系统开始日期
    public static var systemUptime: Date {
        Date(timeIntervalSinceNow: ProcessInfo.processInfo.systemUptime)
    }
    
    /// 磁盘空间
    public static var diskSpace: Int64? {
        guard let attrs = try? fileManagerDefault.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return nil
        }
        return attrs[FileAttributeKey.systemSize] as? Int64
    }
    
    /// 磁盘空间是可以使用的大小
    public static var diskSpaceFree: Int64? {
        guard let attrs = try? fileManagerDefault.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return nil
        }
        return attrs[FileAttributeKey.systemFreeSize] as? Int64
    }
    
    /// 磁盘空间是按大小使用的
    public static var diskSpaceUsed: Int64? {
       guard let total = diskSpace,
             let free  = diskSpaceFree else {
           return nil
       }
        if total <= 0 || free <= 0 {
            return nil
        }
        let used = total - free
        if used > 0 {
            return used
        }
        return nil
    }
    
    /// 获取内存大小
    public static var memoryTotal: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
    
    /// 设备类型
    public static var deviceType: String {
        UIDevice.current.model
    }
    
    /// 系统版本
    public static var deviceSyetemVersion: String {
        UIDevice.current.systemVersion
    }

    /// 当前系统版本
    public static var currentSystemVersion: String {
        UIDevice.current.systemVersion
    }
}
