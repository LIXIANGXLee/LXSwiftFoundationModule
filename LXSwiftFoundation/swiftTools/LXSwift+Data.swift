//
//  LXSwift+Data.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// const
private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8]
private let jpgHeaderIF: [UInt8] = [0xFF]
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46]

/// image type enum
public enum LXSwiftImageDataType {
    case Unknown, PNG, JPEG, GIF
}

extension Data: LXSwiftCompatible {
    fileprivate static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain"
        ]
}

extension NSData: LXSwiftCompatible { }

//MARK: -  Extending properties  for Data
extension LXSwiftBasics where Base == Data {
    
    /// 数据转换utf8字符串
    public var utf8String: String? {
        return String(data: base, encoding: .utf8)
    }
    
    /// 数据传输uiimage的base64
    public var base64DecodingImage: UIImage? {
        guard let base64Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: base64Data)
    }
    
    /// 文件类型
    public var mimeType: String {
        var c: UInt8 = 0
        base.copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }

    /// data转换字典
    public var dataToPlistDictionary: Dictionary<String, Any>? {
        guard let propertyList = try? PropertyListSerialization.propertyList(from: base,  options: .init(rawValue: 0),format: nil) else { return nil }
        return propertyList as? Dictionary<String, Any>
    }
}

//MARK: -  Extending properties  for NSData
extension LXSwiftBasics where Base == NSData {
  
    /// 判断data是不是gif类型图片
    public var isGIF: Bool {
        return base.lx.imageType == .GIF
    }
    
    /// data类型
    public var imageType: LXSwiftImageDataType {
        var buffer = [UInt8](repeating: 0, count: 8)
        base.getBytes(&buffer, length: 8)
        var type: LXSwiftImageDataType = .Unknown
        if buffer == pngHeader {
            type = .PNG
        } else if buffer[0] == jpgHeaderSOI[0] &&
            buffer[1] == jpgHeaderSOI[1] &&
            buffer[2] == jpgHeaderIF[0] {
            type = .JPEG
        } else if buffer[0] == gifHeader[0] &&
            buffer[1] == gifHeader[1] &&
            buffer[2] == gifHeader[2] {
            type = .GIF
        }
        return type
    }
}
