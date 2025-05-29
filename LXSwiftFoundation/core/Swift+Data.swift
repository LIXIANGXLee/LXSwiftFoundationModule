//
//  Swift+Data.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import Foundation

// MARK: - 图片类型枚举
/// 表示图片数据的格式类型
public enum SwiftImageDataType {
    case unknown  // 未知类型
    case png      // PNG格式
    case jpeg     // JPEG格式
    case gif      // GIF格式
}

// MARK: - 常量定义
private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] // PNG文件头标识 (8字节)
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8] // JPEG文件起始标识(Start Of Image)
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46] // GIF文件头标识("GIF"的ASCII码，前3字节)

// MARK: - MIME类型签名映射
private extension Data {
    /// 文件头字节与MIME类型的映射字典
    static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",   // JPEG文件起始字节
        0x89: "image/png",    // PNG文件起始字节
        0x47: "image/gif",    // GIF文件起始字节('G')
        0x49: "image/tiff",   // TIFF文件起始字节('I')
        0x4D: "image/tiff",   // TIFF文件起始字节('M')
        0x25: "application/pdf",  // PDF文件起始字节('%')
        0xD0: "application/vnd", // Office文档
        0x50: "application/zip"   // ZIP压缩文件('PK')
    ]
}

// MARK: - Data扩展
extension SwiftBasics where Base == Data {
   
    /// 判断是否为GIF图片
    public var isGIF: Bool {
        return imageType == .gif
    }
    
    /// 获取图片数据类型
    public var imageType: SwiftImageDataType {
        return (base as NSData).lx.imageType
    }
    
    /// 获取图片数据类型
    public var mimeType: String {
        return (base as NSData).lx.mimeType
    }
    
    /// 将Data转换为UTF-8编码的字符串
    public var utf8String: String? {
        String(data: base, encoding: .utf8)
    }
    
    /// 将Base64编码的Data解码为UIImage
    public var base64DecodingImage: UIImage? {
        // 忽略无法识别的字符，增强容错性
        guard let base64Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: base64Data)
    }
    
    /// 将Property List数据转换为字典
    public var dataToPlistDictionary: [String: Any]? {
        do {
            // 使用现代API进行属性列表解析
            let plist = try PropertyListSerialization.propertyList(
                from: base,
                options: [],
                format: nil
            )
            return plist as? [String: Any]
        } catch {
            SwiftLog.log("Plist解析错误: \(error.localizedDescription)")
            return nil
        }
    }
}

extension SwiftBasics where Base == NSData {

    /// 获取数据的MIME类型
    public var mimeType: String {
        // 提取首字节进行类型判断
        guard let firstByte = base.first else {
            return "application/octet-stream" // 空数据默认类型
        }
        return Data.mimeTypeSignatures[firstByte] ?? "application/octet-stream"
    }
    
    /// 检测图片数据类型
    public var imageType: SwiftImageDataType {
        // 确保数据长度足够进行检测
        guard base.count >= 8 else { return .unknown }
        
        // 提取前8字节进行格式识别
        var header = [UInt8](repeating: 0, count: 8)
        base.getBytes(&header, length: 8)
           
        
        // PNG检测 (8字节完整签名)
        if header.starts(with: pngHeader) {
            return .png
        }
        // JPEG检测 (前2字节为FF D8)
        else if header[0] == jpgHeaderSOI[0] && header[1] == jpgHeaderSOI[1] {
            return .jpeg
        }
        // GIF检测 (前3字节为'GIF')
        else if header[0] == gifHeader[0] &&
                header[1] == gifHeader[1] &&
                header[2] == gifHeader[2] {
            return .gif
        }
        
        return .unknown
    }
}
