//
//  LXSwiftViewController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit

@objc(LXObjcViewController)
@objcMembers open class SwiftViewController: UIViewController {
   
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        setupViewModel()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.updateTraitCollectionDidChange(.dark)
                }
            } else if self.traitCollection.userInterfaceStyle == .light {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.updateTraitCollectionDidChange(.light)
                }
            }
            
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.updateHasDifferentColorAppearance()
            }
        }
    }
    
    /// 暗黑模式 和亮模式切换时调用
  @objc open func updateTraitCollectionDidChange(_ style: SwiftUserInterfaceStyle) { }
    
     /// 使用traitCollectionDidChange并使用hasDifferentColorAppearance比较特征集，以在切换黑暗模式时捕获, 注意⚠️： CGcolor 颜色刷新需要再次方法内执行
   @objc open func updateHasDifferentColorAppearance() { }

}
