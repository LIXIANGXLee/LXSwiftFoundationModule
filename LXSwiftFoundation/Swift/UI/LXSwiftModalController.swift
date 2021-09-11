//
//  LXModalController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - public
open class LXSwiftModalController: UIViewController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(contentView)
        view.addGestureRecognizer(tapGesture)
        contentView.addGestureRecognizer(contentGesture)
    }
    
    /// 内容视图操作单击
    open lazy var contentGesture: UITapGestureRecognizer = { UITapGestureRecognizer(target: self, action: #selector(contentViewTaped(tap:))) }()
    
    /// allscreen UITapGestureRecognizer
    open lazy var tapGesture: UITapGestureRecognizer = { UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap)) }()
    
    /// 内容视图 注意：⚠️子类继承后需要设置尺寸后才能显示出来
    open lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    
    /// 关闭当前窗口
    open func dismiss() { lx.dismissViewController() }
    
}

// MARK: - public
extension LXSwiftModalController {
    
    /// 背景点击回调
    @objc open func backgroundViewTap() { }
    
    /// 内容视图点击对调
    @objc open func contentViewTaped(tap: UITapGestureRecognizer) { }
    
}
