//
//  TextViewContentView.swift
//  Today
//
//  Created by Tin Jukic on 21.08.2023..
//

import UIKit

class TextViewContentView: UIView, UIContentView {

    let textView = UITextView()
    var configuration: UIContentConfiguration {

        didSet {

            configure(configuration: configuration)
        }
    }

    override var intrinsicContentSize: CGSize {

        .init(width: 0, height: 44)
    }

    init(_ configuration: UIContentConfiguration) {

        self.configuration = configuration

        super.init(frame: .zero)

        addViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Adds all necessary views
    private func addViews() {

        textView.delegate = self
        textView.backgroundColor = nil
        textView.font = .preferredFont(forTextStyle: .body)

        addPinnedSubview(textView, height: 200)
    }

    func configure(configuration: UIContentConfiguration) {

        guard let configuration = configuration as? Configuration else { return }

        textView.text = configuration.text
    }
}

// MARK: - Configuration Struct

extension TextViewContentView {

    struct Configuration: UIContentConfiguration {

        var text: String? = ""
        var onChange: (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {

            TextViewContentView(self)
        }
    }
}

// MARK: - UICollectionViewListCell

extension UICollectionViewListCell {

    func textViewConfiguration() -> TextViewContentView.Configuration {

        .init()
    }
}

// MARK: - UITextViewDelegate

extension TextViewContentView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        guard let configuration = configuration
                as? TextViewContentView.Configuration else { return }

        configuration.onChange(textView.text)
    }
}
