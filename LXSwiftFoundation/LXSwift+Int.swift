//
//  LXSwift+Int.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


/// Custom operators greater
/// than or equal to,
/// greater than,
/// less than or equal to,
/// less than
prefix operator ~>
prefix operator ~<
prefix operator ~>=
prefix operator ~<=

public prefix func ~> (_ index: Int) -> (Int) -> (Bool) { { $0 > index } }
public prefix func ~>= (_ index: Int) -> (Int) -> (Bool) { { $0 >= index } }
public prefix func ~< (_ index: Int) -> (Int) -> (Bool) { { $0 < index } }
public prefix func ~<= (_ index: Int) -> (Int) -> (Bool) { { $0 <= index } }

extension Int: LXSwiftCompatible {
    
    /// Switch 匹配模式
    /// - than or equal to,
    /// - greater than,
    /// - less than or equal to,
    /// - less than
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
    public static func randomInt(range: Range<Int>) -> Int {
        return randomInt(lower: range.lowerBound, upper: range.upperBound)
    }
    
    /// 转换为字符串格式
    public var intToStr: String {
        return String(base)
    }
    
    /// Convert bool
    public var intToBool: Bool {
        return base > 0 ? true : false
    }
    
    /// User display capacity size size
    public var sizeFileToStr: String {
       return Double(base).lx.sizeFileToStr
    }
    
    /// timer string
    public var timeToStr: String {
        return Double(base).lx.timeToStr
    }
}
