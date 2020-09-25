//
//  LXSwift+Button.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


//MARK: -  Extending properties for UIButton
extension LXSwiftBasics where Base: UIButton {
    
    /// w
    public var bestWidth: CGFloat {
        return base.sizeThatFits(CGSize.zero).width
      }
}
