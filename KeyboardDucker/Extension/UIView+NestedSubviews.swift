//
//  UIView+NestedSubviews.swift
//  KeyboardDucking
//
//  Created by Levente Dimény on 2019. 06. 01..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import UIKit

extension UIView {
    internal var nestedSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.nestedSubviews }
    }
}
