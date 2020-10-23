//
//  LXSwiftTool.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftTool: LXSwiftCompatible { }

//MARK: -  Extending methods for LXSwiftTool
extension LXSwiftBasics where Base == LXSwiftTool {
    
    ///  from path to read plist tranform Dictionary
    ///
    /// - Parameter data: path
    /// - Returns: Dictionary
    public static func readDictionary(with path: String?) -> Dictionary<String, Any>? {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        return LXSwiftTool.lx.getDictionary(with: data)
    }
    
    
    ///  string tranform Dictionary
    ///
    /// - Parameter data: string
    /// - Returns: Dictionary
    public static func getDictionary( with string: String?) -> Dictionary<String, Any>?  {
        let data = string?.data(using: .utf8)
        return LXSwiftTool.lx.getDictionary(with: data)
    }
    
    
    ///  data tranform Dictionary
    ///
    /// - Parameter data: data
    /// - Returns: Dictionary
    public static func getDictionary(with data: Data?) -> Dictionary<String, Any>? {
        guard let data = data,
            let propertyList = try? PropertyListSerialization.propertyList(from: data, options: .init(rawValue: 0), format: nil) else { return nil }
        return propertyList as? Dictionary<String, Any>
    }
    
    /// get QR code information
    public static func  getQrCodeString(with image: UIImage?) -> String? {
        let context =  CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        guard let cgImage = image?.cgImage else { return nil }
        let ciImage =  CIImage(cgImage: cgImage)
        guard let feature = detector?.features(in: ciImage).first as? CIQRCodeFeature else { return nil }
        return feature.messageString
    }
    
    /// async get QR code information
    public static func async_getQrCodeString(with image: UIImage?, complete: @escaping (String?) -> ()) {
        DispatchQueue.global().async{
            let async_qrString = self.getQrCodeString(with: image)
            DispatchQueue.main.async(execute: {
                complete(async_qrString)
            })
        }
    }
    
    /// create QR code image
    public static func  getQrCodeImage(with qrCodeStr: String?,size: CGFloat = 800) -> UIImage? {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let qrData = qrCodeStr?.data(using: String.Encoding.utf8)
        filter?.setValue(qrData, forKey: "inputMessage")
        guard let qrImage = filter?.outputImage else { return nil }
        return createNonInterpolatedImage(with: qrImage, size: size)
    }
    
    /// async create QR code image
    public static func async_getQrCodeImage(with qrCodeStr: String?,size: CGFloat = 800, complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_qrImage = self.getQrCodeImage(with: qrCodeStr, size: size)
            DispatchQueue.main.async(execute: {
                complete(async_qrImage)
            })
        }
    }
    
    /// After generating the QR code, because it is not a real picture, it needs to be redrawn
    private static func createNonInterpolatedImage(with ciImage: CIImage, size: CGFloat) -> UIImage? {
        let extent = ciImage.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        let width = extent.width * scale;
        let height = extent.height * scale;
        
        let colorSpace = CGColorSpaceCreateDeviceGray();
        guard let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue ) else { return nil }
        bitmapRef.interpolationQuality = CGInterpolationQuality.high
        bitmapRef.scaleBy(x: scale, y: scale)
        let context =  CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else { return nil }
        bitmapRef.draw(bitmapImage, in: extent)
        guard let scaledImage = bitmapRef.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
    }
    
}
