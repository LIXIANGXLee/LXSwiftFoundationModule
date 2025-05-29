//
//  Swift+URL.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

import UIKit
import AVFoundation

extension SwiftBasics where Base == URL {
    
    // MARK: - 视频相关方法
    
    /// 获取URL指向视频的尺寸（同步方法）
    /// - 返回值: 视频尺寸CGSize，如果无法获取则返回nil
    /// - 注意:
    ///   1. 此方法会阻塞当前线程，建议在后台线程调用
    ///   2. 支持本地文件URL和远程网络URL
    ///   3. 对于网络资源会触发临时下载（不缓存完整文件）
    public var videoSize: CGSize? {
        SwiftUtils.videoSize(with: base)
    }
    
    // MARK: - URL参数解析方法
    
    /// 解析URL中的查询参数（推荐方式）
    /// - 返回值: 参数字典 [参数名: 参数值]
    /// - 特性:
    ///   1. 使用Apple官方URLComponents组件解析
    ///   2. 自动处理URL编码（保留原始编码状态）
    ///   3. 支持多值参数（最后出现的值生效）
    ///   4. 空值参数会转换为空字符串
    public var urlParametersParsing: [String: String] {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              !queryItems.isEmpty else {
            return [:]
        }
        
        // 使用reduce构建参数字典
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            // 保留原始值（包括URL编码字符）
            result[item.name] = item.value ?? ""
        }
    }
    
    /// 解析URL中的查询参数（高性能方式）
    /// - 返回值: 参数字典 [参数名: 参数值]
    /// - 注意:
    ///   1. 适用于已知参数格式简单的场景
    ///   2. 不会自动解码URL编码值（保留原始编码状态）
    ///   3. 参数值包含等号时只分割第一个等号
    public var urlParametersHighParsing: [String: String] {
        // 获取完整的URL字符串
        let urlString = base.absoluteString
        
        // 定位查询参数起始位置
        guard let queryStart = urlString.firstIndex(of: "?") else {
            return [:]
        }
        
        // 提取查询参数字符串（排除问号）
        let queryString = String(urlString[urlString.index(after: queryStart)...])
        guard !queryString.isEmpty else { return [:] }
        
        var params = [String: String]()
        
        // 分割参数对
        for paramPair in queryString.split(separator: "&") {
            // 只分割第一个等号（处理值中含等号的情况）
            let parts = paramPair.split(separator: "=", maxSplits: 1)
            
            guard parts.count >= 2 else { continue }
            
            // 保留原始编码值
            let key = String(parts[0])
            let value = String(parts[1])
            
            // 相同参数名时覆盖之前的值
            params[key] = value
        }
        
        return params
    }
    
    /// 按照原始顺序解析URL中的查询参数
    /// - 返回值: 有序参数数组，元素为[key: value]字典
    /// - 特性:
    ///   1. 保持参数在URL中的出现顺序
    ///   2. 支持需要顺序敏感的场景（如签名验证）
    ///   3. 每个字典项只包含一个键值对
    public var urlParametersSortParsing: [[String: String]] {
        guard let query = base.query, !query.isEmpty else {
            return []
        }
        
        return query.split(separator: "&").compactMap { paramPair in
            // 分割键值对（最多分割一次）
            let parts = paramPair.split(separator: "=", maxSplits: 1)
            guard parts.count == 2 else { return nil }
            
            let key = String(parts[0])
            let value = String(parts[1])
            
            return [key: value]
        }
    }
    
    // MARK: - 新增实用方法
    
    /// 添加查询参数并生成新URL
    /// - 参数 params: 要添加的参数字典
    /// - 返回值: 包含新参数的新URL实例
    public func appendingQueryParameters(_ params: [String: String]) -> URL? {
        guard var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        // 获取现有查询项
        var queryItems = components.queryItems ?? []
        
        // 添加新参数
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems
        return components.url
    }
}
