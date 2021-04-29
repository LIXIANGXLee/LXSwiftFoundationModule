//
//  LXSwift+URL.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

import UIKit

extension URL: LXSwiftCompatible { }

extension LXSwiftBasics where Base == URL {
    
    /// 取出Get请求中的参数，结果是一个大字典
   public func getParameters() -> [String: String] {
        let components = NSURLComponents(url: base, resolvingAgainstBaseURL: false)
        // 取出items，如果為nil就改為預設值 空陣列
        let queryItems = components?.queryItems ?? []
        return queryItems.reduce([String: String]()) {
            var dict = $0
            dict[$1.name] = $1.value ?? ""
            return dict
        }
    }

    ///  按照原顺序 取出Get请求中的参数，结果是一个大字典
    /// - Returns:结果是一个数组，每个元素是一个字典，（可以有序）
    public func getParametersWithOrder() -> [[String: String]] {
        var queries = [[String: String]]()
        guard let query = base.query else { return queries }

        let andChar = CharacterSet(charactersIn: "&")
        let queryComponents = query.components(separatedBy: andChar)
        let equalChar = CharacterSet(charactersIn: "=")
        for component in queryComponents {
            let items = component.components(separatedBy: equalChar)
            guard items.count == 2 else { continue }
            guard let firstItem = items.first,
                  let lastItem = items.last else { continue }
            let queryPair = [firstItem: lastItem]
            queries.append(queryPair)
        }
        return queries
    }
}
