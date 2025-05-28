//
//  Swift+AlertController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/30.
//

import UIKit

public extension SwiftBasics where Base: UIAlertController {

    /// 便捷添加 Action 到 UIAlertController
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - style: 按钮样式，默认为 .default
    ///   - handle: 按钮点击回调
    /// - Returns: 返回 UIAlertController 实例，支持链式调用
    @discardableResult
    func addAction(with title: String,
                   style: UIAlertAction.Style = .`default`,
                   handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        base.addAction(action)
        return base
    }
    
    /// 显示标准弹窗 - 包含标题、消息和一个确定按钮
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - msg: 弹窗消息内容
    ///   - actionTitle: 按钮标题，默认为"确定"
    ///   - handler: 按钮点击回调
    static func show(title: String?,
                     msg: String?,
                     actionTitle: String = "确定",
                     handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        show(title: title, msg: msg, style: .alert, actions: action)
    }

    /// 显示自动消失的提示弹窗
    /// - Parameters:
    ///   - msg: 要显示的消息内容
    ///   - duration: 自动消失的时间间隔，默认为1.5秒
    static func show(_ msg: String, duration: TimeInterval = 1.5) {
        // 创建只有消息的弹窗
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        // 获取当前视图控制器并显示弹窗
        UIApplication.lx.currentViewController?.present(alertController, animated: true, completion: nil)
        
        // 延迟指定时间后自动消失
        DispatchQueue.lx.delay(with: duration) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 显示自定义弹窗（支持多个按钮）
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - msg: 弹窗消息内容
    ///   - style: 弹窗样式，默认为 .alert
    ///   - actions: 可变参数的 UIAlertAction 数组
    static func show(title: String?,
                     msg: String?,
                     style: UIAlertController.Style = .alert,
                     actions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
        
        // 添加所有传入的 Action
        actions.forEach { alertController.addAction($0) }
        
        // 获取当前视图控制器并显示弹窗
        UIApplication.lx.currentViewController?.present(alertController, animated: true, completion: nil)
    }
}
