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

// MARK: - Privacy
public struct LXSwiftPrivacyManager: LXSwiftCompatible { }


//MARK: -  Extending methods for Privacy
extension LXSwiftBasics where Base == LXSwiftPrivacyManager {
    
    /// is support camera
    public static var isSupportCamera: Bool {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    /// is support Audio
    public static var isSupportAudio: Bool {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    /// is support PhotoAlbum
    public static var isSupportPhotoAlbum: Bool {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
        
    /// is support Location
    public static var isSupportLocation: Bool {
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
}
