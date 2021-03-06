//
//  LXSwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftUtils: LXSwiftCompatible {
    
    /// callBack after  call tell
    public typealias TellCallBack = ((Bool) -> ())
    
    /// version enum
    public enum VersionCompareResult {
        case big
        case equal
        case small
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
    
    /// one version campare two version
    ///
    /// - Parameters:
    /// - v1: one version
    /// - v2: two version
    /// - Returns: big: one > two  ,small:two  < one,equal:one == two
    public static func versionCompare(v1: String, v2: String)
    -> LXSwiftUtils.VersionCompareResult {
        let ret = _compareVersionInSwift(v1, v2)
        return LXSwiftUtils.VersionCompareResult(rawValue: ret)
    }
    
    /// one version campare two version
    ///
    /// - Parameters:
    /// - v1: one version
    /// - v2: two version
    /// - Returns: big: one > two  ,small:two  < one,equal:one == two
    public static func versionCompare(_ v1: String, _ v2: String)
    -> LXSwiftUtils.VersionCompareResult {

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
    
    /// call tel for all app
    public static func openTel(with number: String?,
                               _ tellCallBack: LXSwiftUtils.TellCallBack? = nil) {
        if let number = number,
            let url = URL(string: "tel:" + number) {
            if UIApplication.lx.isCanOpen(url) {
                UIApplication.lx.openUrl(url)
            }
        }
    }
    
    /// 在小数点后保留几个有效数字
    ///
    /// - Parameters:
    /// - text: text string
    /// - digits: digits Number of significant digits reserved
    /// - mode: mode
    /// - Returns: string
    public static func formatDecimalString(with text: String, _ digits: Int,
                                           _ mode: NumberFormatter.RoundingMode = .down)
    -> String {
        guard let m = Double(text) else { return text }
        return NSNumber(value: m).numberFormatter(with: .down,
                                                  minDigits: digits,
                                                  maxDigits: digits) ?? text
    }

    ///小数点后保留二位有效数字
    public static func formatDecimalStringTwo(with text: String) -> String {
       return formatDecimalString(with: text, 2)
    }
    
    ///小数点后保留三位有效数字
    public static func formatDecimalStringThree(with text: String) -> String {
       return formatDecimalString(with: text, 3)
    }
    
    ///小数点后保留四位有效数字
    public static func formatDecimalStringFour(with text: String) -> String {
       return formatDecimalString(with: text, 4)
    }
    
    /// 从路径看plist变换字典
    ///
    /// - Parameter data: path
    /// - Returns: Dictionary
    public static func readDictionary(with path: String?) -> Dictionary<String, Any>? {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data.lx.dataToPlistDictionary
    }
}


//MARK: -  Extending methods for LXSwiftTool
extension LXSwiftBasics where Base == LXSwiftUtils {
        
    /// get QR code information
    public static func getQrCodeString(with image: UIImage?) -> String? {
        let context =  CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let cgImage = image?.cgImage else {
            return nil
        }
        let ciImage =  CIImage(cgImage: cgImage)
        let feature = detector?.features(in: ciImage).first as? CIQRCodeFeature
        return feature?.messageString
    }
    
    /// async get QR code information
    public static func async_getQrCodeString(with image: UIImage?,
                                             complete: @escaping (String?) -> ()) {
        DispatchQueue.global().async{
            let async_qrString = self.getQrCodeString(with: image)
            DispatchQueue.main.async(execute: {
                complete(async_qrString)
            })
        }
    }
    
    /// create QR code image
    public static func getQrCodeImage(with qrCodeStr: String?,
                                      size: CGFloat = 800) -> UIImage? {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let qrData = qrCodeStr?.data(using: String.Encoding.utf8)
        filter?.setValue(qrData, forKey: "inputMessage")
        guard let qrImage = filter?.outputImage else {
            return nil
        }
        return createNonInterpolatedImage(with: qrImage, size: size)
    }
    
    /// async create QR code image
    public static func async_getQrCodeImage(with qrCodeStr: String?,
                                            size: CGFloat = 800,
                                            complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_qrImage = self.getQrCodeImage(with: qrCodeStr,
                                                    size: size)
            DispatchQueue.main.async(execute: {
                complete(async_qrImage)
            })
        }
    }
    
    /// After generating the QR code,
    /// because it is not a real picture, it needs to be redrawn
    private static func createNonInterpolatedImage(with ciImage: CIImage,
                                                   size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
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
        let context =  CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(ciImage,
                                                      from: extent) else {
            return nil
        }
        bitmapRef.draw(bitmapImage, in: extent)
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        return UIImage(cgImage: scaledImage)
    }
}
