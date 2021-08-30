//
//  LXTableView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

private let tag = 19920423

open class LXSwiftTableView: UITableView {
        
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
   
    /*
     注册cell扩展
     示例代码:
     public class LXTableViewViewCell: LXSwiftTableViewCell { }
     或者
     public class LXTableViewViewCell: UITableViewCell, LXSwiftCellCompatible {  }
     
     实现如下tableView的代理, 调用tableView的扩展方法即可.
     /// 注册
     tableView.registSwiftCell(LXTableViewViewCell.self)
     cell代理代理方法
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     /// 获取cell
        tableView.dequeueSwiftReusableCell(indexPath: indexPath) as LXTableViewViewCell
     }
     */
    func registSwiftCell<T: UITableViewCell>(_ cell: T.Type) where T: LXSwiftCellCompatible {
        self.register(cell, forCellReuseIdentifier: cell.reusableSwiftIdentifier)
    }

    /// 获取注册的cell的扩展
    func dequeueSwiftReusableCell<T: UITableViewCell>(indexPath: IndexPath)
    -> T where T: LXSwiftCellCompatible {
        return self.dequeueReusableCell(withIdentifier: T.reusableSwiftIdentifier, for: indexPath) as! T
    }
    
    /*
     给cell扩展圆角和背景色
     示例代码:
     实现如下tableView的代理, 调用tableView的扩展方法即可.
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.roundSwiftSectionCell(cell, forRowAt: indexPath, cornerRadius: 6.0)
     }
     */
    func roundSwiftSectionCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath, cornerRadius: CGFloat, backgroundColor: UIColor = .white) {
        let hasSectionHeader = (self.delegate?.tableView?(self, viewForHeaderInSection: indexPath.section)) != nil
        let hasSectionFooter = (self.delegate?.tableView?(self, viewForFooterInSection: indexPath.section)) != nil
        let numberOfRows = self.numberOfRows(inSection: indexPath.section)
        if (indexPath.row == 0 && numberOfRows == 1) {
            cell.roundSwiftBackground(roundingCorners: .allCorners, cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        } else if indexPath.row == 0 && !hasSectionHeader {
            cell.roundSwiftBackground(roundingCorners: [.topLeft, .topRight], cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        } else if indexPath.row == (numberOfRows - 1) && !hasSectionFooter {
            cell.roundSwiftBackground(roundingCorners: [.bottomLeft, .bottomRight], cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        } else {
            cell.roundSwiftBackground(roundingCorners: [], cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        }
    }
    
    /// 给sectionHeader扩展圆角和背景色
    func roundSwiftSectionHeader(_ sectionHeader: UIView, forSection section: Int, cornerRadius: CGFloat, backgroundColor: UIColor = .white) {
        OperationQueue.main.addOperation {
            let numberOfRows = self.numberOfRows(inSection: section)
            let hasSectionFooter = (self.delegate?.tableView?(self, viewForFooterInSection: section)) != nil
            if numberOfRows == 0 && hasSectionFooter == false {
                sectionHeader.roundSwiftBackground(roundingCorners: .allCorners, cornerRadius: cornerRadius, backgroundColor: backgroundColor)
            }else{
                sectionHeader.roundSwiftBackground(roundingCorners: [.topLeft, .topRight], cornerRadius: cornerRadius, backgroundColor: backgroundColor)
            }
        }
    }
    
    /// 给sectionFooter扩展圆角和背景色
    func roundSwiftSectionFooter(_ sectionFooter: UIView, forSection section: Int, cornerRadius: CGFloat, backgroundColor: UIColor = .white) {
        let numberOfRows = self.numberOfRows(inSection: section)
        let hasSectionHeader = (self.delegate?.tableView?(self, viewForHeaderInSection: section)) != nil
        if numberOfRows == 0 && hasSectionHeader == false {
            sectionFooter.roundSwiftBackground(roundingCorners: .allCorners, cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        }else{
            sectionFooter.roundSwiftBackground(roundingCorners: [.bottomLeft, .bottomRight], cornerRadius: cornerRadius, backgroundColor: backgroundColor)
        }
    }
}

extension LXCustomRoundbackground {
    
    public func roundSwiftBackground(roundingCorners: UIRectCorner, cornerRadius: CGFloat, backgroundColor: UIColor = .white) {
        let bounds = associatedView.bounds
        
        let backgroundLayer = CAShapeLayer()
        let besizer = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        backgroundLayer.path = besizer.cgPath
        backgroundLayer.fillColor = backgroundColor.cgColor
        associatedView.backgroundColor = UIColor.clear
        associatedView.layer.sublayers?.forEach {
            if let shapeLayer = $0 as? CAShapeLayer {
                shapeLayer.removeFromSuperlayer()
            }
        }
        associatedView.layer.insertSublayer(backgroundLayer, at: 0)
    }
}

extension LXCustomRoundbackground where Self: UITableViewCell {
    var associatedView: UIView {
        if backgroundView?.tag != tag {
            let roundView = UIView(frame: bounds)
            roundView.backgroundColor = UIColor.clear
            roundView.tag = tag
            backgroundView = roundView
        }
        return backgroundView!
    }
}

extension LXCustomRoundbackground where Self: UITableViewHeaderFooterView {
    var associatedView: UIView {
        if backgroundView?.tag != tag {
            let roundView = UIView(frame: bounds)
            roundView.backgroundColor = UIColor.clear
            roundView.tag = tag
            backgroundView = roundView
        }
        return backgroundView!
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

