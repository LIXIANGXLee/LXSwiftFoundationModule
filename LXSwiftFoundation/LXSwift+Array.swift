//
//  LXSwift+Array.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

import UIKit
extension Array: LXSwiftCompatible { }

extension LXSwiftBasics where Base == Array<Any> {
   
    /// 数组转成json
    public var arrToJsonStr: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base,
                                                         options: []),
            let json = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return json
    }
}
