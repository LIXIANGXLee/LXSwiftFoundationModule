//
//  Swift+AlertController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/30.
//

import UIKit

// MARK: - 关联对象键（使用静态结构体安全封装）
private struct AssociatedKeys {
    static var tapGestureHandler: UInt8 = 0
    static var tapGesture: UInt8 = 0
}

extension SwiftBasics where Base: UIView {
    
    // MARK: - 公开接口
    
    /// 添加点击手势回调
    /// - Parameters:
    ///   - handler: 点击事件回调闭包（接收手势对象）
    ///   - numberOfTaps: 需要点击的次数（默认为1，表示单击）
    ///   - numberOfTouches: 需要的手指数量（默认为1，表示单指点击）
    /// - Note: 多次调用会移除之前添加的手势和回调
    public func addTapGesture(
        closure: @escaping (UITapGestureRecognizer) -> Void,
        numberOfTaps: Int = 1,
        numberOfTouches: Int = 1
    ) {
        // 确保视图可交互
        base.isUserInteractionEnabled = true
        
        // 移除现有的点击手势（避免重复添加）
        removeTapGesture()
            
        // 创建点击手势
        let tapGesture = UITapGestureRecognizer(
            target: base,
            action: #selector(base.handleTapGesture(_:)))
        
        // 配置手势参数
        tapGesture.numberOfTapsRequired = numberOfTaps
        tapGesture.numberOfTouchesRequired = numberOfTouches
        tapGesture.cancelsTouchesInView = false // 允许事件继续传递
        
        // 添加手势到视图
        base.addGestureRecognizer(tapGesture)
        
        // 使用关联对象存储闭包
        objc_setAssociatedObject(
            base,
            &AssociatedKeys.tapGestureHandler,
            closure,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        // 存储手势引用（用于后续操作）
        objc_setAssociatedObject(
            base,
            &AssociatedKeys.tapGesture,
            tapGesture,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// 移除当前视图上的点击手势和回调
    public func removeTapGesture() {
        // 获取关联的手势对象并移除
        if let gesture = objc_getAssociatedObject(base, &AssociatedKeys.tapGesture) as? UITapGestureRecognizer {
            base.removeGestureRecognizer(gesture)
        }
        
        // 清除关联对象
        objc_setAssociatedObject(base, &AssociatedKeys.tapGestureHandler, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(base, &AssociatedKeys.tapGesture, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIView {
    // MARK: - 手势响应处理
    
    /// 处理点击手势事件（私有方法）
    @objc fileprivate func handleTapGesture(_ sender: UITapGestureRecognizer) {
        // 从关联对象中获取闭包并执行，传递手势对象
        if let handler = objc_getAssociatedObject(self, &AssociatedKeys.tapGestureHandler) as? (UITapGestureRecognizer) -> Void {
            handler(sender)
        }
    }
}
