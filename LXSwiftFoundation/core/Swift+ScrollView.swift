//
//  Swift+ScrollView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

// MARK: - UIScrollView 扩展属性
extension SwiftBasics where Base: UIScrollView {
 
    /// 截取滚动视图的全部内容（长截图）
    /// - Parameter callBack: 截图完成后的回调，返回生成的UIImage对象
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.snapShotContentScroll { image in
            callBack(image)
        }
    }
}

// MARK: - UIScrollView 扩展方法
extension SwiftBasics where Base: UIScrollView {
    
    /// 滚动到内容顶部
    /// - Parameter animated: 是否使用动画效果，默认为true
    public func scrollToTop(animated: Bool = true) {
        var off = base.contentOffset
        off.y = -base.contentInset.top  // 考虑内边距
        base.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到内容底部
    /// - Parameter animated: 是否使用动画效果，默认为true
    public func scrollToBottom(animated: Bool = true) {
        var off = base.contentOffset
        off.y = base.contentSize.height - base.bounds.height + base.contentInset.bottom
        base.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到内容最左侧
    /// - Parameter animated: 是否使用动画效果，默认为true
    public func scrollToLeft(animated: Bool = true) {
        var off = base.contentOffset
        off.x = -base.contentInset.left  // 考虑内边距
        base.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到内容最右侧
    /// - Parameter animated: 是否使用动画效果，默认为true
    public func scrollToRight(animated: Bool = true) {
        var off = base.contentOffset
        off.x = base.contentSize.width - base.bounds.width + base.contentInset.right
        base.setContentOffset(off, animated: animated)
    }
}

// MARK: - UIScrollView 内部扩展
extension UIScrollView {
    
    /// 截取滚动视图的全部内容（长截图）
    /// - Parameter completionHandler: 截图完成后的回调，返回生成的UIImage对象
    func snapShotContentScroll(_ completionHandler: @escaping (_ screenShotImage: UIImage?) -> Void) {
        
        // 1. 先获取当前视图的快照
        guard let snapShotView = self.snapshotView(afterScreenUpdates: true) else {
            completionHandler(nil)
            return
        }
        
        // 2. 将快照视图添加到父视图
        snapShotView.frame = CGRect(x: self.frame.origin.x,
                                   y: self.frame.origin.y,
                                   width: snapShotView.frame.size.width,
                                   height: snapShotView.frame.size.height)
        self.superview?.addSubview(snapShotView)
        
        // 3. 保存原始偏移量，后面恢复用
        let originOffset = self.contentOffset
        
        // 4. 计算需要截取的页数（按屏幕高度分页）
        let page = floorf(Float(self.contentSize.height / self.bounds.height))
        
        // 5. 创建与内容大小相同的位图上下文
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)
        
        // 6. 开始分页截图（递归方法）
        self.snapShotContentScrollPage(index: 0, maxIndex: Int(page), callback: { [weak self] in
            guard let strongSelf = self else { return }
            
            // 7. 从上下文中获取最终合成的图片
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 8. 恢复原始偏移量
            strongSelf.setContentOffset(originOffset, animated: false)
            
            // 9. 移除快照视图
            snapShotView.removeFromSuperview()
            
            // 10. 回调返回生成的图片
            completionHandler(screenShotImage)
        })
    }
    
    /// 分页截图方法（递归实现）
    /// - Parameters:
    ///   - index: 当前页码
    ///   - maxIndex: 最大页码
    ///   - callback: 所有页截图完成后的回调
    func snapShotContentScrollPage(index: Int, maxIndex: Int, callback: @escaping () -> Void) {
        // 1. 滚动到当前页的位置
        self.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * self.frame.size.height), animated: false)
        
        // 2. 定义当前页的绘制区域
        let splitFrame = CGRect(x: 0,
                                y: CGFloat(index) * self.frame.size.height,
                                width: bounds.size.width,
                                height: bounds.size.height)
        
        // 3. 延迟0.3秒确保滚动完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // 4. 将当前页的内容绘制到位图上下文中
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            
            // 5. 判断是否还有下一页需要截图
            if index < maxIndex {
                // 递归调用，处理下一页
                self.snapShotContentScrollPage(index: index + 1, maxIndex: maxIndex, callback: callback)
            } else {
                // 所有页截图完成，执行回调
                callback()
            }
        }
    }
}
