//
//  LXSwift+Font.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIFont: LXSwiftCompatible { }

//MARK: -  Extending properties for UIFont
extension LXSwiftBasics where Base: UIFont {
   
    /// isBold
    public var isBold: Bool {
        return base.fontDescriptor.symbolicTraits == .traitBold
    }
    
    /// isItalic
    public var isItalic: Bool {
        return base.fontDescriptor.symbolicTraits == .traitItalic
    }
    
    /// isMonoSpace
    public var isMonoSpace: Bool {
        return base.fontDescriptor.symbolicTraits == .traitMonoSpace
    }
    
    /// withBold
    public var withBold: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withItalic
    public var withItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withBoldItalic
    public var withBoldItalic: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([.traitBold,
                                                                 .traitItalic]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withNormal
    public var withNormal: UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    public static func fontWithMedium(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    
    public static func fontWithRegular(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    
    public static func fontWithBold(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
    public static func fontWithSemibold(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .semibold)
    }
    
    public static func fontWithHeavy(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .heavy)
    }
    
    public static func fontWithLight(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .light)
    }
    
    public static func fontWithBlack(_ ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .black)
    }
    
}
