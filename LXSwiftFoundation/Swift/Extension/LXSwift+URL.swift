//
//  LXSwift+URL.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

import UIKit

extension URL: LXSwiftCompatible { }

extension LXSwiftBasics where Base == URL {
    
    /// 根据url获取视频的size
    public var videoSize: CGSize? { LXSwiftUtils.videoSize(with: base) }
    
    /// 取出Get请求中的参数，结果是一个大字典
    public var urlParams1: [String: String] {
        let components = NSURLComponents(url: base, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        return queryItems.reduce([String: String]()) {
            var dict = $0
            dict[$1.name] = $1.value ?? ""
            return dict
        }
    }
    
    /// 从URL String 中获取参数，并将参数转为字典类型
    public var urlParams2: [String: String] {
        let string = base.absoluteString
        var params: [String: String] = [:]
        let array = string.components(separatedBy: "?")
        if array.count == 2 {
            let paramsStr = array[1]
            if paramsStr.count > 0 {
                let paramsArray = paramsStr.components(separatedBy: "&")
                paramsArray.forEach { (param) in
                    let arr = param.components(separatedBy: "=")
                    if arr.count == 2 { params[arr[0]] = arr[1] }
                }
            }
        }
        return params
    }
    
    ///  按照原顺序 取出Get请求中的参数，结果是一个数组，每个元素是一个字典
    public var urlParamsWithOrder: [[String: String]] {
        var queries = [[String: String]]()
        guard let query = base.query else { return queries }
        let andChar = CharacterSet(charactersIn: "&")
        let queryComponents = query.components(separatedBy: andChar)
        let equalChar = CharacterSet(charactersIn: "=")
        for component in queryComponents {
            let items = component.components(separatedBy: equalChar)
            guard items.count == 2 else { continue }
            guard let firstItem = items.first, let lastItem = items.last else { continue }
            let queryPair = [firstItem: lastItem]
            queries.append(queryPair)
        }
        return queries
    }
}
