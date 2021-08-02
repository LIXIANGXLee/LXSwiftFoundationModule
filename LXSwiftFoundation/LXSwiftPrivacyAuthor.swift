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
import CoreTelephony

/// PrivacyManager自动根据状态返回提示语
public class LXSwiftPrivacyAuthor: NSObject, LXSwiftCompatible { }

//MARK: -  Extending methods for Privacy
extension LXSwiftBasics where Base == LXSwiftPrivacyAuthor {
    
    /// 相机权限
    public static var isSupportCamera: Bool {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    /// 麦克风权限
    public static var isSupportAudio: Bool {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    /// 相册权限
    public static var isSupportPhotoAlbum: Bool {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    /// 定位权限
    public static var isSupportLocation: Bool {
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
}
