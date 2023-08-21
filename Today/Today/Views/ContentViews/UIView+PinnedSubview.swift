//
//  UIView+PinnedSubview.swift
//  Today
//
//  Created by Tin Jukic on 21.08.2023..
//

import UIKit

extension UIView {

    func addPinnedSubview(
        _ subview: UIView,
        height: CGFloat? = nil,
        insets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
    ) {

        subview.translatesAutoresizingMaskIntoConstraints = false

        addSubview(subview)

        NSLayoutConstraint.activate([

            subview.topAnchor.constraint(
                equalTo: subview.superview!.topAnchor,
                constant: insets.top
            ),
            subview.bottomAnchor.constraint(
                equalTo: subview.superview!.bottomAnchor,
                constant: -insets.bottom
            ),
            subview.leadingAnchor.constraint(
                equalTo: subview.superview!.leadingAnchor,
                constant: insets.left
            ),
            subview.trailingAnchor.constraint(
                equalTo: subview.superview!.trailingAnchor,
                constant: -insets.right
            ),
        ])

        if let height {

            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
