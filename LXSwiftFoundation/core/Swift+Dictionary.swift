//
//  Swift+Dictionary.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for Date
extension SwiftBasics where Base == Dictionary<String, Any> {
    
    /// 将字典转换为格式化的JSON字符串
    public var toJsonString: String? {
        // 1. 验证基础对象是否符合JSON格式要求
        // 注意: 需要确保base是有效的JSON对象(NSArray/NSDictionary)
        guard JSONSerialization.isValidJSONObject(base) else {
            SwiftLog.log("无效的JSON对象，无法序列化。输入类型：\(type(of: base))")
            return nil
        }
        
        // 2. 尝试将对象序列化为JSON数据
        let jsonData: Data
        do {
            // 使用紧凑格式进行序列化（如需美化输出可添加.prettyPrinted选项）
            if #available(iOS 11.0, *) {
                jsonData = try JSONSerialization.data(withJSONObject: base, options: [.sortedKeys])
            } else {
                jsonData = try JSONSerialization.data(withJSONObject: base, options: [])
            }
        } catch {
            // 捕获并记录序列化错误细节
            SwiftLog.log("JSON序列化失败：\(error.localizedDescription)")
            return nil
        }
        
        // 3. 将二进制数据转换为UTF8字符串
        // 注意：使用.withoutLossyConversion选项可防止字符丢失，但返回类型会变为String?
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            SwiftLog.log("UTF-8字符串转换失败，数据长度：\(jsonData.count)")
            return nil
        }
        
        return jsonString
    }
}
