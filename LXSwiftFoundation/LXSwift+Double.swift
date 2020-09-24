//
//  LXSwift+Double.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Double: LXSwiftCompatible { }

//MARK: -  Extending methods for Double
extension LXSwiftBasics where Base == Double {
    
    /// Keep decimal places after decimal points
    /// - Parameters:
    ///   - places: How many decimal places
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (base * divisor).rounded() / divisor
    }
}
