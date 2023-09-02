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
    var listStyle: ReminderListStyle = .today
    var headerView: ProgressHeaderView?

    var filteredReminders: [Reminder] {
        reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted { $0.dueDate < $1.dueDate }
    }

    var progress: CGFloat {

        let chunkSize = 1.0 / CGFloat(filteredReminders.count)

        let progress = filteredReminders.reduce(0.0) {

            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }

        return progress
    }

    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name,
        ReminderListStyle.future.name,
        ReminderListStyle.all.name,
    ])

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
        collectionView.backgroundColor = .todayGradientFutureBegin

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = .init(collectionView: collectionView) {

            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind,
            handler: supplementaryRegistrationHandler
        )

        dataSource.supplementaryViewProvider = { supplemmentaryView, elementKind, indexPath in

            self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
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

        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl

        if #available(iOS 16, *) {

            navigationItem.style = .navigator
        }

        updateSnapshot()

        collectionView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        refreshBackground()
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {

        let id = filteredReminders[indexPath.item].id

        pushDetailViewForReminder(withId: id)

        return false
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {

        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView else { return }

        progressView.progress = progress
    }

    func pushDetailViewForReminder(withId id: Reminder.ID) {

        let reminder = getReminder(withId: id)

        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in

            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    func refreshBackground() {

        collectionView.backgroundView = nil

        let backgroundView = UIView()
        backgroundView.layer.addSublayer(
            CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        )

        collectionView.backgroundView = backgroundView
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
        listConfiguration.headerMode = .supplementary
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions

        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    private func supplementaryRegistrationHandler(
        progressView: ProgressHeaderView,
        elementKind: String,
        indexPath: IndexPath
    ) {

        headerView = progressView
    }
}
