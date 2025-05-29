//
//  SwiftPickerView.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/31.
//

import UIKit

// MARK: - 协议定义
/// 内部使用的通用代理协议（私有）
@objc(LXObjcPickerViewCommomDelegate)
private protocol SwiftPickerViewCommomDelegate { }

/// 选择器视图的代理协议（公开）
@objc(LXObjcPickerViewDelegate)
public protocol SwiftPickerViewDelegate: AnyObject {
   
    /// 返回指定分组的头部高度
    @objc optional func pickerView(_ pickerView: SwiftPickerView, heightForHeaderInSection section: Int) -> CGFloat

    /// 返回指定分组的尾部高度
    @objc optional func pickerView(_ pickerView: SwiftPickerView, heightForFooterInSection section: Int) -> CGFloat
    
    /// 返回指定索引路径的单元格高度
    @objc optional func pickerView(_ pickerView: SwiftPickerView, heightForRowAt indexPath: IndexPath) -> CGFloat

    /// 单元格点击事件回调
    @objc optional func pickerView(_ pickerView: SwiftPickerView, didSelectRowAt indexPath: IndexPath)
    
    /// 滚动事件监听
    /// - Parameters:
    ///   - offSetY: 滑动内容的垂直偏移量
    ///   - scrollType: 滚动到的位置类型（顶部/中部/底部/滚动中）
    @objc optional func pickerView(_ pickerView: SwiftPickerView, scrollViewDidScroll offSetY: CGFloat, scrollType: SwiftPickerView.ScrollType)
}

/// 选择器视图的数据源协议（公开）
@objc(LXObjcPickerViewDataSource)
public protocol SwiftPickerViewDataSource: AnyObject {
   
    /// 注册自定义UITableViewCell，可进行额外配置
    func pickerView(_ pickerView: SwiftPickerView, registerClass tableView: UITableView)

    /// 返回指定分组中的行数
    func pickerView(_ pickerView: SwiftPickerView, numberOfRowsInSection section: Int) -> Int

    /// 配置并返回指定索引路径的单元格
    func pickerView(_ pickerView: SwiftPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   
    /// 返回分组数量（可选，默认为1组）
    @objc optional func pickerView(numberOfSections pickerView: SwiftPickerView) -> Int

    /// 返回指定分组的头部视图（可选）
    @objc optional func pickerView(_ pickerView: SwiftPickerView, viewForHeaderInSection section: Int) -> UIView?

    /// 返回指定分组的尾部视图（可选）
    @objc optional func pickerView(_ pickerView: SwiftPickerView, viewForFooterInSection section: Int) -> UIView?
}

// MARK: - 选择器主视图
@objc(LXObjcPickerView)
@objcMembers open class SwiftPickerView: UIView, SwiftPickerViewCommomDelegate {
    
    /// 滚动位置类型枚举
    @objc public enum ScrollType: Int {
        case change // 滚动中
        case top    // 滚动到顶部
        case mid    // 滚动到中部
        case bottom // 滚动到底部
    }
    
    // MARK: - 内部私有属性
    /// 圆角设置类型（内部使用）
    private enum ColorType {
        case none  // 无变化
        case start // 开始动画
        case end   // 结束动画
    }
    
    /// 内容最大高度（默认屏幕高度的60%）
    open var maxHeight: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.6 {
        didSet {
            tableView.lx.height = maxHeight
        }
    }
    
    /// 内容最小高度（默认屏幕高度的20%）
    open var minHeight: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.2
        
    /// 默认初始Y坐标（屏幕高度的60%位置）
    private var defaultOriginY: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.6
    
    /// 背景透明度（默认0.6）
    open var bgOpaque: CGFloat = 0.6
    
    /// 动画执行时长（默认0.15秒）
    open var animationDuration: TimeInterval = 0.15

    /// 点击背景是否触发关闭（默认true）
    open var isDismissOfDidSelectBgView: Bool = true
       
    /// 记录表格视图初始偏移量
    private var tableViewOriginOffSetY: CGFloat = 0
   
    /// 表格样式（分组/普通）
    private var style: UITableView.Style
    
    /// 头部/尾部默认高度（接近0）
    private let heightForHeaderAndFooter: CGFloat = 0.01
    
    /// 是否正在滚动头部视图
    private var isScrollTHeaderView: Bool = false
    
    // MARK: - 公开属性
    /// 代理对象
    open weak var delegate: SwiftPickerViewDelegate?
    
    /// 数据源对象
    open weak var dataSource: SwiftPickerViewDataSource? {
        didSet {
            // 注册表格单元格
            dataSource?.pickerView(self, registerClass: tableView)
        }
    }
    
    /// 整体圆角半径（设置后立即生效）
    open var tViewAllCornerRadii: CGFloat? {
        didSet {
            guard let cornerRadii = tViewAllCornerRadii else { return }
            tableView.lx.setCornerRadius(radius: cornerRadii, clips: true)
        }
    }
    
    /// 头部视图顶部圆角半径（注意：视图需先有尺寸）
    open var tHeaderViewTopCornerRadii: CGFloat? {
        didSet {
            guard let tHeaderView = tHeaderView else { return }
            setCornerRadii(tHeaderView, isHeader: true)
        }
    }
    
    /// 头部视图（设置顶部圆角）
    open var tHeaderView: UIView? {
        didSet {
            guard let tHeaderView = tHeaderView else { return }
            setCornerRadii(tHeaderView, isHeader: true)
            tableView.tableHeaderView = tHeaderView
        }
    }
    
    /// 尾部视图底部圆角半径（注意：视图需先有尺寸）
    open var tFooterViewBottomCornerRadii: CGFloat? {
        didSet {
            guard let tFooterView = tFooterView else { return }
            setCornerRadii(tFooterView, isHeader: false)
        }
    }
    
    /// 尾部视图（设置底部圆角）
    open var tFooterView: UIView? {
        didSet {
            guard let tFooterView = tFooterView else { return }
            setCornerRadii(tFooterView, isHeader: false)
            tableView.tableFooterView = tFooterView
        }
    }
      
    // MARK: - 初始化方法
    /// 自定义初始化器
    /// - Parameters:
    ///   - frame: 视图框架（默认全屏）
    ///   - style: 表格样式（默认普通样式）
    public init(_ frame: CGRect = CGRect(x: 0,
                                         y: 0,
                                         width: SCREEN_WIDTH_TO_WIDTH,
                                         height: SCREEN_HEIGHT_TO_HEIGHT),
                style: UITableView.Style = .plain) {
        self.style = style
        super.init(frame: frame)
        self.frame = frame
        
        // 初始化UI配置
        setContentUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 触摸事件处理
    /// 系统触摸事件处理
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let view = hitTest(point, with: event)
        
        // 点击背景且允许关闭时触发关闭
        if view is SwiftPickerViewCommomDelegate && isDismissOfDidSelectBgView {
            dismiss()
        }
    }
    
    // MARK: - 手势与视图组件
    /// 滑动手势识别器
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    /// 主内容表格视图（懒加载）
    private lazy var tableView: SwiftTableView = {
        let rect = CGRect(x: 0,
                          y: SCREEN_HEIGHT_TO_HEIGHT,
                          width: SCREEN_WIDTH_TO_WIDTH,
                          height: maxHeight)
        let tableView = SwiftTableView(frame: rect, style: style)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        return tableView
    }()
}

// MARK: - 公开方法扩展
extension SwiftPickerView {
    /// 关闭选择器视图
    /// - Parameter completion: 关闭完成后的回调
    @objc open func dismiss(_ completion:(() -> Void)? = nil) {
        endAnimation(CGFloat(Int(minHeight) >> 2), completion: completion)
    }
    
    /// 展示选择器视图
    /// - Parameters:
    ///   - rootView: 要添加到的父视图（默认当前控制器视图）
    ///   - completion: 展示完成后的回调
    @objc open func show(_ rootView: UIView? = nil, completion:(() -> Void)? = nil) {
        let currentView = rootView ?? UIApplication.lx.currentViewController?.view
        currentView?.addSubview(self)

        starAnimation { [weak self] in
            guard let self = self else { return }
            completion?()
            self.setScrollViewDidScroll(.mid)
        }
    }
    
    /// 刷新表格数据
    @objc open func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - 私有方法扩展
extension SwiftPickerView {
    /// 初始化内容UI
    private func setContentUI() {
        addSubview(tableView)
        tableView.addGestureRecognizer(panGesture)
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: SCREEN_HEIGHT_TO_BOTTOMSAFEHEIGHT,
            right: 0
        )
    }
    
    /// 处理滑动手势
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            // 记录初始Y位置
            defaultOriginY = tableView.frame.minY
        case .changed:
            // 计算新的Y位置（限制在有效范围内）
            let newY = max(
                defaultOriginY + point.y - tableViewOriginOffSetY,
                SCREEN_HEIGHT_TO_HEIGHT - maxHeight
            )
            tableView.lx.y = newY
            setScrollViewDidScroll(.change)
        default:
            // 手势结束处理关闭逻辑
            endAnimation(SCREEN_HEIGHT_TO_HEIGHT - tableView.frame.minY)
        }
    }
    
    /// 设置头部/尾部圆角
    private func setCornerRadii(_ view: UIView, isHeader: Bool) {
        if isHeader, let cornerRadii = tHeaderViewTopCornerRadii {
            // 设置头部左上+右上圆角
            view.lx.setPartCornerRadius(
                radius: cornerRadii,
                roundingCorners: [.topLeft, .topRight]
            )
        } else if !isHeader, let cornerRadii = tFooterViewBottomCornerRadii {
            // 设置尾部左下+右下圆角
            view.lx.setPartCornerRadius(
                radius: cornerRadii,
                roundingCorners: [.bottomLeft, .bottomRight]
            )
        }
    }

    /// 触发滚动代理回调
    private func setScrollViewDidScroll(_ scrollType: ScrollType) {
        delegate?.pickerView?(
            self,
            scrollViewDidScroll: SCREEN_HEIGHT_TO_HEIGHT - tableView.lx.y,
            scrollType: scrollType
        )
    }
    
    /// 执行显示动画
    private func starAnimation(_ completion:(() -> Void)? = nil) {
        setContentOffset(minHeight, colorType: .start, completion: completion)
    }
    
    /// 执行关闭动画
    private func endAnimation(_ offSet: CGFloat, completion:(() -> Void)? = nil) {
        let height: CGFloat
        let scrollType: ScrollType
        let colorType: ColorType
        
        switch offSet {
        case ...minHeight:
            // 低于最小高度：关闭视图
            height = 0
            scrollType = .bottom
            colorType = .end
        case minHeight..<maxHeight:
            // 在中间区域：根据距离判断停靠位置
            let isTop = (maxHeight - offSet) < (offSet - minHeight)
            height = isTop ? maxHeight : minHeight
            scrollType = isTop ? .top : .mid
            colorType = .none
        default:
            // 高于最大高度：停靠到顶部
            height = maxHeight
            scrollType = .top
            colorType = .none
        }
        
        setContentOffset(height, colorType: colorType) { [weak self] in
            guard let self = self else { return }
            
            if height == 0 {
                // 完全关闭后移除视图
                completion?()
                self.removeFromSuperview()
            } else {
                // 更新滚动位置状态
                self.setScrollViewDidScroll(scrollType)
            }
        }
    }
    
    /// 执行内容视图位置动画
    private func setContentOffset(_ height: CGFloat,
                                 colorType: ColorType = .none,
                                 completion:(() -> Void)? = nil) {
        // 初始背景色设置
        switch colorType {
        case .start: backgroundColor = .black.withAlphaComponent(0)
        case .end: backgroundColor = .black.withAlphaComponent(bgOpaque)
        default: break
        }
        
        UIView.animate(withDuration: animationDuration) {
            // 动画过程
            self.tableView.lx.y = SCREEN_HEIGHT_TO_HEIGHT - height
            
            // 背景色过渡
            switch colorType {
            case .start: self.backgroundColor = .black.withAlphaComponent(self.bgOpaque)
            case .end: self.backgroundColor = .black.withAlphaComponent(0)
            default: break
            }
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - UITableView代理方法
extension SwiftPickerView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        delegate?.pickerView?(self, heightForRowAt: indexPath) ?? SCALE_IP6_WIDTH_TO_WIDTH(55)
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        delegate?.pickerView?(self, heightForHeaderInSection: section) ?? heightForHeaderAndFooter
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        delegate?.pickerView?(self, heightForFooterInSection: section) ?? heightForHeaderAndFooter
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.pickerView?(self, didSelectRowAt: indexPath)
    }
}

// MARK: - UITableView数据源方法
extension SwiftPickerView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.pickerView?(numberOfSections: self) ?? 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.pickerView(self, numberOfRowsInSection: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dataSource?.pickerView(self, tableView: tableView, cellForRowAt: indexPath) else {
            fatalError("必须实现cellForRowAt方法并返回有效的UITableViewCell")
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource?.pickerView?(self, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        dataSource?.pickerView?(self, viewForFooterInSection: section)
    }
}

// MARK: - 手势代理方法
extension SwiftPickerView: UIGestureRecognizerDelegate {
    /// 允许多手势同时识别
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - 滚动视图代理方法
extension SwiftPickerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 当表格在顶部时允许滚动，否则重置位置
        if !(scrollView.contentOffset.y > 0 && tableView.frame.minY == SCREEN_HEIGHT_TO_HEIGHT - maxHeight) {
            tableView.contentOffset = .zero
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableViewOriginOffSetY = tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableViewOriginOffSetY = tableView.contentOffset.y
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        tableViewOriginOffSetY = tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableViewOriginOffSetY = tableView.contentOffset.y
    }
}
