//
//  DatePickerContentView.swift
//  Today
//
//  Created by Tin Jukic on 21.08.2023..
//

import UIKit

class DatePickerContentView: UIView, UIContentView {

    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {

        didSet {

            configure(configuration: configuration)
        }
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

        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)

        addPinnedSubview(datePicker)
    }

    func configure(configuration: UIContentConfiguration) {

        guard let configuration = configuration as? Configuration else { return }

        datePicker.date = configuration.date
    }

    @objc
    private func didPick(_ sender: UIDatePicker) {

        guard let configuration = configuration
                as? DatePickerContentView.Configuration else { return }

        configuration.onChange(sender.date)
    }
}

// MARK: - Configuration Struct

extension DatePickerContentView {

    struct Configuration: UIContentConfiguration {

        var date: Date = .now
        var onChange: (Date) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {

            DatePickerContentView(self)
        }
    }
}

// MARK: - UICollectionViewListCell

extension UICollectionViewListCell {

    func datePickerConfiguration() -> DatePickerContentView.Configuration {

        .init()
    }
}
