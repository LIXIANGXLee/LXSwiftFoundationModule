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
    internal var buttonCallBack: LXSwiftButton.ButtonCallBack?
    
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
    
    ///action call
    @objc private func swiftButtonAction(_ button: LXSwiftButton) {
        self.buttonCallBack?(button)
    }
}
