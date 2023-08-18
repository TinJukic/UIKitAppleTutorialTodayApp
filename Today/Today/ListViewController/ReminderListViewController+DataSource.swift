//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Tin Jukic on 17.08.2023..
//

import UIKit

extension ReminderListViewController {

    // MARK: - Typealias

    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>

    // MARK: - Computed Properties

    var reminderCompletedValue: String {

        NSLocalizedString("Completed", comment: "Reminder completed value")
    }

    var reminderNotCompletedValue: String {

        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }

    // MARK: - Functions

    func updateSnapshot(reloading ids: [Reminder.ID] = []) {

        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })

        if !ids.isEmpty {

            snapshot.reloadItems(ids)
        }

        dataSource.apply(snapshot)
    }

    func cellRegistrationHandler(
        cell: UICollectionViewListCell,
        indexPath: IndexPath,
        id: Reminder.ID
    ) {

        let reminder = getReminder(withId: id)

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint

        cell.accessibilityCustomActions = [

            doneButtonAccessibilityAction(for: reminder)
        ]

        cell.accessibilityValue = reminder.isComplete ?
                                  reminderCompletedValue :
                                  reminderNotCompletedValue

        cell.accessories = [

            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]

        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }

    func getReminder(withId id: Reminder.ID) -> Reminder {

        let index = reminders.indexOfReminder(withId: id)

        return reminders[index]
    }

    func updateReminder(_ reminder: Reminder) {

        let index = reminders.indexOfReminder(withId: reminder.id)

        reminders[index] = reminder
    }

    func completeReminder(withId id: Reminder.ID) {

        var reminder = getReminder(withId: id)

        reminder.isComplete.toggle()

        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }

    private func doneButtonAccessibilityAction(
        for reminder: Reminder
    ) -> UIAccessibilityCustomAction {

        let name = NSLocalizedString(
            "Toggle completion",
            comment: "Reminder done button accessibility label"
        )

        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in

            self?.completeReminder(withId: reminder.id)

            return true
        }

        return action
    }

    private func doneButtonConfiguration(
        for reminder: Reminder
    ) -> UICellAccessory.CustomViewConfiguration {

        // necessary variables
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()

        button.id = reminder.id
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didPressDoneButton), for: .touchUpInside)

        return UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .leading(displayed: .always)
        )
    }
}