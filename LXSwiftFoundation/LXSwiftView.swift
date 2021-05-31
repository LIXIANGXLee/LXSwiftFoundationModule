//
//  LXView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public enum LXSwiftUserInterfaceStyle {
    case dark
    case light
}

public protocol LXViewSetup: AnyObject {
    func setupUI()
    func setupViewModel()
}

public extension LXViewSetup {
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
            }else if self.traitCollection.userInterfaceStyle == .light {
                self.traitCollection.performAsCurrent { [weak self] in
                    self?.setUIDidChange(.light)
                }
            }
        }
    }
    
    /// call  after dark and light change
    open func setUIDidChange(_ style: LXSwiftUserInterfaceStyle) { }
}

extension LXSwiftView: LXViewSetup {
    @objc open func setupUI() { }
    @objc open func setupViewModel() {}
}
