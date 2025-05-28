//
//  SwiftTableView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcTableView)
@objcMembers open class SwiftTableView: UITableView {
        
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin = ((UIGestureRecognizer) -> Bool?)

    open var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    open var shouldBegin: ShouldBegin?

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.white
        var rect = CGRect.zero
        rect.size.width = SCREEN_WIDTH_TO_WIDTH
        rect.size.height = 0.01

        tableFooterView = UIView(frame:rect)
        tableHeaderView = UIView(frame: rect)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 您是否支持多事件传递
    @objc(setObjcShouldRecognizeSimultaneously:)
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    /// 是否允许开始手势
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
}

public extension UITableView {
   
    /*
     注册cell扩展 
     示例代码:
     public class TableViewViewCell: SwiftTableViewCell { }
     或者
     public class TableViewViewCell: UITableViewCell, SwiftCellCompatible {  }
     
     实现如下tableView的代理, 调用tableView的扩展方法即可.
     /// 注册
     tableView.registerSwiftCell(TableViewViewCell.self)
     cell代理代理方法
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     /// 获取cell
        tableView.dequeueSwiftReusableCell(indexPath: indexPath, as: LXTableViewViewCell.self) 
     }
     */
    func registerSwiftCell<T: UITableViewCell>(cellType: T.Type) where T: SwiftCellCompatible {
      
        register(cellType.self, forCellReuseIdentifier: cellType.reusableIdentifier)
    }
    
    func registerSwifView<T: UITableViewHeaderFooterView>(headerFotterViewType: T.Type) where T: SwiftCellCompatible {
       
        register(headerFotterViewType.self, forCellReuseIdentifier: headerFotterViewType.reusableIdentifier)
    }

    /// 获取注册的cell的扩展
    func dequeueSwiftReusableCell<T: UITableViewCell>(indexPath: IndexPath, as cellType: T.Type = T.self) -> T where T: SwiftCellCompatible {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            preconditionFailure("Failed to dequeue a cell with identifier \(cellType.reusableIdentifier) matching type \(cellType.self). " + "Check that you registered the cell beforehand")
        }
        
        return cell
        
    }
    
    func dequeueSwiftReusableHeaderFotterView<T: UITableViewHeaderFooterView>(as viewType: T.Type = T.self) -> T where T: SwiftCellCompatible {
        
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reusableIdentifier) as? T else {
            preconditionFailure("Failed to dequeue a header/fotter with identifier \(viewType.reusableIdentifier) matching type \(viewType.self). " + "Check that you registered the header/fotter beforehand")
        }
        return view
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SwiftTableView: UIGestureRecognizerDelegate {
    
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? false
    }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBegin?(gestureRecognizer) ?? super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

//MARK: - LXTableViewCell
@objcMembers open class SwiftTableViewCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 子类配置方法
extension SwiftTableViewCell: SwiftUICompatible, SwiftCellCompatible {
    /// 配置界面元素（子类必须重写，无需调用super）
    @objc open func setupUI() {
        // 示例：在此添加子视图、约束等
    }
    
    /// 配置视图模型（子类必须重写，无需调用super）
    @objc open func setupViewModel() {
        // 示例：在此绑定数据模型、监听事件等
    }
}


// MARK: - 子类配置方法
extension SwiftTableView: SwiftUICompatible {
    /// 配置界面元素（子类必须重写，无需调用super）
    @objc open func setupUI() {
        // 示例：在此添加子视图、约束等
    }
    
    /// 配置视图模型（子类必须重写，无需调用super）
    @objc open func setupViewModel() {
        // 示例：在此绑定数据模型、监听事件等
    }
}
