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
public class LXSwiftPrivacyManager: NSObject, LXSwiftCompatible {

    /// 检查相机权限，无权限时返回提示语
    /// 返回空除了代表用户已同意以外，也可能代表还未申请过
    @objc class public func checkVideoAuthority(
        with restrictedMessage: String = "未开启相机权限") -> String? {
        return getPrivacyResult(of: .video,
                                restrictedMessage: restrictedMessage)
    }

    /// 检查麦克风权限，无权限时返回提示语
    /// 返回空除了代表用户已同意以外，也可能代表还未申请过
    @objc class public func checkAudioAuthority(
        with restrictedMessage: String = "未开启麦克风权限") -> String? {
        return getPrivacyResult(of: .audio,
                                restrictedMessage: restrictedMessage)
    }

    /// 检查相册权限，无权限时返回提示语
    /// 返回空除了代表用户已同意以外，也可能代表还未申请过
    @objc class public func checkLibraryAuthority(
        with restrictedMessage: String = "未开启相册权限") -> String? {
        return getPrivacyResult(of: .photo,
                                restrictedMessage: restrictedMessage)
    }

    /// 检查网络权限，无权限时返回提示
    /// 返回空除了代表用户已同意以外，也可能代表还未申请过
    @objc class public func checkNetworkPrivacy(
        with restrictedMessage: String = "网络链接失败,请检查你的网络是否受限\n请检查是否允许【DaDaBaby】APP 使用网络(设置->DaDaBaby->无线数据)"
        ) -> String? {
        return getPrivacyResult(of: .net,
                                restrictedMessage: restrictedMessage)
    }

    /// 实际检查调用
    private class func getPrivacyResult(of type: LXSwiftPrivacyType,
                                        restrictedMessage: String) -> String? {
        let status = LXSwiftPrivacyChecker.check(type)
        if status.pass {
            // 用户已同意
            return nil
        } else if status.askedUser {
            // 用户拒绝了 受限了
            return restrictedMessage
        } else {
            // 还没像用户申请过
            return nil
        }
    }

    /// 弹窗提示用户跳转到系统设置中去
    @objc class public func jumpToSettingAppBeforAsking(withTitle title: String,
                                                        message: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)

        let goAction = UIAlertAction(title: "去设置",
                                     style: .default) {_ in
            LXSwiftPrivacyManager.jumpToSettingAppDirectly()
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        alertVC.addAction(goAction)
        alertVC.addAction(cancelAction)
        let vc = UIApplication.lx.visibleViewController
        vc?.present(alertVC, animated: true, completion: nil)
    }

    /// 直接跳转到设置App中
    @objc class public func jumpToSettingAppDirectly() {
        let url = getURLToSettingFromSystemVersion()
        guard let targetURL = url else { return }
        
        if UIApplication.shared.canOpenURL(targetURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(targetURL, options: [:],
                                          completionHandler: nil)
            } else {
                UIApplication.shared.openURL(targetURL)
            }
        }
    }

    /// 根据系统版本取跳设置的最佳方式
    class public func getURLToSettingFromSystemVersion() -> URL? {
        if #available(iOS 10.0, *) {
            return urlOfJumpToSettingsWithURL()
        } else {
            return nil
        }
    }

    /// for > iOS10
    class public func urlOfJumpToSettingsWithURL() -> URL? {
        return URL(string: UIApplication.openSettingsURLString)
    }
}

/// net 只适用于iOS10之后
@objc public enum LXSwiftPrivacyType: NSInteger {
    case video, audio, photo, net
}

/// 权限检查结果
@objc public class LXSwiftPrivacyCheckResult: NSObject {
    /// 拥有此权限
    @objc public var pass: Bool
    /// 是否询问过用户
    @objc public var askedUser: Bool

    init(pass: Bool, askedUser: Bool) {
        self.pass = pass
        self.askedUser = askedUser
    }

    override public var description: String {
        return "LXPrivacyCheckResult: { pass: \(self.pass), askedUser: \(self.askedUser) }"
    }
}

/// PrivacyChecker返回权限状态详细信息
@objc public class LXSwiftPrivacyChecker: NSObject {

    /// 检查权限
    ///
    /// - Parameter type: 检查哪项权限
    /// - Returns: 检查结果(.pass: 拥有此权限,.askedUser: 是否询问过用户)
    @objc class public func check(_ type: LXSwiftPrivacyType) -> LXSwiftPrivacyCheckResult {
        switch type {
        case .video:
            return checkAVPrivacy(.video)
        case .audio:
            return checkAVPrivacy(.audio)
        case .photo:
            return checkPhotoPrivacy()
        case .net:
            return checkNetPrivacy()
        }
    }

    /// 检查权限，如果还没申请过就自动申请
    ///
    /// - Parameters:
    ///   - type: 检查哪项权限
    ///   - block: 最终结果回调
    @objc class public func checkAndAutoAsk(_ type: LXSwiftPrivacyType,
                                            block: @escaping ((_ finalResult:
                                                                LXSwiftPrivacyCheckResult)
                                                              -> Void)) {
        switch type {
        case .video, .audio, .photo:
            let normalCheckResult = check(type)
            if (normalCheckResult.pass == false && normalCheckResult.askedUser == true) ||
                normalCheckResult.pass == true {
                // 用户明确允许了或是拒绝了
                DispatchQueue.main.async(execute: {
                    block(normalCheckResult)
                })
            } else if normalCheckResult.pass == false && normalCheckResult.askedUser == false {
                // 尚未申请过
                requestPrivacy(type) { (requestResult: Bool) in
                    DispatchQueue.main.async(execute: {
                        block(LXSwiftPrivacyCheckResult(pass: requestResult,
                                                        askedUser: true))
                    })
                }
            }
        case .net:
            //unsupport request net privact
            block(check(type))
        }
    }

    /// 申请权限，（暂不支持网络权限）
    @objc class public func requestPrivacy(_ type: LXSwiftPrivacyType,
                                           block: @escaping ((_ allowed: Bool) -> Void)) {
        switch type {
        case .video:
            requestAVPrivacy(.video, block: block)
        case .audio:
            requestAVPrivacy(.audio, block: block)
        case .photo:
            requestPhotoPrivacy(block: block)
        case .net:
            // unsupport
            block(false)
        }
    }

    // MARK: *******************private
    private class func checkAVPrivacy(_ type: AVMediaType) -> LXSwiftPrivacyCheckResult {
        let AVStatus = AVCaptureDevice.authorizationStatus(for: type)
        switch AVStatus {
        case .notDetermined:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: false)
        case .restricted, .denied:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: true)
        case .authorized:
            return LXSwiftPrivacyCheckResult(pass: true, askedUser: true)
        @unknown default:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: false)
        }
    }

    private class func checkPhotoPrivacy() -> LXSwiftPrivacyCheckResult {
        let ALStatus = PHPhotoLibrary.authorizationStatus()
        switch ALStatus {
        case .notDetermined:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: false)
        case .restricted, .denied:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: true)
        case .authorized:
            return LXSwiftPrivacyCheckResult(pass: true, askedUser: true)
        default:
            return LXSwiftPrivacyCheckResult(pass: false, askedUser: false)
        }
    }

    private class func checkNetPrivacy() -> LXSwiftPrivacyCheckResult {
        if #available(iOS 9.0, *) {
            let state = LXSwiftNetworkPrivacyManager.shared.ctData.restrictedState
            switch state {
            case .restricted:
                return LXSwiftPrivacyCheckResult(pass: false, askedUser: true)
            case .restrictedStateUnknown, .notRestricted:
                return LXSwiftPrivacyCheckResult(pass: true, askedUser: true)
            @unknown default:
                return LXSwiftPrivacyCheckResult(pass: true, askedUser: true)
            }
        } else {
            return LXSwiftPrivacyCheckResult(pass: true, askedUser: true)
        }
    }

    private class func requestAVPrivacy(_ type: AVMediaType,
                                        block: @escaping ((_ allowed: Bool) -> Void)) {
        AVCaptureDevice.requestAccess(for: type) { (result: Bool) in
            block(result)
        }
    }

    // swiftlint:disable fallthrough
    private class func requestPhotoPrivacy(block: @escaping ((_ allowed: Bool) -> Void)) {
        PHPhotoLibrary.requestAuthorization { (resultStatus) in
            switch resultStatus {
            case .notDetermined:
                //should not happen
                fallthrough
            case .restricted, .denied:
                block(false)
            case .authorized:
                block(true)
            default:
                block(false)
            }
        }
    }
}

@available(iOS 9.0, *)
public class LXSwiftNetworkPrivacyManager {
    static let shared = LXSwiftNetworkPrivacyManager()
    public class func setup() {
        _ = LXSwiftNetworkPrivacyManager.shared
    }
    let ctData: CTCellularData = CTCellularData()

    init() {
        ctData.cellularDataRestrictionDidUpdateNotifier = { state in
            // 不需要实现，有此block就会触发它更新
        }
    }
}

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
