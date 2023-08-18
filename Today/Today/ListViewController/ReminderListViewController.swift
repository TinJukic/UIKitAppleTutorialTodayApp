//
//  ViewController.swift
//  Today
//
//  Created by Tin Jukic on 17.08.2023..
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData

    init() {

        super.init(collectionViewLayout: ReminderListViewController.listLayout())

        view.backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = .init(collectionView: collectionView) {

            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        updateSnapshot()

        collectionView.dataSource = dataSource
    }

    private static func listLayout() -> UICollectionViewCompositionalLayout {

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)

        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
