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
public class LXSwiftPrivacyAuth: NSObject, LXSwiftCompatible { }

//MARK: -  Extending methods for Privacy
extension LXSwiftBasics where Base == LXSwiftPrivacyAuth {
    
    /// 相机权限
    public static var isCheckCamera: Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus == .authorized
    }

    /// 请求相机权限
    public static func authVideo(_ completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            DispatchQueue.lx.asyncMain {
                completion(granted)
            }
        }
    }
    
    /// 相册权限
    public static var isCheckPhotoAlbum: Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return authStatus == .authorized
    }
    
    /// 请求相册权限
    public static func authAlbum(_ completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.lx.asyncMain {
                completion(status == .authorized)
            }
        }
    }
    
    /// 麦克风权限
    public static var isCheckAudio: Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        return authStatus == .authorized
    }
    
    /// 请求麦克风权限
    public static func authAudio(_ completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { (granted) in
            DispatchQueue.lx.asyncMain {
                completion(granted)
            }
        }
    }

    /// 定位权限
    public static var isCheckLocation: Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        return authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse
    }

}
