//
//  ReminderStore.swift
//  Today
//
//  Created by Tin on 02.09.2023..
//

import Foundation
import EventKit

final class ReminderStore {

    static let shared = ReminderStore() // singleton

    private let ekStore = EKEventStore()

    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }

    func requestAccess() async throws {

        let status = EKEventStore.authorizationStatus(for: .reminder)

        switch status {
        case .authorized:
            return
        case .restricted:
            throw TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else { throw TodayError.accessDenied }
        case .denied:
            throw TodayError.accessDenied
        @unknown default:
            throw TodayError.unknown
        }
    }

    func readAll() async throws -> [Reminder] {

        guard isAvailable else { throw TodayError.accessDenied }

        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)

        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in

            do {

                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {

                return nil
            }
        }

        return reminders
    }

    func remove(with id: Reminder.ID) throws {

        guard isAvailable else { throw TodayError.accessDenied }

        let ekReminder = try read(with: id)

        try ekStore.remove(ekReminder, commit: true)
    }

    @discardableResult
    func save(_ reminder: Reminder) throws -> Reminder.ID {

        guard isAvailable else { throw TodayError.accessDenied }

        let ekReminder: EKReminder

        do {
            ekReminder = try read(with: reminder.id)
        } catch {
            ekReminder = .init(eventStore: ekStore)
        }

        ekReminder.update(using: reminder, in: ekStore)

        try ekStore.save(ekReminder, commit: true)

        return ekReminder.calendarItemIdentifier
    }

    private func read(with id: Reminder.ID) throws -> EKReminder {

        guard let ekReminder =
                ekStore.calendarItem(withIdentifier: id) as? EKReminder else {
            throw TodayError.failedReadingCalendarItem
        }

        return ekReminder
    }
}
