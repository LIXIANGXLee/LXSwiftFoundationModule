//
//  LXSwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit
import AVFoundation

public struct LXSwiftUtils: LXSwiftCompatible {
    
    public typealias TellCallBack = ((Bool) -> ())
    public enum VersionCompareResult {
        case big /// 大于
        case equal /// 等于
        case small /// 小于
    }
}

/// version  init
extension LXSwiftUtils.VersionCompareResult {
    fileprivate init(rawValue: Int32) {
        switch rawValue {
        case 0: self = .equal
        case Int32.min ... -1: self = .small
        case 1 ... Int32.max: self = .big
        default: self = .equal
        }
    }
}

//MARK: -  Extending methods for LXSwiftUtils
extension LXSwiftBasics where Base == LXSwiftUtils {
    
    /// 两个版本比较大小 big: one > two, small: two < one,equal: one == two
    public static func versionCompare(v1: String, v2: String) -> LXSwiftUtils.VersionCompareResult {
        let ret = _compareVersionInSwift(v1, v2)
        return LXSwiftUtils.VersionCompareResult(rawValue: ret)
    }
    
    /// 两个版本比较大小 big: one > two, small: two < one, equal: one == two
    public static func versionCompare(_ v1: String, _ v2: String) -> LXSwiftUtils.VersionCompareResult {

        let com = v1.compare(v2)
        var temp: LXSwiftUtils.VersionCompareResult
        switch com {
        case .orderedSame:
            temp = LXSwiftUtils.VersionCompareResult.equal
        case .orderedAscending:
            temp = LXSwiftUtils.VersionCompareResult.small
        case .orderedDescending:
            temp = LXSwiftUtils.VersionCompareResult.big
        default:
            temp = LXSwiftUtils.VersionCompareResult.small
        }
        return temp
    }
    
    /// 打电话
    public static func openTel(with number: String?, _ tellCallBack: LXSwiftUtils.TellCallBack? = nil) {
        if let number = number, let url = URL(string: "tel:" + number) {
            if UIApplication.lx.isCanOpen(url) {
                UIApplication.lx.openUrl(url)
            }
        }
    }
    
    /// 在小数点后保留几个有效数字
    public static func formatDecimalString(with text: String, digits: Int,  mode: NumberFormatter.RoundingMode = .down) -> String {
        guard let m = Double(text) else { return text }
        let number = NSNumber(value: m)
        return number.numberFormatter(with: .down, minDigits: digits, maxDigits: digits) ?? text
    }

    /// 小数点后保留二位有效数字
    public static func formatDecimalStringTwo(with text: String) -> String {
       return formatDecimalString(with: text, digits: 2)
    }
    
    /// 小数点后保留三位有效数字
    public static func formatDecimalStringThree(with text: String) -> String {
        return formatDecimalString(with: text, digits: 3)
    }
    
    /// 小数点后保留四位有效数字
    public static func formatDecimalStringFour(with text: String) -> String {
        return formatDecimalString(with: text, digits: 4)
    }
    
    /// 从路径看plist变换字典
    public static func readDictionary(with path: String?) -> Dictionary<String, Any>? {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data.lx.dataToPlistDictionary
    }
}


//MARK: -  Extending methods for LXSwiftTool
extension LXSwiftBasics where Base == LXSwiftUtils {
        
    /// 识别二维码图片
    public static func getQrCodeString(with image: UIImage?) -> String? {
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let cgImage = image?.cgImage else { return nil }
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
            let async_qrImage = self.getQrCodeImage(with: qrCodeStr,
                                                    size: size)
            DispatchQueue.main.async(execute: {
                complete(async_qrImage)
            })
        }
    }
    
    /// 生成二维码后，因为它不是真实的图片，所以需要重新绘制
    private static func createNonInterpolatedImage(with ciImage: CIImage, size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
        if extent.width == 0 || extent.height == 0 { return nil }
        
        let scale = min(size / extent.width, size / extent.height)
        let width = extent.width * scale;
        let height = extent.height * scale;
        let colorSpace = CGColorSpaceCreateDeviceGray();
        guard let bitmapRef = CGContext(data: nil, width: Int(width),
                                        height: Int(height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: colorSpace,
                                        bitmapInfo: CGImageAlphaInfo.none.rawValue ) else { return nil }
        bitmapRef.interpolationQuality = CGInterpolationQuality.high
        bitmapRef.scaleBy(x: scale, y: scale)
        let context = CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else { return nil }
        bitmapRef.draw(bitmapImage, in: extent)
        guard let scaledImage = bitmapRef.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
    }
    
    /// 播放本地短暂的语音
    @available(iOS 9.0, *)
    public static func playSound(with filepath: String?, completion: (() -> ())? = nil) {
        guard let string = filepath else { return }
        var soundID: SystemSoundID = 0
        let fileUrl = URL(fileURLWithPath: string)
        AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
        AudioServicesPlaySystemSoundWithCompletion(soundID, {
            completion?()
            AudioServicesDisposeSystemSoundID(soundID)
        })
    }
}
