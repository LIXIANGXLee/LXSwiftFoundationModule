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
    public func withBold() -> UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitBold) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withItalic
    public func withItalic() -> UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withBoldItalic
    public func withBoldItalic() -> UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([.traitBold,
                                                                 .traitItalic]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    /// withNormal
    public func withNormal() -> UIFont {
        guard let desc = base.fontDescriptor.withSymbolicTraits([]) else {
            return base
        }
        return UIFont(descriptor: desc, size: base.pointSize)
    }
    
    public static func systemFontWithMedium(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .medium)
    }
    
    public static func systemFontWithRegular(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .regular)
    }
    
    public static func systemFontWithBold(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
    public static func systemFontWithSemibold(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .semibold)
    }
    
    public static func systemFontWithHeavy(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .heavy)
    }
    
    public static func systemFontWithLight(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .light)
    }
    
    public static func systemFontWithBlack(ofSize: CGFloat) -> UIFont {
       return UIFont.systemFont(ofSize: ofSize, weight: .black)
    }
    
}
