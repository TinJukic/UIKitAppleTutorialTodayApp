//
//  TextFieldContentView.swift
//  Today
//
//  Created by Tin Jukic on 21.08.2023..
//

import UIKit

class TextFieldContentView: UIView, UIContentView {

    let textField = UITextField()
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

        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)

        addPinnedSubview(textField, insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    }

    func configure(configuration: UIContentConfiguration) {

        guard let configuration = configuration as? Configuration else { return }

        textField.text = configuration.text
    }

    @objc
    private func didChange(_ sender: UITextField) {

        guard let configuration = configuration
                as? TextFieldContentView.Configuration else { return }

        configuration.onChange(textField.text ?? "")
    }
}

// MARK: - Configuration Struct

extension TextFieldContentView {

    struct Configuration: UIContentConfiguration {

        var text: String? = ""
        var onChange: (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {

            TextFieldContentView(self)
        }
    }
}

// MARK: - UICollectionViewListCell

extension UICollectionViewListCell {

    func textFieldConfiguration() -> TextFieldContentView.Configuration {

        .init()
    }
}
