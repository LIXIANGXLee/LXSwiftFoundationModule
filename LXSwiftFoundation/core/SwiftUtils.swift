//
//  SwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit
import AVFoundation

@objc(LXObjcSUtils)
@objcMembers public final class SwiftUtils: NSObject {
    public typealias TellCallBack = ((Bool) -> ())
    
    /// 注意：枚举不暴漏给oc使用，和用到此枚举的函数也不暴漏给oc使用
    @objc public enum CompareResult: Int {
        case big = 1     /// 大于
        case equal = 0   /// 等于
        case small = -1  /// 小于
    }
    
    /// 两个版本比较大小 big: one > two, small: two < one, equal: one == two
    public static func versionCompareSwift(v1: String, v2: String) -> SwiftUtils.CompareResult {
        SwiftUtils.compareResult(v1.compare(v2).rawValue)
    }
    
    /// 打电话
    public static func openTel(with number: String?, _ tellCallBack: SwiftUtils.TellCallBack? = nil) {
        if let number = number,
           let url = URL(string: "tel:" + number) {
            if UIApplication.lx.isCanOpen(url) {
                UIApplication.lx.openUrl(url)
            }
        }
    }

    /// 在小数点后保留几个有效数字
    public static func formatDecimalString(with text: String, digits: Int, mode: NumberFormatter.RoundingMode = .down) -> String {
        guard let m = Double(text) else {
            return text
        }
        let number = NSNumber(value: m)
        return number.numberFormatter(with: .down, minDigits: digits, maxDigits: digits) ?? text
    }

    /// 小数点后保留二位有效数字
    public static func formatDecimalStringTwo(with text: String) -> String {
        formatDecimalString(with: text, digits: 2)
    }
    
    /// 小数点后保留三位有效数字
    public static func formatDecimalStringThree(with text: String) -> String {
        formatDecimalString(with: text, digits: 3)
    }
    
    /// 小数点后保留四位有效数字
    public static func formatDecimalStringFour(with text: String) -> String {
        formatDecimalString(with: text, digits: 4)
    }
    
    /// 从路径看plist变换字典
    public static func readDictionary(with path: String?) -> Dictionary<String, Any>? {
        guard let path = path else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data.lx.dataToPlistDictionary
    }
    
    /// 识别二维码图片
    public static func getQrCodeString(with image: UIImage?) -> String? {
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let cgImage = image?.cgImage else {
            return nil
        }
        let ciImage = CIImage(cgImage: cgImage)
        let feature = detector?.features(in: ciImage).first as? CIQRCodeFeature
        return feature?.messageString
    }
    
    /// 异步获取二维码信息
    public static func async_getQrCodeString(with image: UIImage?, complete: @escaping (String?) -> ()) {
        DispatchQueue.global().async{
            let async_qrString = self.getQrCodeString(with: image)
            DispatchQueue.main.async(execute: {
                complete(async_qrString)
            })
        }
    }
    
    /// 创建二维码图像
    public static func getQrCodeImage(with qrCodeStr: String?, size: CGFloat = 800) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let qrData = qrCodeStr?.data(using: String.Encoding.utf8)
        filter?.setValue(qrData, forKey: "inputMessage")
        guard let qrImage = filter?.outputImage else {
            return nil
        }
        return createNonInterpolatedImage(with: qrImage, size: size)
    }
    
    /// 异步创建二维码图像
    public static func async_getQrCodeImage(with qrCodeStr: String?, size: CGFloat = 800, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_qrImage = self.getQrCodeImage(with: qrCodeStr, size: size)
            DispatchQueue.main.async(execute: {
                complete(async_qrImage)
            })
        }
    }
    
    /// 播放本地短暂的语音
    @available(iOS 9.0, *)
    public static func playSound(with filepath: String?, completion: (() -> ())? = nil) {
        guard let string = filepath, string.count > 0 else {
            return
        }
        var soundID: SystemSoundID = 0
        let fileUrl = URL(fileURLWithPath: string)
        AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
        AudioServicesPlaySystemSoundWithCompletion(soundID, {
            AudioServicesDisposeSystemSoundID(soundID)
            completion?()
        })
    }
    
    /// 根据url获取视频的size
    public static func videoSize(with url: URL) -> CGSize? {
        AVAsset(url: url)
            .tracks(withMediaType: .video)
            .first?
            .naturalSize
    }
    
    /// 获取视频旋转角度
    public static func videoDegress(from asset: AVAsset) -> Int {
        var degress: Int = 0
        guard let track = asset.tracks(withMediaType: .video).first else {
            return degress
        }
        let t = track.preferredTransform
        if t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0 {
            // Portrait
            degress = 90
        } else if t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0 {
            // PortraitUpsideDown
            degress = 270
        } else if t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0 {
            // Right
            degress = 0
        } else if t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0 {
            // Left
            degress = 180
        }
        return degress
    }
    
    /// 根据视频角度获取视频大小
    public static func videoTransformSize(from asset: AVAsset) -> CGSize {
        let degrees = videoDegress(from: asset)
        var videoSize = CGSize.zero
        guard let track = asset.tracks(withMediaType: .video).first else {
            return videoSize
        }
        switch degrees {
        case 90:
            fallthrough
        case 270:
            videoSize = CGSize(width: track.naturalSize.height, height: track.naturalSize.width)
        case 180:
            videoSize = CGSize(width: track.naturalSize.width, height: track.naturalSize.height)
        default:
            videoSize = track.naturalSize
        }
        return videoSize
    }
    
    
    /// 旋转 CGAffineTransform
    public static func videoTransform(from asset: AVAsset) -> CGAffineTransform {
        let degrees = videoDegress(from: asset)
        var transform: CGAffineTransform = .identity
        guard let track = asset.tracks(withMediaType: .video).first else {
            return transform
        }
        switch degrees {
        case 90:
            // 顺时针旋转90°
            let translateToCenter = CGAffineTransform(translationX: track.naturalSize.height, y: 0)
            transform = translateToCenter.rotated(by: CGFloat(Double.pi * 2))
        case 180:
            // 顺时针旋转180°
            let translateToCenter = CGAffineTransform(translationX: track.naturalSize.width, y: track.naturalSize.height)
            transform = translateToCenter.rotated(by: CGFloat(Double.pi))
        case 270:
            // 顺时针旋转270°
            let translateToCenter = CGAffineTransform(translationX: 0, y: track.naturalSize.width)
            transform = translateToCenter.rotated(by: CGFloat(Double.pi * 2 / 3))
        default:
            transform = track.preferredTransform;
        }
        return transform
    }
    
    /// 已经进入App
    public static func didBecomeActive(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    /// 即将退出App
    public static func willResignActive(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// 监听键盘即将弹起
    public static func keyboardWillShow(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    /// 监听键盘已经弹起
    public static func keyboardDidShow(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    /// 监听键盘即将退下
    public static func keyboardWillHide(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 监听键盘已经退下
    public static func keyboardDidHide(_ observer: Any, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

/// version  init
extension SwiftUtils {
    
    /// 根据int值获取枚举值
    private static func compareResult(_ ret: Int) -> SwiftUtils.CompareResult {
        switch ret {
        case 0: return .equal
        case -1: return .small
        case 1: return .big
        default: return .small
        }
    }
    
    /// 生成二维码后，因为它不是真实的图片，所以需要重新绘制
    private static func createNonInterpolatedImage(with ciImage: CIImage, size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
        if extent.width == 0 || extent.height == 0 {
            return nil
        }
        
        let scale = min(size / extent.width, size / extent.height)
        let width = extent.width * scale;
        let height = extent.height * scale;
        let colorSpace = CGColorSpaceCreateDeviceGray();
        guard let bitmapRef = CGContext(data: nil,
                                        width: Int(width),
                                        height: Int(height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: colorSpace,
                                        bitmapInfo: CGImageAlphaInfo.none.rawValue ) else {
            return nil
        }
        bitmapRef.interpolationQuality = CGInterpolationQuality.high
        bitmapRef.scaleBy(x: scale, y: scale)
        let context = CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.draw(bitmapImage, in: extent)
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        return UIImage(cgImage: scaledImage)
    }
}
