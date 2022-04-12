//
//  LXPrivacyManager.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

/// PrivacyManager自动根据状态返回提示语
@objc(LXObjcAuth)
@objcMembers public final class LXSwiftAuth: NSObject {
 
    /// 相机权限
    public static var isSupportCamera: Bool { AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized }

    /// 请求相机权限
    @inline(__always)
    public static func authVideo(_ completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            DispatchQueue.main.async { completion(granted) }
        }
    }
    
    /// 相册权限
    public static var isSupportPhotoAlbum: Bool { PHPhotoLibrary.authorizationStatus() == .authorized }
    
    /// 请求相册权限
    @inline(__always)
    public static func authAlbum(_ completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async { completion(status == .authorized) }
        }
    }
    
    /// 麦克风权限
    public static var isSupportAudio: Bool { AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .authorized }
    
    /// 请求麦克风权限
    @inline(__always)
    public static func authAudio(_ completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { (granted) in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    /// 定位权限
    public static var isSupportLocation: Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        return authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse
    }

    /// 判断系统是否支持消息推送能力
    @available(iOS 10.0, *)
    @inline(__always)
    public static func isSupportNotications(_ callback: @escaping (_ isSupport: Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            DispatchQueue.main.async { callback(setting.authorizationStatus != .denied) }
        }
    }
    
    /// 请求推送权限
    @available(iOS 10.0, *)
    @inline(__always)
    public static func regisiterRemoteNotications(_ completion: @escaping (Bool) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (isSuccess, error) in
            DispatchQueue.main.async { completion(isSuccess) }
        })
        UIApplication.shared.registerForRemoteNotifications()
    }
}
