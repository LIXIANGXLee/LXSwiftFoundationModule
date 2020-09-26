//
//  LXSwift+ScrollView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UIScrollView
extension LXSwiftBasics where Base: UIScrollView {
    
    
    /// interception UIScrollView long image
   public var snapshotLongImage: UIImage? {
       var image: UIImage? = nil
       
       //save origin contentOfffSet 和 frame
       let savedContentOffset = base.contentOffset
       let savedFrame = base.frame
       
       base.contentOffset = .zero
       base.frame = CGRect(x: 0, y: 0,width: base.contentSize.width,height: base.contentSize.height)
       UIGraphicsBeginImageContextWithOptions(base.frame.size,false,0)
       guard let context = UIGraphicsGetCurrentContext() else {
           return nil
       }
       
       base.layer.render(in: context)
       image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       base.contentOffset = savedContentOffset
       base.frame = savedFrame
       return image
   }
}

//MARK: -  Extending methods for UIScrollView
extension LXSwiftBasics where Base: UIScrollView {
    ///  Scroll content to top
       public func scrollToTop(animated: Bool = true) {
           var off = base.contentOffset
           off.y = 0 - base.contentInset.top
           base.setContentOffset(off, animated: animated)
       }
       
       /// Scroll content to bottom
       public func scrollToBottom(animated: Bool = true) {
           var off = base.contentOffset
           off.y = base.contentSize.height - base.bounds.height + base.contentInset.bottom
           base.setContentOffset(off, animated: animated)
       }
       
       /// Scroll content to left
       public func scrollToLeft(animated: Bool = true) {
           var off = base.contentOffset
           off.x = 0 - base.contentInset.left
           base.setContentOffset(off, animated: animated)
       }
       
       /// Scroll content to right
       public func scrollToRight(animated: Bool = true) {
           var off = base.contentOffset
           off.x = base.contentSize.width - base.bounds.width + base.contentInset.right
           base.setContentOffset(off, animated: animated)
       }
    
}
