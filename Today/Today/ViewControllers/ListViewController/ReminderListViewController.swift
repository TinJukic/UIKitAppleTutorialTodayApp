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

        super.init(collectionViewLayout: .init())

        view.backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        collectionView.collectionViewLayout = listLayout()

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = .init(collectionView: collectionView) {

            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton)
        )
        addButton.accessibilityLabel = NSLocalizedString(
            "Add reminder",
            comment: "Add button accessibility label"
        )

        navigationItem.rightBarButtonItem = addButton

        if #available(iOS 16, *) {

            navigationItem.style = .navigator
        }

        updateSnapshot()

        collectionView.dataSource = dataSource
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {

        let id = reminders[indexPath.item].id

        pushDetailViewForReminder(withId: id)

        return false
    }

    func pushDetailViewForReminder(withId id: Reminder.ID) {

        let reminder = getReminder(withId: id)

        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in

            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {

        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")

        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {

            [weak self] _, _, completion in

            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
        }

        return .init(actions: [deleteAction])
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {

        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)

        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
