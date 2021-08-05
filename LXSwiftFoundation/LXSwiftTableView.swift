//
//  LXTableView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

open class LXSwiftTableView: UITableView{
        
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    public var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    public var shouldBegin: ShouldBegin?

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.white
        var rect = CGRect.zero
        rect.size.width = LXSwiftApp.screenW
        rect.size.height = 0.01

        tableFooterView = UIView(frame:rect)
        tableHeaderView = UIView(frame: rect)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }else {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 您是否支持多事件传递
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    /// 是否允许开始手势
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
}

public extension UITableView {

    func registSwiftCell<T: UITableViewCell>(_ cell: T.Type) where T: LXSwiftCellCompatible {
        self.register(cell, forCellReuseIdentifier: cell.reusableSwiftIdentifier)
    }

    func dequeueSwiftReusableCell<T: UITableViewCell>(indexPath: IndexPath)
    -> T where T: LXSwiftCellCompatible {
        return self.dequeueReusableCell(withIdentifier: T.reusableSwiftIdentifier, for: indexPath) as! T
    }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftTableView: UIGestureRecognizerDelegate {
    
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let outResult = shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer)
        return outResult ?? false
    }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let outResult = shouldBegin?(gestureRecognizer)
        return outResult ?? super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

//MARK: - LXTableViewCell
open class LXSwiftTableViewCell: UITableViewCell, LXSwiftCellCompatible {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXSwiftTableView: LXViewSetup {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}

extension LXSwiftTableViewCell: LXViewSetup {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
