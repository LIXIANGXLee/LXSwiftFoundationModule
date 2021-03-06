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
 
    ///抓拍长图片，可以抓拍图片进行滚动查看 截取长图
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.snapShotContentScroll { (image) in
            callBack(image)
        }
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

//MARK: -  internal
extension UIScrollView {
    
    /// get contentScroll long image for ScrollView
    func snapShotContentScroll(_ completionHandler:
                                            @escaping (_ screenShotImage: UIImage?)
                                            -> Void) {
        
        /// Put a fake Cover of View
        let snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y,
                                     width: (snapShotView?.frame.size.width)!,
                                     height: (snapShotView?.frame.size.height)!)
        self.superview?.addSubview(snapShotView!)
        
        ///  originOffset of base
        let originOffset = self.contentOffset
        /// Divide page
        let page  = floorf(Float(self.contentSize.height / self.bounds.height))
        
        /// Turn on the bitmap context size to the size of the screenshot
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)
        
        ///This method is a drawing, and there may be recursive calls inside
        self.snapShotContentScrollPage(index: 0,
                                       maxIndex: Int(page),
                                       callback: { [weak self] () -> Void in
            let strongSelf = self
            
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            /// set origin offset
            strongSelf?.setContentOffset(originOffset, animated: false)
            snapShotView?.removeFromSuperview()
            
            /// callBack image when get snapShotContentScroll
            completionHandler(screenShotImage)
        })
        
    }
    
    /// Draw according to offset and number of pages
    ///This method is a drawing, and there may be recursive calls inside
    func snapShotContentScrollPage(index: Int,
                                            maxIndex: Int,
                                            callback: @escaping () -> Void) {
        
        self.setContentOffset(CGPoint(x: 0,
                                      y: CGFloat(index) * self.frame.size.height),
                              animated: false)
        let splitFrame = CGRect(x: 0,
                                y: CGFloat(index) * self.frame.size.height,
                                width: bounds.size.width,
                                height: bounds.size.height)
       DispatchQueue.main.lx.delay(Double(Int64(0.3*Double(NSEC_PER_SEC)))/Double(NSEC_PER_SEC)) {
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.snapShotContentScrollPage(index: index + 1,
                                               maxIndex: maxIndex,
                                               callback: callback)
            }else{
                callback()
            }
        }
    }
}
