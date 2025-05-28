//
//  Swift+Data.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - 常量定义
private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] // PNG文件头标识
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8] // JPEG文件开始标识(Start Of Image)
private let jpgHeaderIF: [UInt8] = [0xFF] // JPEG标记前缀
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46] // GIF文件头标识("GIF"的ASCII码)

/// 图片类型枚举
public enum SwiftImageDataType {
    case unknown
    case png
    case jpeg
    case gif
    
    // 优化建议：使用小写开头更符合Swift命名规范
}

// MARK: - Data扩展
extension SwiftBasics where Base == Data {
    
    /// 将Data转换为UTF-8编码的字符串
    public var utf8String: String? {
        String(data: base, encoding: .utf8)
    }
    
    /// 将Base64编码的Data解码为UIImage
    public var base64DecodingImage: UIImage? {
        guard let base64Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: base64Data)
    }
    
    /// 获取数据的MIME类型
    public var mimeType: String {
        var firstByte: UInt8 = 0
        base.copyBytes(to: &firstByte, count: 1)
        return Data.mimeTypeSignatures[firstByte] ?? "application/octet-stream"
    }

    /// 将Property List数据转换为字典
    public var dataToPlistDictionary: [String: Any]? {
        guard let propertyList = try? PropertyListSerialization.propertyList(
            from: base,
            options: [],
            format: nil
        ) else {
            return nil
        }
        return propertyList as? [String: Any]
    }
}

// MARK: - NSData扩展
extension SwiftBasics where Base == NSData {
    
    /// 判断数据是否为GIF图片
    public var isGIF: Bool {
        base.lx.imageType == .gif
    }
    
    /// 获取图片数据类型
    public var imageType: SwiftImageDataType {
        var buffer = [UInt8](repeating: 0, count: 8)
        base.getBytes(&buffer, length: 8)
        
        // PNG检测
        if buffer == pngHeader {
            return .png
            // JPEG检测 (SOI + 标记前缀)
        } else if buffer[0] == jpgHeaderSOI[0] &&
           buffer[1] == jpgHeaderSOI[1] &&
           buffer[2] == jpgHeaderIF[0] {
            return .jpeg
            // GIF检测 ("GIF")
        } else if buffer[0] == gifHeader[0] &&
           buffer[1] == gifHeader[1] &&
           buffer[2] == gifHeader[2] {
            return .gif
        }
        
        return .unknown
    }
}
