//
//  Swift+URL.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

import UIKit

extension SwiftBasics where Base == URL {
    
    // MARK: - 视频相关
    
    /// 获取URL指向视频的尺寸
    /// - 返回值: 视频尺寸CGSize，如果无法获取则返回nil
    public var videoSize: CGSize? {
        SwiftUtils.videoSize(with: base)
    }
   
    // MARK: - URL参数处理
    
    /// 解析URL中的查询参数(使用NSURLComponents方式)
    /// - 返回值: 参数字典，格式为 [参数名: 参数值]
    /// - 说明: 此方法会自动处理URL编码，参数值会保留原始URL中的编码状态
    public var urlParams1: [String: String] {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value ?? ""
        }
    }
    
    /// 解析URL中的查询参数(字符串分割方式)
    /// - 返回值: 参数字典，格式为 [参数名: 参数值]
    /// - 注意: 此方法不会自动处理URL编码，参数值会保留原始URL中的编码状态
    public var urlParams2: [String: String] {
        let urlString = base.absoluteString
        guard let queryStartIndex = urlString.firstIndex(of: "?") else {
            return [:]
        }
        
        let queryString = String(urlString[urlString.index(after: queryStartIndex)...])
        var params = [String: String]()
        
        queryString.components(separatedBy: "&").forEach { paramPair in
            let components = paramPair.components(separatedBy: "=")
            guard components.count == 2 else { return }
            params[components[0]] = components[1]
        }
        
        return params
    }
    
    /// 按照原始顺序解析URL中的查询参数
    /// - 返回值: 参数数组，每个元素是一个字典，格式为 [参数名: 参数值]
    /// - 说明: 保持参数在URL中出现的原始顺序，适用于需要顺序敏感的场景
    public var urlParamsWithOrder: [[String: String]] {
        guard let query = base.query, !query.isEmpty else {
            return []
        }
        
        return query.components(separatedBy: "&").compactMap { paramPair in
            let components = paramPair.components(separatedBy: "=")
            guard components.count == 2 else { return nil }
            return [components[0]: components[1]]
        }
    }
}
