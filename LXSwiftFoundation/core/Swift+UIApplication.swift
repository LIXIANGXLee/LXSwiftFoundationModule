//
//  Swift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2019/4/29.
//



import UIKit
import AVFoundation
import Photos

extension SwiftBasics where Base: UIApplication {
    /// 获取应用程序的根窗口（优先获取原生 UIWindow 类型的窗口）
    ///
    /// 注意：
    /// 1. iOS 13+ 从活跃场景中查找原生窗口
    /// 2. 早期系统版本使用共享应用的第一个窗口
    /// 3. 使用 isMember(of:) 确保获取的是 UIWindow 基类实例（非子类）
    public static var rootWindow: UIWindow? {
        SwiftWindow.rootWindow
    }
    
    /// 获取最外层可见窗口（排除远程键盘窗口）
    ///
    /// 解决 iPad 上虚拟键盘窗口影响弹窗层级的问题
    ///
    /// 筛选策略：
    /// 1. iOS 13+：反向遍历活跃场景窗口
    /// 2. 早期系统：全局反向搜索
    public static var lastWindow: UIWindow? {
        SwiftWindow.lastWindow
    }

    /// 获取root窗口的控制器
    public static var rootViewController: UIViewController? { rootWindow?.rootViewController
    }

    /// 获取顶部的窗口的控制器
    public static var currentViewController: UIViewController? {
        lastWindow?.rootViewController
    }

    /// 获取当前应用的导航控制器（UINavigationController）
    /// - 如果是导航控制器直接返回
    /// - 如果是标签栏控制器（UITabBarController），返回选中的子导航控制器
    /// - 其他情况返回nil
    public static var rootNavViewController: UINavigationController? {
        guard let rootVC = rootViewController else { return nil }
        
        // 如果是导航控制器直接返回
        if let navVC = rootVC as? UINavigationController {
            return navVC
        }
        // 如果是标签栏控制器，返回当前选中的导航控制器
        else if let tabBar = rootVC as? UITabBarController {
            return tabBar.children[tabBar.selectedIndex] as? UINavigationController
        }
        
        // 其他情况返回nil
        return nil
    }
    
    /// 获取当前最顶层的presented视图控制器
    /// - 通过循环查找最顶层的presentedViewController
    public static var presentViewController: UIViewController? {
        var topController = rootViewController
        
        // 循环查找最顶层的presented控制器
        while let presentedVC = topController?.presentedViewController {
            topController = presentedVC
        }
        
        return topController
    }
    
    /// 根据给定视图查找其所属的视图控制器
    /// - Parameter view: 需要查找控制器的视图
    /// - Returns: 找到的视图控制器，如果找不到则返回nil
    public static func currentViewController(ofView view: UIView) -> UIViewController? {
        // 从视图的下一个响应者开始查找
        var responder: UIResponder? = view.next
        
        // 循环遍历响应链
        while responder != nil {
            // 检查当前响应者是否是UIViewController类型
            if responder?.isKind(of: UIViewController.self) ?? false {
                return responder as? UIViewController
            }
            
            // 继续查找下一个响应者
            responder = responder?.next
        }
        
        return nil
    }
    
    /// 通过字符串URL打开外部链接
    /// - Parameters:
    ///   - urlStr: 要打开的URL字符串
    ///   - completionHandler: 打开操作完成后的回调，参数表示是否成功
    public static func openUrl(_ urlStr: String, completionHandler: ((Bool) -> Void)? = nil) {
        // 将字符串转换为URL对象
        if let url = URL(string: urlStr) {
            openUrl(url, completionHandler: completionHandler)
        } else {
            // 如果URL格式无效，直接回调失败
            completionHandler?(false)
        }
    }
    
    /// 打开外部URL链接
    /// - Parameters:
    ///   - url: 要打开的URL对象
    ///   - completionHandler: 打开操作完成后的回调，参数表示是否成功
    /// - 注意: iOS 10以下版本没有回调功能
    public static func openUrl(_ url: URL?, completionHandler: ((Bool) -> Void)? = nil) {
        // 检查URL是否有效
        guard let validUrl = url else {
            completionHandler?(false)
            return
        }
        
        // 检查是否可以打开该URL
        if isCanOpen(validUrl) {
            if #available(iOS 10.0, *) {
                // iOS 10+ 使用带回调的打开方式
                UIApplication.shared.open(validUrl, options: [:], completionHandler: completionHandler)
            } else {
                // iOS 10以下使用传统打开方式（无回调）
                UIApplication.shared.openURL(validUrl)
                completionHandler?(true)
            }
        } else {
            // 无法打开URL时回调失败
            completionHandler?(false)
        }
    }
    
    /// 检查是否可以打开指定的URL
    /// - Parameter url: 要检查的URL对象
    /// - Returns: 如果可以打开返回true，否则返回false
    public static func isCanOpen(_ url: URL?) -> Bool {
        guard let validUrl = url else {
            return false
        }
        return UIApplication.shared.canOpenURL(validUrl)
    }
    
    // MARK: - 系统功能
    
    /// 调用系统拨号功能
    /// - Parameters:
    ///   - number: 电话号码字符串 (自动过滤无效字符)
    ///   - completionHandler: 拨号操作结果回调 (布尔值表示是否成功)
    ///
    /// 注意: 在模拟器上始终返回失败
    public static func openTel(with number: String?, _ completionHandler: ((Bool) -> Void)? = nil) {
        // 1. 清理并验证电话号码
        guard let number = number?.trimmingCharacters(in: .whitespaces),
              !number.isEmpty,
              let url = URL(string: "tel://" + number) else {
            completionHandler?(false)
            return
        }
        
        // 2. 通过扩展方法打开系统拨号
        UIApplication.lx.openUrl(url, completionHandler: completionHandler)
    }
    
    // MARK: - 音频处理
    
    /// 播放短音频文件 (系统声音)
    /// - Parameters:
    ///   - filepath: 音频文件绝对路径
    ///   - completionHandler: 播放完成回调
    ///
    /// 要求: iOS 9.0+，支持常见音频格式(caf, wav, aiff)
    @available(iOS 9.0, *)
    public static func playSound(
        with filepath: String?,
        completionHandler: (() -> Void)? = nil
    ) {
        
        // 1. 验证文件存在性
        guard let path = filepath,
              FileManager.lx.isFileExists(atPath: path) else {
            return
        }
        
        var soundID: SystemSoundID = 0
        let fileURL = URL(fileURLWithPath: path)
        
        // 2. 创建系统声音对象
        let status = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        guard status == kAudioServicesNoError else {
            SwiftLog.log("音频加载失败: OSStatus=\(status)")
            return
        }
        
        // 3. 播放声音并处理完成回调
        AudioServicesPlaySystemSoundWithCompletion(soundID) {
            // 4. 释放资源
            AudioServicesDisposeSystemSoundID(soundID)
            completionHandler?()
        }
    }
    
    // MARK: - 相机权限
    
    /// 检查当前是否已获得相机权限
    /// - 说明: 此属性检查当前应用的相机权限状态是否为已授权
    /// - 注意: 实际设备摄像头可用性需额外检查
    public static var isSupportCamera: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    /// 请求相机权限
    /// - Parameter completion: 异步回调授权结果（主线程执行）
    public static func requestAccessVideo(_ completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.lx.asyncMain { completionHandler(granted) }
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
    public static func requestAuthorization(_ completionHandler: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.lx.asyncMain { completionHandler(status == .authorized) }
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
    public static func requestAccessAudio(_ completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.lx.asyncMain { completionHandler(granted) }
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
    /// - Parameter completionHandler: 异步回调检查结果（主线程执行）
    @available(iOS 10.0, *)
    public static func checkNotificationSupport(_ completionHandler: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.lx.asyncMain {
                completionHandler(settings.authorizationStatus != .denied)
            }
        }
    }
    
    /// 请求远程通知权限（iOS 10+）
    /// - 说明: 自动注册远程通知并触发系统权限弹窗
    /// - Parameter completionHandler: 异步回调授权结果（主线程执行）
    @available(iOS 10.0, *)
    public static func registerRemoteNotifications(_ completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.lx.asyncMain { completionHandler(granted) }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
}
