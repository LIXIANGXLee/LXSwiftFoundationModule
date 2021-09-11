//
//  LXSwift+AlertController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/30.
//

import UIKit

public extension LXSwiftBasics where Base: UIAlertController {

    /// 便捷添加Action
    @discardableResult
    func addAction(with title: String, style: UIAlertAction.Style = .`default`, handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        base.addAction(action)
        return base
    }
    
    /// 显示一段文本，一段描述，一个按钮
    static func show(title: String?, msg: String?, actionTitle: String = "确定", handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        show(title: title, msg: msg, style: .alert, actions: action)
    }

    /// 先是一段文本，一段时间后消失
    static func show(_ msg: String, duration: TimeInterval = 1.5) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        UIApplication.lx.visibleViewController?.present(alertController, animated: true, completion: nil)
        DispatchQueue.lx.delay(with: duration) { alertController.dismiss(animated: true, completion: nil) }
    }
    
    /// 显示title 、文本 、按钮
    static func show(title: String?, msg: String?, style: UIAlertController.Style = .alert, actions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
        actions.forEach { (action) in alertController.addAction(action) }
        UIApplication.lx.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
