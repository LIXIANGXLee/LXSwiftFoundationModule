//
//  LXUIViewController.swift
//  LXColorManager
//
//  Created by Mac on 2020/5/24.
//

import UIKit

open class LXSwiftViewController: UIViewController,LXSwiftUICompatible {
    public var swiftModel: Any?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.setUIDidChange(.dark)
                }
            }else if self.traitCollection.userInterfaceStyle == .light {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.setUIDidChange(.light)
                }
            }
        }
    }
    
    /// 切换深色模式 浅色模式 (切换暗黑模式修改) 需要做的修改
    open func setUIDidChange(_ style: LXSwiftUserInterfaceStyle) { }
}
