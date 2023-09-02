//
//  ProgressHeaderView.swift
//  Today
//
//  Created by Tin on 02.09.2023..
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {

    static var elementKind: String { UICollectionView.elementKindSectionHeader }

    var progress: CGFloat = 0.0 {
        didSet {

            setNeedsLayout()

            heightConstraint?.constant = progress * bounds.height

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }

    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)

    private var heightConstraint: NSLayoutConstraint?

    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        prepareSubviews()

        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility label")
        accessibilityTraits.update(with: .updatesFrequently)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        accessibilityValue = .init(format: valueFormat, Int(progress * 100.0))

        heightConstraint?.constant = progress * bounds.height

        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
}

// MARK: - Helper Functions

extension ProgressHeaderView {

    private func prepareSubviews() {

        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .todayProgressUpperBackground
        lowerView.backgroundColor = .todayProgressLowerBackground

        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)

        NSLayoutConstraint.activate([

            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1),

            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            upperView.topAnchor.constraint(equalTo: topAnchor),
            upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: trailingAnchor),

            lowerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }
}
