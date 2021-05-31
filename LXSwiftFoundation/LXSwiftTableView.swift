//
//  LXTableView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftTableView: UITableView{
        
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer,
                                                 UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    public var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    public var shouldBegin: ShouldBegin?

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.white
        ///cell
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
    
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
}

public extension LXSwiftTableView {

    func registSwiftCell<T: UITableViewCell>(_ cell: T.Type) where T: LXSwiftCellCompatible {
        self.register(cell, forCellReuseIdentifier: cell.reusableSwiftIdentifier)
    }

    func dequeueSwiftReusableCell<T: UITableViewCell>(indexPath: IndexPath)
    -> T where T: LXSwiftCellCompatible {
        return self.dequeueReusableCell(withIdentifier: T.reusableSwiftIdentifier,
                                        for: indexPath) as! T
    }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftTableView: UIGestureRecognizerDelegate {
    
    /// Do you support multiple event delivery delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith
                                    otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let outResult = shouldRecognizeSimultaneously?(gestureRecognizer,
                                                       otherGestureRecognizer)
        return outResult ?? true
    }
    
    /// is can event
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer)
    -> Bool {
        let outResult = shouldBegin?(gestureRecognizer)
        return outResult ??
            super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

//MARK: - LXTableViewCell
open class LXSwiftTableViewCell: UITableViewCell,
                                    LXSwiftCellCompatible {

    public override init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
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
