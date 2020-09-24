//
//  LXSwiftTool.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftTool: LXCompatible { }

//MARK: -  Extending methods for Date

extension LXSwiftBasics where Base == LXSwiftTool {
    
    ///  from path to read plist tranform Dictionary
    ///
    /// - Parameter data: path
    /// - Returns: Dictionary
    public static func readDictionary(with path: String?) -> Dictionary<String, Any>? {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        return LXSwiftTool.lx.getDictionary(with: data)
    }
    
    
    ///  string tranform Dictionary
    ///
    /// - Parameter data: string
    /// - Returns: Dictionary
    public static func getDictionary( with string: String?) -> Dictionary<String, Any>?  {
        let data = string?.data(using: .utf8)
        return LXSwiftTool.lx.getDictionary(with: data)
    }
    
    
    ///  data tranform Dictionary
    ///
    /// - Parameter data: data
    /// - Returns: Dictionary
    public static func getDictionary(with data: Data?) -> Dictionary<String, Any>? {
        guard let data = data,
            let propertyList = try? PropertyListSerialization.propertyList(from: data, options: .init(rawValue: 0), format: nil) else { return nil }
        return propertyList as? Dictionary<String, Any>
    }
    
    /// call tel
       public static func openTel(with number: String?) {
           guard let number = number,
               let url = URL(string: "tel:" + number) else{ return }
           if UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
       }
}
