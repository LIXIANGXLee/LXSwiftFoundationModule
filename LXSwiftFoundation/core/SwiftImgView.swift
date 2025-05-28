//
//  SwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

/// 增强的 UIImageView 子类，支持点击事件回调与扩展参数
open class SwiftImgView: UIImageView {
    
    // MARK: - Public Properties
    
    /// 通用扩展参数容器（可用于传递自定义数据）
    /// 示例：swiftImgView.swiftModel = YourCustomModel()
    public var swiftModel: Any?
    
    /// 点击事件回调闭包类型（参数为当前视图实例的弱引用）
    public typealias TapClosure = ((_ view: SwiftImgView?) -> Void)
    
    /// 点击事件回调（使用弱引用避免循环引用）
    open var tapClosure: TapClosure?
    
    /// 交互使能开关（自动同步系统交互属性）
    /// - 注意：此属性仅用于业务层逻辑判断，实际交互状态请使用 isUserInteractionEnabled
    open var isInteractionEnabled: Bool = false {
        didSet {
            isUserInteractionEnabled = isInteractionEnabled
            setupTapGestureIfNeeded()
        }
    }
    
    /// 点击防抖时间间隔（默认 1 秒）
    open var tapThrottleInterval: TimeInterval = 1.0
    
    // MARK: - Private Properties
    
    /// 点击手势识别器（懒加载保证只创建一次）
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleTap(_:)))
        return gesture
    }()
    
    // MARK: - Initialization
    
    /// 便捷初始化方法（默认零帧布局）
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// 指定初始化方法
    /// - Parameter frame: 视图布局帧
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// 不支持 Storyboard/XIB 初始化
    /// - 重要：如需支持 Interface Builder，需移除 fatalError 并实现相关逻辑
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    /// 公共初始化配置
    private func commonInit() {
        setupTapGestureIfNeeded()
    }
    
    /// 按需设置点击手势
    private func setupTapGestureIfNeeded() {
        // 仅在允许交互时添加手势
        guard isInteractionEnabled,
              gestureRecognizers?.contains(tapGesture) != true else {
            return
        }
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action Handling
    
    /// 处理点击事件
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        // 防抖处理：点击后临时禁用交互
        isUserInteractionEnabled = false
        defer {
            // 延迟恢复交互（确保即使提前释放也不会崩溃）
            DispatchQueue.main.asyncAfter(deadline: .now() + tapThrottleInterval) { [weak self] in
                self?.isUserInteractionEnabled = true
            }
        }
        
        // 执行回调（传递弱引用避免循环）
        tapClosure?(self)
    }
    
    // MARK: - Lifecycle
    
    /// 析构时移除手势（示范内存管理）
    deinit {
        removeGestureRecognizer(tapGesture)
    }
}
