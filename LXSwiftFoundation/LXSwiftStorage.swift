//
//  LXSwiftStorage.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/2/8.
//

import UIKit

public struct  LXSwiftStorage: LXSwiftCompatible { }

/// 扩展存储 并且加密
extension LXSwiftBasics where Base == LXSwiftStorage {

    /// 存储
    public static func setStorage(with value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    ///取值
    public static func getStorage(for key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
