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

open class LXSwiftView: UIView {
    
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
                    self?.setUIDidChange(.dark)
                }
            } else if self.traitCollection.userInterfaceStyle == .light {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.setUIDidChange(.light)
                }
            }
        }
    }
    
    /// 暗黑模式 和亮模式切换时调用
  @objc open func setUIDidChange(_ style: LXSwiftUserInterfaceStyle) { }
    
}

extension LXSwiftView: LXSwiftUIProtocol {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
