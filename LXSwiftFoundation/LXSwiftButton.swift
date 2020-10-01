//
//  LXSwiftButton.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftButton: UIButton, LXSwiftUICompatible {
    /// call back
    public typealias ButtonCallBack = ((_ buton: LXSwiftButton) -> ())
    public var swiftModel: Any?
    public var buttonCallBack: LXSwiftButton.ButtonCallBack?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(swiftButtonAction(_:)), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// private
extension LXSwiftButton {
    
    /// set handle for method call back 
    public func setHandle(_ buttonCallBack: LXSwiftButton.ButtonCallBack?) {
        self.buttonCallBack = buttonCallBack
    }
    
    ///action call
    @objc private func swiftButtonAction(_ button: LXSwiftButton) {
        self.buttonCallBack?(button)
    }
}
