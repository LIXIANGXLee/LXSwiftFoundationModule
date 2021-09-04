//
//  LXSwiftPickerView.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/31.
//

import UIKit

@objc(LXObjcPickerViewCommomDelegate)
private protocol LXSwiftPickerViewCommomDelegate { }

@objc(LXObjcPickerViewDelegate)
public protocol LXSwiftPickerViewDelegate: AnyObject {
   
    /// Header 高度
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, heightForHeaderInSection section: Int) -> CGFloat

    /// Footer 高度
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, heightForFooterInSection section: Int) -> CGFloat
    
    /// cell 高度
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, heightForRowAt indexPath: IndexPath) -> CGFloat

    /// cell点击事件
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, didSelectRowAt indexPath: IndexPath)
    
    /// 滚动事件监听
    /// scrollType 滚动到的类型
    /// offSetY 滑动内容偏移量
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, scrollViewDidScroll offSetY: CGFloat, scrollType: LXSwiftPickerView.ScrollType)
    
}

@objc(LXObjcPickerViewDataSource)
public protocol LXSwiftPickerViewDataSource: AnyObject {
   
    /// 获取需要注册的UITableViewCell，同事也可以设置一些tableView额外的配置，或者修改一些tableView参数
    func pickerView(_ pickerView: LXSwiftPickerView, registerClass tableView: UITableView)

    /// 返回每组的cell个数
    func pickerView(_ pickerView: LXSwiftPickerView, numberOfRowsInSection section: Int) -> Int

    /// 设置对应索引的cell
    func pickerView(_ pickerView: LXSwiftPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   
    /// 有几个组
    @objc optional func pickerView(numberOfSections pickerView: LXSwiftPickerView) -> Int

    /// cell 头
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, viewForHeaderInSection section: Int) -> UIView?

    /// cell 尾
    @objc optional func pickerView(_ pickerView: LXSwiftPickerView, viewForFooterInSection section: Int) -> UIView?
}

@objc(LXObjcPickerView)
@objcMembers public class LXSwiftPickerView: UIView, LXSwiftPickerViewCommomDelegate {
    
    @objc public enum ScrollType: Int {
        case change // 持续滚动
        case top    // 滚动到顶部
        case mid    // 滚动到中部
        case bottom // 滚动到底部
    }
    
    /// 内部枚举
    private enum ColorType {
        case none
        case start
        case end
    }
    
    /// 内容的最大高度
    public var maxHeight: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.6 {
        didSet {
            tableView.lx_height = maxHeight
        }
    }
    
    /// 内容的最小高度
    public var minHeight: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.2
        
    /// 默认弹出来时的原始Y坐标
    private var defaultOriginY: CGFloat = SCREEN_HEIGHT_TO_HEIGHT * 0.6
    
    /// 背景透明度
    public var bgOpaque: CGFloat = 0.6
    
    /// 动画之行时间
    public var animationDuration: TimeInterval = 0.15

    /// 点击背景事件是否触发dismiss事件
    public var isDismissOfDidSelectBgView: Bool = true
       
    /// 记录默认 tableView 滚动偏移量
    private var tableViewOriginOffSetY: CGFloat = 0
   
    /// 内容分组 和 不分组
    private var style: UITableView.Style
    
    /// 常量height的高度和footer的高度
    private let heightForHeaderAndFooter: CGFloat = 0.01
    
    ///滑动的事bgView的头部时 isScrollTHeaderView == true
    private var isScrollTHeaderView: Bool = false
    
    public weak var delegate: LXSwiftPickerViewDelegate?
    public weak var dataSource: LXSwiftPickerViewDataSource? {
        didSet {
            /// 注册tableViewCell
            dataSource?.pickerView(self, registerClass: tableView)
        }
    }
    
    /// 设置整体圆角 上、下、左、右
    public var tViewAllCornerRadii: CGFloat? {
        didSet {
            guard let cornerRadii = self.tViewAllCornerRadii else { return }
            self.tableView.lx.setCornerRadius(radius: cornerRadii, clips: true)
        }
    }
    
    ///设置内容顶部圆角, 特别注意：设置圆角之前tHeaderView必须有尺寸，否则圆角设置不成功，
    /// 如果此方法在tHeaderView设置之前调用设置圆角也是起作用的，但是赋值tHeaderView的view之前必须有尺寸
    public var tHeaderViewTopCornerRadii: CGFloat? {
        didSet {
            guard let tHeaderView = self.tHeaderView else { return }
            setCornerRadii(tHeaderView, isHeader: true)
        }
    }
    
    /// 头view tHeaderView 特别注意：设置圆角之前tHeaderView必须有尺寸，否则圆角设置不成功，
    /// 如果此方法在tHeaderView设置之前调用设置圆角也是起作用的，但是赋值tHeaderView的view之前必须有尺寸，如果单独设置圆角就不要设置setTHeaderViewTopCornerRadii的值了
    public var tHeaderView: UIView? {
        didSet {
            guard let tHeaderView = tHeaderView else { return }
            setCornerRadii(tHeaderView, isHeader: true)
            self.tableView.tableHeaderView = tHeaderView
        }
    }
    
    ///设置内容顶部圆角, 特别注意：设置圆角之前tFooterView必须有尺寸，否则圆角设置不成功，
    /// 如果此方法在tFooterView设置之前调用设置圆角也是起作用的，但是赋值tFooterView的view之前必须有尺寸
    public var tFooterViewBottomCornerRadii: CGFloat? {
        didSet {
            guard let tFooterView = self.tFooterView else { return }
            setCornerRadii(tFooterView, isHeader: false)
        }
    }
    
    /// 尾view tFooterView 特别注意：设置圆角之前tFooterView必须有尺寸，否则圆角设置不成功，
    /// 如果此方法在tFooterView设置之前调用设置圆角也是起作用的，但是赋值tFooterView的view之前必须有尺寸，如果单独设置圆角就不要设置setTFooterViewBottomCornerRadii的值了
    public var tFooterView: UIView? {
        didSet {
            guard let tFooterView = tFooterView else { return }
            setCornerRadii(tFooterView, isHeader: false)
            self.tableView.tableFooterView = tFooterView
        }
    }
      
    /// 自定义指定构造器
    public init(_ frame: CGRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: SCREEN_HEIGHT_TO_HEIGHT), style: UITableView.Style = .plain) {
        
        self.style = style
        super.init(frame: frame)
        self.frame = frame
        
        /// 设置内容UI
        setContentUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 系统背景点击事件
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let view = self.hitTest(point, with: event)
        if view is LXSwiftPickerViewCommomDelegate && isDismissOfDidSelectBgView {
            dismiss()
        }
    }
    
    /// 手势滑动
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    /// 延迟属性 加载内容
    private lazy var tableView: LXSwiftTableView = {
        
         let rect = CGRect(x: 0,
                           y: SCREEN_HEIGHT_TO_HEIGHT,
                           width: SCREEN_WIDTH_TO_WIDTH,
                           height: maxHeight)
         let tableView = LXSwiftTableView(frame: rect, style: self.style)
         tableView.backgroundColor = UIColor.white
         tableView.separatorStyle = .none
         tableView.dataSource = self
         tableView.delegate = self
         tableView.isScrollEnabled = true
         return tableView
    }()
}

extension LXSwiftPickerView {
  
    /// 退出pickerView
   @objc public func dismiss(_ completion:(() -> Void)? = nil) {
        /// 结束动画
        endAnimation(CGFloat(Int(minHeight) >> 2), completion: completion)
    }
    
    /// 展示pickerView
   @objc public func show(_ rootView: UIView? = nil, completion:(() -> Void)? = nil) {
        if rootView != nil {
            rootView?.addSubview(self)
        }else{
            lx.presentView?.addSubview(self)
        }
        
        /// 开始动画
        starAnimation { [weak self] in
            guard let `self` = self else { return }
            completion?()
            self.setScrollViewDidScroll(.mid)
        }
    }
    
    /// 刷新内容数据
    @objc public func reloadData() {
        self.tableView.reloadData()
    }
}

extension LXSwiftPickerView {

    private func setContentUI() {
        
        /// 添加tableView
        addSubview(tableView)
        
        /// 添加手势 给tableView
        tableView.addGestureRecognizer(panGesture)
       
        /// 设置底部偏移量
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: SCREEN_HEIGHT_TO_TOUCHBARHEIGHT, right: 0)
    }
    
    /// 滑动事件处理
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view)
        switch gesture.state {
        case .began:
            defaultOriginY = tableView.frame.minY
        case .changed:
            /// 持续滑动修改tableView 的Y坐标
            tableView.lx_y = max(defaultOriginY + point.y - tableViewOriginOffSetY,
                                 SCREEN_HEIGHT_TO_HEIGHT - maxHeight)
            self.setScrollViewDidScroll(.change)
        default:
            /// 结束 或者 取消滑动
            endAnimation(SCREEN_HEIGHT_TO_HEIGHT - tableView.frame.minY)
        }
    }
    
    /// 设置圆角（Footer or Header）
    private func setCornerRadii(_ view: UIView, isHeader: Bool) {
        if isHeader {
            /// 判断 如果有 setContentHeaderTopCornerRadii 则设置原角
             if let cornerRadii = tHeaderViewTopCornerRadii {
                view.lx.setPartCornerRadius(radius: cornerRadii, roundingCorners: [.topLeft,.topRight])
             }
        }else{
            if let cornerRadii = tFooterViewBottomCornerRadii {
                view.lx.setPartCornerRadius(radius: cornerRadii, roundingCorners: [.bottomLeft,.bottomRight])
            }
        }
    }

    /// 设置滚动偏移量回调
    private func setScrollViewDidScroll(_ scrollType: LXSwiftPickerView.ScrollType) {
        self.delegate?.pickerView?(self, scrollViewDidScroll: SCREEN_HEIGHT_TO_HEIGHT - tableView.lx_y, scrollType: scrollType)
    }
    
    /// 开始动画
    private func starAnimation(_ completion:(() -> Void)? = nil) {
        setContentOffset(minHeight, colorType: .start, completion: completion)
    }
    
    /// 结束动画
    private func endAnimation(_ offSet: CGFloat, completion:(() -> Void)? = nil) {
        if offSet > maxHeight {
            setContentOffset(maxHeight) { [weak self] in
                guard let `self` = self else { return }
                self.setScrollViewDidScroll(.top)
            }
        }else if offSet <= maxHeight && offSet >= minHeight {/// 最大和最小之间
            let isTop = maxHeight - offSet < offSet - minHeight
            let height = isTop ? maxHeight : minHeight
            setContentOffset(height) { [weak self] in
                guard let `self` = self else { return }
                self.setScrollViewDidScroll(isTop ? .top : .mid)
            }
        }else { /// 最小和底部的之间
            let isTop = minHeight - offSet < offSet
            let colorType = isTop ? ColorType.none : ColorType.end
            let height = isTop ? minHeight : 0
            setContentOffset(height, colorType: colorType) { [weak self] in
                guard let `self` = self else { return }
                self.setScrollViewDidScroll(isTop ? .mid : .bottom)
                if !isTop {
                    completion?()
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    /// 设置内容偏移量
    private func setContentOffset(_ height: CGFloat,
                                  colorType: ColorType = .none, completion:(() -> Void)? = nil) {
        switch colorType {
        case .start:
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        case .end:
            self.backgroundColor = UIColor.black.withAlphaComponent(self.bgOpaque)
        default:
            break
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.tableView.lx_y = SCREEN_HEIGHT_TO_HEIGHT - height
            switch colorType {
            case .start:
                self.backgroundColor = UIColor.black.withAlphaComponent(self.bgOpaque)
            case .end:
                self.backgroundColor = UIColor.black.withAlphaComponent(0)
            default:
                break
            }
        } completion: { (_) in
            completion?()
        }
    }
}

// MARK: - UITableViewDelegate 函数
extension LXSwiftPickerView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.pickerView?(self, heightForRowAt: indexPath) ?? SCALE_IP6_WIDTH_TO_WIDTH(55)
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.pickerView?(self, heightForHeaderInSection: section) ?? heightForHeaderAndFooter
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.pickerView?(self, heightForFooterInSection: section) ?? heightForHeaderAndFooter
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///点击事件回调 取消点击效果
        tableView.deselectRow(at: indexPath, animated: true)
        /// 点击事件回调
        delegate?.pickerView?(self, didSelectRowAt: indexPath)
    }
    
}

// MARK: - UITableViewDataSource 函数
extension LXSwiftPickerView: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.pickerView?(numberOfSections: self) ?? 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.pickerView(self, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource!.pickerView(self, tableView: tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource?.pickerView?(self, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dataSource?.pickerView?(self, viewForFooterInSection: section)
    }
}

// MARK: - UIGestureRecognizerDelegate 函数
extension LXSwiftPickerView: UIGestureRecognizerDelegate {
    
    /// 支持多个 事件同时进行
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate 函数
extension LXSwiftPickerView:  UIScrollViewDelegate {
    
    /// 滚动视图
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && Int(self.tableView.frame.origin.y) == Int(SCREEN_HEIGHT_TO_HEIGHT - maxHeight){
          
        }else{
            /// 非滑动顶部的时候tableView偏移量处理
            self.tableView.contentOffset = CGPoint.zero
        }
    }
    
    ///开始拖拽
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// 记录偏移量
        self.tableViewOriginOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /// 记录偏移量
        self.tableViewOriginOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        /// 记录偏移量
        self.tableViewOriginOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// 记录偏移量
        self.tableViewOriginOffSetY = self.tableView.contentOffset.y
    }
}
