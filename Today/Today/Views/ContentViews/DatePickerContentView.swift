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

        addPinnedSubview(datePicker)
    }

    func configure(configuration: UIContentConfiguration) {

        guard let configuration = configuration as? Configuration else { return }

        datePicker.date = configuration.date
    }
}

// MARK: - Configuration Struct

extension DatePickerContentView {

    struct Configuration: UIContentConfiguration {

        var date: Date = .now

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
