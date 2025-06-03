//
//  SwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

/// 增强的 UIImageView 子类，支持点击事件回调与扩展参数
@objc(LXObjcImgView)
@objcMembers open class SwiftImgView: UIImageView {
    
    // MARK: - Public Properties
    
    /// 通用扩展参数容器（可用于传递自定义数据）
    /// 示例：swiftImgView.swiftModel = YourCustomModel()
    public var swiftModel: Any?
    
    /// 点击事件回调（使用弱引用避免循环引用）
    open var handler: ((_ view: SwiftImgView) -> Void)?
    
    /// 点击防抖时间间隔（默认 1 秒）
    open var throttleInterval: TimeInterval = 1.0
        
    // MARK: - Initialization
    
    /// 便捷初始化方法（默认零帧布局）
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// 指定初始化方法
    /// - Parameter frame: 视图布局帧
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 跨版本背景色适配
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        lx.addTapGesture(execute: tap(_:))
    }
    
    /// 不支持 Storyboard/XIB 初始化
    /// - 重要：如需支持 Interface Builder，需移除 fatalError 并实现相关逻辑
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Action Handling
    
    /// 处理点击事件
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        // 防抖处理：点击后临时禁用交互
        isUserInteractionEnabled = false
        defer {
            // 延迟恢复交互（确保即使提前释放也不会崩溃）
            DispatchQueue.lx.delay(throttleInterval) { [weak self] in
                self?.isUserInteractionEnabled = true
            }
        }
        
        // 执行回调（传递弱引用避免循环）
        handler?(self)
    }
    
    // MARK: - Lifecycle
    
    /// 析构时移除手势（示范内存管理）
    deinit {
        lx.removeTapGesture()
    }
}
