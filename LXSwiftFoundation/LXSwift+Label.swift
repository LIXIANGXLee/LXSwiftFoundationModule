//
//  LXSwift+Label.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UILabel
extension LXSwiftBasics where Base: UILabel {
   /// w
    public var bestWidth: CGFloat {
        return base.sizeThatFits(CGSize.zero).width
    }
   
    /// h
    public var bestHeight: CGFloat {
       return base.sizeThatFits(CGSize.zero).height
    }
}
