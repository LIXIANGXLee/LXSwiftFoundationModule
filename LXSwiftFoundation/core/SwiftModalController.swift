//
//  SwiftModalController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - 模态视图控制器
/// 自定义模态视图控制器，提供半透明背景和可点击关闭功能
/// 子类需自定义`contentView`的布局和内容
@objc(LXObjcModalController)
@objcMembers open class SwiftModalController: UIViewController {
    
    // MARK: - 初始化
    
    /// 使用指定方式初始化控制器
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupModalConfiguration()
    }
    
    /// 便捷初始化方法（推荐使用）
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) 不支持使用Storyboard初始化")
    }
    
    // MARK: - 视图生命周期
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureBaseUI()
        setupGestureRecognizers()
    }
    
    // MARK: - 公开属性
    
    /// 内容视图（子类需自定义布局）
    /// 注意：必须设置尺寸约束或frame才能正常显示
    open lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 背景点击手势（默认触发dismiss）
    open lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap))
        gesture.cancelsTouchesInView = false // 允许穿透点击
        return gesture
    }()
    
    /// 内容视图点击手势（默认无操作）
    open lazy var contentGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(contentViewTaped(tap:)))
    }()
    
    // MARK: - 公共方法
    
    /// 关闭模态窗口
    open func dismiss() {
        lx.dismissViewController()
    }
}

// MARK: - 配置方法
private extension SwiftModalController {
    
    /// 配置模态窗口基础参数
    func setupModalConfiguration() {
        modalTransitionStyle = .crossDissolve   // 淡入淡出转场
        modalPresentationStyle = .overCurrentContext // 覆盖式呈现
    }
    
    /// 配置基础UI
    func configureBaseUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(contentView)
    }
    
    /// 配置手势识别器
    func setupGestureRecognizers() {
        view.addGestureRecognizer(tapGesture)
        contentView.addGestureRecognizer(contentGesture)
    }
}

// MARK: - 手势处理
public extension SwiftModalController {
    
    /// 背景点击事件（默认关闭窗口）
    @objc func backgroundViewTap() {
        // 默认空实现，子类按需重写
    }
    
    /// 内容视图点击事件（子类可重写实现具体逻辑）
    @objc func contentViewTaped(tap: UITapGestureRecognizer) {
        // 默认空实现，子类按需重写
    }
}

// MARK: - 布局建议
extension SwiftModalController {
    /// 示例布局配置（子类可重写实现自定义布局）
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 示例：居中布局，宽度为屏幕80%，高度自适应
        // contentView.frame = CGRect(
        //     x: view.bounds.width * 0.1,
        //     y: view.bounds.midY - 100,
        //     width: view.bounds.width * 0.8,
        //     height: 200
        // )
        
        // 或使用自动布局：
        // NSLayoutConstraint.activate([
        //     contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //     contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        //     contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        //     contentView.heightAnchor.constraint(equalToConstant: 200)
        // ])
    }
}
