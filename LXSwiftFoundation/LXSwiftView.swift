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

@objc public protocol LXViewSetup: NSObjectProtocol {
    @objc optional func setupUI()
    @objc optional func setupViewModel()
    
}

open class LXSwiftView: UIView,LXSwiftUICompatible {
    
    public var swiftModel: Any?
    
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
    open func setupUI() { }
    open func setupViewModel() {}
    
}
