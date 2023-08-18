//
//  ReminderViewController.swift
//  Today
//
//  Created by Tin Jukic on 18.08.2023..
//

import UIKit

class ReminderViewController: UICollectionViewController {

    // typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>

    // variables
    var reminder: Reminder
    private var dataSource: DataSource!

    init(reminder: Reminder) {

        self.reminder = reminder

        super.init(
            collectionViewLayout: ReminderViewController.listLayout()
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = .init(collectionView: collectionView) {

            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        if #available(iOS 16, *) {

            navigationItem.style = .navigator
        }

        navigationItem.title = NSLocalizedString(
            "Reminder",
            comment: "Reminder view controller title"
        )

        updateSnapshot()
    }

    private static func listLayout() -> UICollectionViewLayout {

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

        listConfiguration.showsSeparators = false

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {

        var contentConfiguration = cell.defaultContentConfiguration()

        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = .preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image

        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
    }

    func text(for row: Row) -> String? {

        switch row {

        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        }
    }

    private func updateSnapshot() {

        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems([Row.title, Row.date, Row.time, Row.notes], toSection: 0)

        dataSource.apply(snapshot)
    }
}
