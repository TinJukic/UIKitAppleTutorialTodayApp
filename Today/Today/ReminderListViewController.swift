//
//  ViewController.swift
//  Today
//
//  Created by Tin Jukic on 17.08.2023..
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    var dataSource: DataSource!

    init() {

        super.init(collectionViewLayout: ReminderListViewController.listLayout())

        view.backgroundColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        let cellRegistration = UICollectionView.CellRegistration {

            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in

            let reminder = Reminder.sampleData[indexPath.item]

            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }

        dataSource = .init(collectionView: collectionView) {

            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        dataSource.apply(snapshot)

        collectionView.dataSource = dataSource
    }

    private static func listLayout() -> UICollectionViewCompositionalLayout {

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)

        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
