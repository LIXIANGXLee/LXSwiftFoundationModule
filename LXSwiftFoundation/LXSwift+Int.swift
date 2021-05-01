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

public prefix func ~>  (_ index: Int) -> (Int) -> (Bool) { { $0 > index } }
public prefix func ~>= (_ index: Int) -> (Int) -> (Bool) { { $0 >= index } }
public prefix func ~<  (_ index: Int) -> (Int) -> (Bool) { { $0 < index } }
public prefix func ~<= (_ index: Int) -> (Int) -> (Bool) { { $0 <= index } }

extension Int: LXSwiftCompatible {
    
    /// Switch de matching pattern, matching
    /// than or equal to,
    /// greater than,
    /// less than or equal to,
    /// less than
    public static func ~= (pattern: (Int) -> (Bool), value: Int) -> Bool {
         pattern(value)
    }
}

//MARK: -  Extending methods for Int
extension LXSwiftBasics where Base == Int {
    
    ///  Generating a random number of an interval
    static func randomInt(lower: Int = 0,
                          upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    ///  Generating a random number of an interval
    static func randomInt(range: Range<Int>) -> Int {
        return randomInt(lower: range.lowerBound, upper: range.upperBound)
    }
}
