//
//  LXSwift+Array.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

import UIKit

extension Array: LXSwiftCompatible { }
extension LXSwiftBasics where Base == Array<Any> {
   
    /// 数组转成json
    public var arrToJsonStr: String? {
        guard JSONSerialization.isValidJSONObject(base) else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: []), let json = String(data: jsonData, encoding: .utf8) else { return nil }
        return json
    }
}
