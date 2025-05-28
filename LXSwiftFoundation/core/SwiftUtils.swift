//
//  SwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit
import AVFoundation

/// Swift工具集，提供常用功能封装
@objc(LXObjcSUtils)
@objcMembers public final class SwiftUtils: NSObject {
    /// 回调类型定义
    public typealias TellCallBack = ((Bool) -> Void)
    
    /// 版本比较结果枚举
    @objc public enum CompareResult: Int {
        case big = 1     /// 大于
        case equal = 0   /// 等于
        case small = -1  /// 小于
    }
    
    // MARK: - 版本比较
    /// 比较两个版本号字符串
    /// - Parameters:
    ///   - v1: 版本号字符串1 (格式要求: "x.x.x")
    ///   - v2: 版本号字符串2
    /// - Returns: 比较结果枚举值
    public static func versionCompareSwift(v1: String, v2: String) -> SwiftUtils.CompareResult {
        return compareResult(v1.compare(v2, options: .numeric))
    }
    
    // MARK: - 系统功能
    /// 调用系统拨号功能
    /// - Parameters:
    ///   - number: 电话号码字符串
    ///   - tellCallBack: 拨号操作结果回调
    public static func openTel(with number: String?, _ tellCallBack: TellCallBack? = nil) {
        guard let number = number?.trimmingCharacters(in: .whitespaces),
              !number.isEmpty,
              let url = URL(string: "tel://" + number) else {
            tellCallBack?(false)
            return
        }
        
        UIApplication.lx.openUrl(url, completionHandler: tellCallBack)
        
    }
    
    // MARK: - 数字格式化
    /// 格式化小数位字符串
    /// - Parameters:
    ///   - text: 原始字符串
    ///   - digits: 保留小数位数
    ///   - mode: 舍入模式 (默认向下取整)
    /// - Returns: 格式化后的字符串
    public static func formatDecimalString(
        with text: String,
        digits: Int,
        mode: NumberFormatter.RoundingMode = .down
    ) -> String {
        // 清理无效字符
        let cleanText = text
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        guard !cleanText.isEmpty, let value = Double(cleanText) else {
            return text
        }
        
        // 创建数字格式化器
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        formatter.roundingMode = mode
        
        return formatter.string(from: NSNumber(value: value)) ?? text
    }
    
    // MARK: - 文件操作
    /// 从Plist文件路径读取字典
    /// - Parameter path: plist文件路径
    /// - Returns: 解析后的字典 (失败返回nil)
    public static func readDictionary(from path: String?) -> [String: Any]? {
        guard let path = path, FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any]
        } catch {
            SwiftLog.log("Plist读取失败: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - 二维码处理
    /// 同步识别二维码图片
    /// - Parameter image: 包含二维码的图片
    /// - Returns: 识别出的字符串 (失败返回nil)
    public static func getQrCodeString(with image: UIImage?) -> String? {
        guard let cgImage = image?.cgImage else { return nil }
        
        let context = CIContext(options: [.useSoftwareRenderer: false])
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: context,
            options: options
        ) else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        guard let feature = detector.features(in: ciImage).first as? CIQRCodeFeature else {
            return nil
        }
        
        return feature.messageString
    }
    
    /// 异步识别二维码图片
    public static func async_getQrCodeString(
        with image: UIImage?,
        complete: @escaping (String?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = getQrCodeString(with: image)
            DispatchQueue.main.async { complete(result) }
        }
    }
    
    /// 生成二维码图片
    /// - Parameters:
    ///   - qrCodeStr: 二维码内容字符串
    ///   - size: 生成图片尺寸 (默认800px)
    /// - Returns: 生成的二维码图片
    public static func getQrCodeImage(
        with qrCodeStr: String?,
        size: CGFloat = 800
    ) -> UIImage? {
        guard let content = qrCodeStr, !content.isEmpty else { return nil }
        
        // 创建二维码过滤器
        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
              let data = content.data(using: .utf8) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // 设置容错级别
        
        guard let outputImage = filter.outputImage else { return nil }
        
        // 缩放处理
        let scale = size / outputImage.extent.size.width
        let transformedImage = outputImage.transformed(
            by: CGAffineTransform(scaleX: scale, y: scale))
        
        // 转换为UIImage
        return UIImage(ciImage: transformedImage)
    }
    
    /// 异步生成二维码图片
    public static func async_getQrCodeImage(
        with qrCodeStr: String?,
        size: CGFloat = 800,
        complete: @escaping (UIImage?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let image = getQrCodeImage(with: qrCodeStr, size: size)
            DispatchQueue.main.async { complete(image) }
        }
    }
    
    // MARK: - 音频处理
    /// 播放短音频文件 (支持iOS9+)
    /// - Parameters:
    ///   - filepath: 音频文件路径
    ///   - completion: 播放完成回调
    @available(iOS 9.0, *)
    public static func playSound(
        with filepath: String?,
        completion: (() -> Void)? = nil
    ) {
        guard let path = filepath,
              FileManager.default.fileExists(atPath: path) else {
            return
        }
        
        var soundID: SystemSoundID = 0
        let fileURL = URL(fileURLWithPath: path)
        
        let status = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
        guard status == kAudioServicesNoError else {
            SwiftLog.log("音频加载失败: \(status)")
            return
        }
        
        AudioServicesPlaySystemSoundWithCompletion(soundID) {
            AudioServicesDisposeSystemSoundID(soundID)
            completion?()
        }
    }
    
    // MARK: - 视频处理
    /// 获取视频原始尺寸
    public static func videoSize(with url: URL) -> CGSize? {
        AVAsset(url: url)
            .tracks(withMediaType: .video)
            .first?
            .naturalSize
    }
    
    /// 获取视频旋转角度
    /// - Parameter asset: 视频资源对象
    /// - Returns: 旋转角度 (0, 90, 180, 270)
    public static func videoDegress(from asset: AVAsset) -> Int {
        guard let track = asset.tracks(withMediaType: .video).first else {
            return 0
        }
        
        let transform = track.preferredTransform
        let radians = atan2(transform.b, transform.a)
        let degrees = abs(radians * 180 / .pi)
        
        switch degrees {
        case 0: return 0
        case 90: return 90
        case 180: return 180
        case 270: return 270
        default: return 0
        }
    }
    
    /// 获取校正后的视频尺寸 (考虑旋转)
    public static func videoTransformSize(from asset: AVAsset) -> CGSize {
        guard let track = asset.tracks(withMediaType: .video).first else {
            return .zero
        }
        
        let size = track.naturalSize
        let degrees = videoDegress(from: asset)
        
        switch degrees {
        case 90, 270:
            return CGSize(width: size.height, height: size.width)
        default:
            return size
        }
    }
    
    // MARK: - 通知注册
    /// 注册App激活通知
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
    
    // 其他通知注册方法保持类似结构...
    
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
