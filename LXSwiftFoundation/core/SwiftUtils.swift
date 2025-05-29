//
//  SwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit
import AVFoundation

/// Swift工具集，提供iOS开发中常用功能的封装
@objc(LXObjcSUtils)
@objcMembers public final class SwiftUtils: NSObject {
    
    // MARK: - 类型定义
    
    /// 回调类型定义 (布尔值表示操作结果)
    public typealias TellCallBack = ((Bool) -> Void)
    
    /// 版本比较结果枚举
    @objc public enum CompareResult: Int {
        case big = 1     /// 版本大于目标版本
        case equal = 0   /// 版本等于目标版本
        case small = -1  /// 版本小于目标版本
    }
    
    // MARK: - 版本比较
    
    /// 比较两个语义化版本号 (Semantic Versioning)
    /// - Parameters:
    ///   - v1: 版本号字符串1 (格式: "主版本.次版本.修订号")
    ///   - v2: 版本号字符串2
    /// - Returns: 比较结果枚举值
    ///
    /// 示例:
    ///   versionCompareSwift(v1: "2.3.1", v2: "2.1.4") -> .big
    public static func versionCompareSwift(v1: String, v2: String) -> SwiftUtils.CompareResult {
        return compareResult(v1.compare(v2, options: .numeric))
    }
    
    // MARK: - 系统功能
    
    /// 调用系统拨号功能
    /// - Parameters:
    ///   - number: 电话号码字符串 (自动过滤无效字符)
    ///   - tellCallBack: 拨号操作结果回调 (布尔值表示是否成功)
    ///
    /// 注意: 在模拟器上始终返回失败
    public static func openTel(with number: String?, _ tellCallBack: TellCallBack? = nil) {
        // 1. 清理并验证电话号码
        guard let number = number?.trimmingCharacters(in: .whitespaces),
              !number.isEmpty,
              let url = URL(string: "tel://" + number) else {
            tellCallBack?(false)
            return
        }
        
        // 2. 通过扩展方法打开系统拨号
        UIApplication.lx.openUrl(url, completionHandler: tellCallBack)
    }
    
    // MARK: - 数字格式化
    
    /// 格式化数字字符串的小数位数
    /// - Parameters:
    ///   - text: 原始数字字符串 (可含逗号分隔符)
    ///   - digits: 保留的小数位数
    ///   - mode: 舍入模式 (默认向下取整)
    /// - Returns: 格式化后的字符串
    ///
    /// 示例:
    ///   formatDecimalString(with: "12345.6789", digits: 2) -> "12,345.67"
    public static func formatDecimalString(
        with text: String,
        digits: Int,
        mode: NumberFormatter.RoundingMode = .down
    ) -> String {
        // 1. 清理输入字符串
        let cleanText = text
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // 2. 验证并转换数值
        guard !cleanText.isEmpty, let value = Double(cleanText) else {
            return text
        }
        
       // 配置数字格式化器 返回格式化结果
        return NSNumber(value: value).lx.numberFormatter(with: mode, minDigits: digits, maxDigits: digits) ?? text
    }
    
    // MARK: - 文件操作
    
    /// 从Plist文件路径读取字典数据
    /// - Parameter path: plist文件绝对路径
    /// - Returns: 解析后的字典 (失败返回nil)
    ///
    /// 注意: 文件需为有效的Property List格式
    public static func readDictionary(from path: String?) -> [String: Any]? {
        // 1. 验证文件存在性
        guard let path = path, FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        
        do {
            // 2. 读取文件数据
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // 3. 反序列化Property List
            return try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any]
        } catch {
            // 4. 错误处理
            SwiftLog.log("Plist文件读取失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - 二维码处理
    
    /// 同步识别二维码图片中的信息
    /// - Parameter image: 包含二维码的图片
    /// - Returns: 识别出的字符串 (失败返回nil)
    ///
    /// 注意: 使用高性能的Core Image识别引擎
    public static func getQrCodeString(with image: UIImage?) -> String? {
        // 1. 获取图片CGImage
        guard let cgImage = image?.cgImage else { return nil }
        
        // 2. 创建Core Image上下文
        let context = CIContext(options: [.useSoftwareRenderer: false])
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        
        // 3. 创建二维码检测器
        guard let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: context,
            options: options
        ) else { return nil }
        
        // 4. 执行二维码检测
        let ciImage = CIImage(cgImage: cgImage)
        guard let feature = detector.features(in: ciImage).first as? CIQRCodeFeature else {
            return nil
        }
        
        // 5. 返回识别结果
        return feature.messageString
    }
    
    /// 异步识别二维码图片 (后台线程处理，主线程回调)
    public static func async_getQrCodeString(
        with image: UIImage?,
        complete: @escaping (String?) -> Void
    ) {
        
        DispatchQueue.lx.asyncOperation {
            getQrCodeString(with: image)
        } completion: { result in
            complete(result)
        }

    }
    
    /// 生成二维码图片
    /// - Parameters:
    ///   - qrCodeStr: 二维码内容字符串
    ///   - size: 生成图片的边长 (默认800px)
    /// - Returns: 生成的二维码图片 (失败返回nil)
    ///
    /// 使用"H"级容错率 (约30%纠错能力)
    public static func getQrCodeImage(
        with qrCodeStr: String?,
        size: CGFloat = 800
    ) -> UIImage? {
        // 1. 验证输入内容
        guard let content = qrCodeStr, !content.isEmpty else { return nil }
        
        // 2. 创建二维码过滤器
        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
              let data = content.data(using: .utf8) else {
            return nil
        }
        
        // 3. 配置过滤器参数
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // 高容错级别
        
        // 4. 获取输出图像
        guard let outputImage = filter.outputImage else { return nil }
        
        // 5. 计算缩放比例
        let scale = size / outputImage.extent.size.width
        let transformedImage = outputImage.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale))
        
        // 6. 转换为UIImage
        return UIImage(ciImage: transformedImage)
    }
    
    /// 异步生成二维码图片 (后台线程处理，主线程回调)
    public static func async_getQrCodeImage(
        with qrCodeStr: String?,
        size: CGFloat = 800,
        complete: @escaping (UIImage?) -> Void
    ) {
        
        DispatchQueue.lx.asyncOperation {
            getQrCodeImage(with: qrCodeStr, size: size)
        } completion: { result in
            complete(result)
        }

    }
    
    // MARK: - 音频处理
    
    /// 播放短音频文件 (系统声音)
    /// - Parameters:
    ///   - filepath: 音频文件绝对路径
    ///   - completion: 播放完成回调
    ///
    /// 要求: iOS 9.0+，支持常见音频格式(caf, wav, aiff)
    @available(iOS 9.0, *)
    public static func playSound(
        with filepath: String?,
        completion: (() -> Void)? = nil
    ) {
        // 1. 验证文件存在性
        guard let path = filepath,
              FileManager.default.fileExists(atPath: path) else {
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
            completion?()
        }
    }
    
    // MARK: - 视频处理
    
    /// 获取视频文件的原始尺寸 (考虑旋转)
    /// - Parameter url: 视频文件URL
    /// - Returns: 校正后的视频尺寸 (失败返回nil)
    ///
    /// 自动处理旋转导致的宽高交换
    public static func videoSize(with url: URL) -> CGSize? {
        // 1. 创建视频资源对象
        let asset = AVURLAsset(url: url)
        
        // 2. 获取视频轨道
        guard let track = asset.tracks(withMediaType: .video).first else {
            return nil
        }
        
        // 3. 应用变换矩阵获取实际尺寸
        let size = track.naturalSize.applying(track.preferredTransform)
        
        // 4. 返回绝对值尺寸 (处理旋转导致的负值)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    /// 获取视频旋转角度
    /// - Parameter asset: 视频资源对象
    /// - Returns: 旋转角度 (0, 90, 180, 270)
    public static func videoDegress(from asset: AVAsset) -> Int {
        guard let track = asset.tracks(withMediaType: .video).first else {
            return 0
        }
        
        // 1. 获取变换矩阵
        let transform = track.preferredTransform
        
        // 2. 计算旋转弧度
        let radians = atan2(transform.b, transform.a)
        
        // 3. 转换为角度 (0-360范围)
        var degrees = radians * 180 / .pi
        if degrees < 0 { degrees += 360 }
        
        // 4. 标准化到常见角度
        switch degrees {
        case 0: return 0
        case 90: return 90
        case 180: return 180
        case 270: return 270
        default: return 0
        }
    }
    
    /// 获取旋转校正后的视频尺寸
    /// - Parameter asset: 视频资源对象
    /// - Returns: 校正后的尺寸 (自动处理90/270度旋转的宽高交换)
    public static func videoTransformSize(from asset: AVAsset) -> CGSize {
        guard let track = asset.tracks(withMediaType: .video).first else {
            return .zero
        }
        
        let size = track.naturalSize
        let degrees = videoDegress(from: asset)
        
        // 处理90/270度旋转的宽高交换
        switch degrees {
        case 90, 270:
            return CGSize(width: size.height, height: size.width)
        default:
            return size
        }
    }
    
    // MARK: - 通知注册
    
    /// 注册App激活通知
    /// - Parameters:
    ///   - observer: 观察者对象
    ///   - selector: 响应方法
    public static func didBecomeActive(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    /// 注册App进入后台通知
    public static func willResignActive(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    // MARK: - 私有辅助方法
    
    /// 转换ComparisonResult为自定义枚举
    private static func compareResult(_ result: ComparisonResult) -> CompareResult {
        switch result {
        case .orderedAscending: return .small
        case .orderedSame: return .equal
        case .orderedDescending: return .big
        }
    }
}
