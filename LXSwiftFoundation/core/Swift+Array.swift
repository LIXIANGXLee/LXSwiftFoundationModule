//
//  Swift+Array.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

import UIKit

extension SwiftBasics where Base == Array<Any> {
   
    /// 数组转成json
    public var toJsonString: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            LXXXLog("无法解析数据。。。")
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: []) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}
