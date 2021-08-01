//
//  LXSwift+Int.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/25.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit


/// 自定义运算符
prefix operator ~>  /// 小于
prefix operator ~<  /// 大于
prefix operator ~>= /// 小于等于
prefix operator ~<= /// 大于等于

public prefix func ~> (_ index: Int) -> (Int) -> (Bool) { { $0 > index } }
public prefix func ~>= (_ index: Int) -> (Int) -> (Bool) { { $0 >= index } }
public prefix func ~< (_ index: Int) -> (Int) -> (Bool) { { $0 < index } }
public prefix func ~<= (_ index: Int) -> (Int) -> (Bool) { { $0 <= index } }

extension Int: LXSwiftCompatible {
    
    /// Switch 匹配模式
    public static func ~= (pattern: (Int) -> (Bool), value: Int) -> Bool {
         pattern(value)
    }
}

//MARK: -  Extending methods for Int
extension LXSwiftBasics where Base == Int {
    
    ///  生成区间的随机数
   public static func randomInt(lower: Int = 0,
                          upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    /// 生成区间的随机数
    public static func randomInt(with range: Range<Int>) -> Int {
        return randomInt(lower: range.lowerBound, upper: range.upperBound)
    }
    
    /// 转换为字符串格式
    public var intToStr: String {
        return String(base)
    }
    
    /// int 转 bool
    public var intToBool: Bool {
        return base > 0 ? true : false
    }
    
    /// 用户显示容量 (G、M、KB)
    public var sizeFileToStr: String {
       return Double(base).lx.sizeFileToStr
    }
    
    /// 时间（秒数）转换字符串
    public var timeToStr: String {
        return Double(base).lx.timeToStr
    }
}
