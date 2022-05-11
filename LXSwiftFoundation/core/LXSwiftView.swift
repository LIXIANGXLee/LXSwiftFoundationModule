//
//  LXView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIView: LXCustomRoundbackground { }

@objc public enum LXSwiftUserInterfaceStyle: Int {
    case dark
    case light
}

public extension LXSwiftUIProtocol {
    func setupUI() { }
    func setupViewModel() { }
}
 
@objc(LXObjcView)
@objcMembers open class LXSwiftView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
  @objc open func updateTraitCollectionDidChange(_ style: LXSwiftUserInterfaceStyle) { }
    
     /// 使用traitCollectionDidChange并使用hasDifferentColorAppearance比较特征集，以在切换黑暗模式时捕获, 注意⚠️： CGcolor 颜色刷新需要再次方法内执行
   @objc open func updateHasDifferentColorAppearance() { }

}

extension LXSwiftView: LXSwiftUIProtocol {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
