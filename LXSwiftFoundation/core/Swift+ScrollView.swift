//
//  Swift+ScrollView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UIScrollView
extension SwiftBasics where Base: UIScrollView {
 
    /// 抓拍长图片，可以抓拍图片进行滚动查看 截取长图
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.snapShotContentScroll { (image) in
            callBack(image)
        }
    }
}

//MARK: -  Extending methods for UIScrollView
extension SwiftBasics where Base: UIScrollView {
    
    /// 将内容滚动到顶部
    public func scrollToTop(animated: Bool = true) {
        var off = base.contentOffset
        off.y = -base.contentInset.top
        base.setContentOffset(off, animated: animated)
    }
    
    /// 将内容滚动到底部
    public func scrollToBottom(animated: Bool = true) {
        var off = base.contentOffset
        off.y = base.contentSize.height - base.bounds.height + base.contentInset.bottom
        base.setContentOffset(off, animated: animated)
    }
    
    /// 向左滚动内容
    public func scrollToLeft(animated: Bool = true) {
        var off = base.contentOffset
        off.x = -base.contentInset.left
        base.setContentOffset(off, animated: animated)
    }
    
    /// 向右滚动内容
    public func scrollToRight(animated: Bool = true) {
        var off = base.contentOffset
        off.x = base.contentSize.width - base.bounds.width + base.contentInset.right
        base.setContentOffset(off, animated: animated)
    }
}

//MARK: -  internal
extension UIScrollView {
    
    /// 获取ScrollView的contentScroll长图像
    func snapShotContentScroll(_ completionHandler: @escaping (_ screenShotImage: UIImage?)  -> Void) {
        
        guard let snapShotView = self.snapshotView(afterScreenUpdates: true) else { return }
        snapShotView.frame = CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y,
                                     width: snapShotView.frame.size.width,
                                     height: snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        let originOffset = self.contentOffset
        let page = floorf(Float(self.contentSize.height / self.bounds.height))
        
        /// 将位图上下文大小启用为屏幕截图的大小
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)
        /// 此方法是一个图形，其中可能有递归调用
        self.snapShotContentScrollPage(index: 0,  maxIndex: Int(page), callback: { [weak self] () -> Void in
            let strongSelf = self
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            /// 设置原点偏移
            strongSelf?.setContentOffset(originOffset, animated: false)
            snapShotView.removeFromSuperview()
            
            /// 取snapShotContentScroll时的回调图像
            completionHandler(screenShotImage)
        })
    }
    
    /// 根据偏移量和页数绘制，此方法是一个图形，其中可能有递归调用
    func snapShotContentScrollPage(index: Int, maxIndex: Int, callback: @escaping () -> Void) {
        
        self.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * self.frame.size.height), animated: false)
        let splitFrame = CGRect(x: 0,
                                y: CGFloat(index) * self.frame.size.height,
                                width: bounds.size.width,
                                height: bounds.size.height)
        DispatchQueue.lx.delay(with: Double(Int64(0.3*Double(NSEC_PER_SEC)))/Double(NSEC_PER_SEC)) {
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.snapShotContentScrollPage(index: index + 1, maxIndex: maxIndex, callback: callback)
            } else {
                callback()
            }
        }
    }
}
