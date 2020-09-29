//
//  LXTableView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftTableView: UITableView ,LXSwiftUICompatible{
    public var swiftModel: Any?

    ///Do you support multiple event delivery
    public var isSopportRecognizeSimultaneous = false
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        ///cell
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: 0.001))
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width:  LXSwiftApp.screenW, height: 0.001))
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
}


//MARK: - UIGestureRecognizerDelegate
extension LXSwiftTableView: UIGestureRecognizerDelegate {
  
    /// Do you support multiple event delivery delegate
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return isSopportRecognizeSimultaneous
     }
    
}

extension LXSwiftTableView: LXViewSetup {
   open func setupUI() { }
   open func setupViewModel() {}

}


//MARK: - LXTableViewCell
open class LXSwiftTableViewCell: UITableViewCell, LXSwiftUICompatible {
    public var swiftModel: Any?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXSwiftTableViewCell: LXViewSetup {
    open func setupUI() {}
    open func setupViewModel() {}
}
