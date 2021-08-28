//
//  LXSwiftStorage.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/2/8.
//

import UIKit


/*
 字符串简单用法
 LXSwiftStorage.setStorage("sasasa", key: "ss")
 let m = LXSwiftStorage<String>.getStorage(for: "ss")
  */



/*
 模型用法
 class Model: Codable {
     var aa: String = "fd"
     var dd: Int = 0
 }

 let model = Model()
 LXSwiftStorage.setStorage("model", key: "ss")
 
 let m = LXSwiftStorage<Model>.getStorage(for: "ss")
*/

public struct  LXSwiftStorage<T: Codable>: LXSwiftCompatible {
   
    /// 数据编码后存储
    public static func set(_ value: T, key: String) where T: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            setStorage(with: data, key: key)
        }
    }
    
    /// 数据取出后解码
    public static func get(for key: String) -> T? where T: Decodable {
        guard let data = getStorage(for: key) as? Data else { return nil }
        let decodeValue = try? JSONDecoder().decode(T.self, from: data)
        return decodeValue
    }
    
    /// 正常存储
    internal static func setStorage(with value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// 正常取值
    internal static func getStorage(for key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
}
