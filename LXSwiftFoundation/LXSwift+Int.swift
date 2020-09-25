//
//  LXSwift+Int.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


extension Int: LXSwiftCompatible { }

//MARK: -  Extending methods for Int
extension LXSwiftBasics where Base == Int {
 
   ///  Generating a random number of an interval
   static func randomInt(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
       return lower + Int(arc4random_uniform(UInt32(upper - lower)))
   }
   
   ///  Generating a random number of an interval
   static func randomInt(range: Range<Int>) -> Int {
       return randomInt(lower: range.lowerBound, upper: range.upperBound)
   }
}
