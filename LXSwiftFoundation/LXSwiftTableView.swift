//
//  LXTableView.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftTableView: UITableView {

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        //避免没有数据的cell出现线条
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.001))
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.001))
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

extension LXSwiftTableView: LXViewSetup {
   open func setupUI() { }
   open func setupViewModel() {}

}


//MARK: - LXTableViewCell
open class LXSwiftTableViewCell: UITableViewCell {
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
