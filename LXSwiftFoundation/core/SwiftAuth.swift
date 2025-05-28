//
//  SwiftAuth.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import AVFoundation
import Photos
import CoreLocation
import UserNotifications

/// 权限管理工具类，用于检查及请求系统权限
@objc(LXObjcAuth)
@objcMembers public final class SwiftAuth: NSObject {
    
    // MARK: - 相机权限
    
    /// 检查当前是否已获得相机权限
    /// - 说明: 此属性检查当前应用的相机权限状态是否为已授权
    /// - 注意: 实际设备摄像头可用性需额外检查
    public static var isSupportCamera: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    /// 请求相机权限
    /// - Parameter completion: 异步回调授权结果（主线程执行）
    public static func authVideo(_ completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            dispatchToMain(granted, completion: completion)
        }
    }
    
    // MARK: - 相册权限
    
    /// 检查当前是否已获得相册权限
    /// - 重要: 需要确保Info.plist中包含NSPhotoLibraryUsageDescription描述
    public static var isSupportPhotoAlbum: Bool {
        PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    /// 请求相册权限
    /// - Parameter completion: 异步回调授权结果（主线程执行）
    public static func authAlbum(_ completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            dispatchToMain(status == .authorized, completion: completion)
        }
    }
    
    // MARK: - 麦克风权限
    
    /// 检查当前是否已获得麦克风权限
    /// - 重要: 需要确保Info.plist中包含NSMicrophoneUsageDescription描述
    public static var isSupportAudio: Bool {
        AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    /// 请求麦克风权限
    /// - Parameter completion: 异步回调授权结果（主线程执行）
    public static func authAudio(_ completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            dispatchToMain(granted, completion: completion)
        }
    }
    
    // MARK: - 定位权限
    
    /// 检查当前是否已获得定位权限
    /// - 说明: 返回true表示拥有"始终使用"或"使用时"权限
    /// - 重要: 需要确保Info.plist中包含定位权限描述
    public static var isSupportLocation: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    // MARK: - 通知权限
    
    /// 检查系统通知权限是否可用（iOS 10+）
    /// - 说明: 返回true表示用户未明确拒绝通知权限（包括未决定状态）
    /// - Parameter callback: 异步回调检查结果（主线程执行）
    @available(iOS 10.0, *)
    public static func checkNotificationSupport(_ callback: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            dispatchToMain(settings.authorizationStatus != .denied, completion: callback)
        }
    }
    
    /// 请求远程通知权限（iOS 10+）
    /// - 说明: 自动注册远程通知并触发系统权限弹窗
    /// - Parameter completion: 异步回调授权结果（主线程执行）
    @available(iOS 10.0, *)
    public static func registerRemoteNotifications(_ completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            dispatchToMain(granted, completion: completion)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: - 私有工具方法
    
    /// 统一主线程派发方法
    private static func dispatchToMain(_ result: Bool, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async { completion(result) }
    }
}
