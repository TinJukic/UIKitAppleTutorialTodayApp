//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Tin Jukic on 18.08.2023..
//

import UIKit

extension ReminderViewController {

    enum Row: Hashable {

        case date
        case notes
        case time
        case title

        var imageName: String? {

            switch self {

            case .date: return "calendar.circle"
            case .notes: return "square.and.pencil"
            case .time: return "clock"
            case .title: return nil
            }
        }

        var image: UIImage? {

            guard let imageName else { return nil }

            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)

            return .init(systemName: imageName, withConfiguration: configuration)
        }

        var textStyle: UIFont.TextStyle {

            switch self {

            case .title: return .headline
            case .date, .notes, .time: return .subheadline  // more expressive
            // OR -> default: return .subheadline
            }
        }
    }
}
