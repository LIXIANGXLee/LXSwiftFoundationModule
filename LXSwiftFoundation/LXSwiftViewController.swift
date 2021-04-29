//
//  LXUIViewController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit

open class LXSwiftViewController: UIViewController, LXSwiftUICompatible {
    public var swiftModel: Any?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
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
