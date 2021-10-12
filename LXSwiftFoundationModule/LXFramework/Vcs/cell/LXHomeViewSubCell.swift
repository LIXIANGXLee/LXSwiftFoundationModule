//
//  LXHomeViewSubCell.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class LXHomeViewSubCell: LXSwiftCollectionViewCell {

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 40))
        titleLabel.text = "sasasasas"
        return titleLabel
    }()
    
    override func setupUI() {
        backgroundColor = UIColor.lx.randomColor()

        addSubview(titleLabel)
    }

}
