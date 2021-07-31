//
//  LXSwift+Device.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIDevice: LXSwiftCompatible { }

//MARK: -  Extending methods  for UIDevice is ipad or iphone
extension LXSwiftBasics where Base: UIDevice {
    
    /// is ipad
    public static var isPad: Bool {
        if #available(iOS 13.0, *) {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }else{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    /// is iphone
    public static var isPhone: Bool {
        if #available(iOS 13.0, *) {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        }else{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
        }
    }
    
    /// is Simulator
    public var isSimulator: Bool {
        return base.model.range(of: "Simulator") != nil
    }
    
    /// is can call tel
    public static var isCanPhoneCalls: Bool {
        return UIApplication.lx.isCanOpen(URL(string: "tel://")!)
    }
}

//MARK: -  Extending methods  for UIDevice is ipad or iphone
extension LXSwiftBasics where Base: UIDevice {
    
    /// 获取网络类型
    public static var netType: String {
        let type = LXObjcUtils.getNetWorkType()
        var netType: String
        switch type {
        case 1:
            netType = "wifi"
        case 2:
            netType = "4G"
        case 3:
            netType = "3G"
        case 4:
            netType = "2G"
        default:
            netType = "未知"
        }
        return netType
    }
    
    /// 获取系统开始日期
    public static var systemUptime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }
    
    /// 磁盘空间
    public static var diskSpace: Int64 {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath:
                                                                            NSHomeDirectory()),
              let space = attrs[FileAttributeKey.systemSize] as? Int64 else {
            return -1
        }
        return space
    }
    
    /// 磁盘空间是可以使用的大小
    public static var diskSpaceFree: Int64 {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath:
                                                                            NSHomeDirectory()),
              let space = attrs[FileAttributeKey.systemFreeSize] as? Int64 else {
            return -1
        }
        return space
    }
    
    /// 磁盘空间是按大小使用的
    public static var diskSpaceUsed: Int64 {
        let total = diskSpace
        let free  = diskSpaceFree
        if total <= 0 || free <= 0 {
            return -1
        }
        let used = total - free
        if used <= 0 {
            return -1
        }else{
            return used
        }
    }
    
    /// 获取内存大小
    public static var memoryTotal: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// 设备类型
    public static var deviceType: String {
        return UIDevice.current.model
    }
    
    /// 系统版本
    public static var deviceSyetemVersion: String {
        return UIDevice.current.systemVersion
    }

}
