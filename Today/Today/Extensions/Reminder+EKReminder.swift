//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Tin on 02.09.2023..
//

import Foundation
import EventKit

extension Reminder {

    init(with ekReminder: EKReminder) throws {

        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {

            throw TodayError.reminderHasNoDueDate
        }

        self.dueDate = dueDate

        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
