//
//  UIStackView.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubvies: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubvies)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}

