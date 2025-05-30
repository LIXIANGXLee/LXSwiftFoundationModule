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
    
    /// 将Base64编码字符串解码为UIImage对象
    public var base64DecodingImage: UIImage? {
        // 1. 解码Base64字符串 -> 二进制数据
        // 使用.ignoreUnknownCharacters选项增强容错性：忽略空格、换行等无效字符
        guard let base64Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) else {
            // 解码失败：Base64字符串格式非法或包含大量无效字符
            return nil
        }
        
        // 2. 将二进制数据转换为UIImage
        // 注意：此方法可能因以下原因返回nil：
        //   - 数据不是有效的图像格式（如JPEG/PNG损坏）
        //   - 内存不足导致图像初始化失败
        //   - 数据为空或字节数不足
        return UIImage(data: base64Data)
    }
    
    // 使用属性列表序列化将Data对象解析为Plist数据结构
    public var dataToPlistDictionary: [String: Any]? {
        do {
            // PropertyListSerialization.propertyList方法参数说明：
            // - from: 包含属性列表数据的Data对象
            // - options: 解析选项（空数组表示默认行为）
            // - format: 接收解析出的格式（nil表示不关心格式）
            let plist = try PropertyListSerialization.propertyList(
                from: base,       // 待解析的原始数据
                options: [],      // 使用默认解析选项
                format: nil       // 不获取原始数据格式
            )
            
            // 将解析结果尝试转换为[String: Any]字典类型
            // 因为属性列表顶层通常是字典，但也可以是数组或其他类型
            // 转换失败时返回nil（表示顶层结构不是字典）
            return plist as? [String: Any]
            
        } catch {
            // 错误处理：捕获解析过程中可能发生的所有异常
            // 常见的错误类型包括：
            // 1. 数据格式无效（非Plist格式）
            // 2. 数据类型不支持（包含非法对象）
            // 3. 数据损坏或截断
            // 4. 内存不足（大型文件处理时）
            SwiftLog.log("Plist解析错误: \(error.localizedDescription)")
            
            // 解析失败时返回nil，表示无法获取有效字典
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
