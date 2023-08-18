//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Tin Jukic on 18.08.2023..
//

import UIKit

extension ReminderListViewController {

    @objc
    func didPressDoneButton(_ sender: ReminderDoneButton) {

        guard let id = sender.id else {

            return
        }

        completeReminder(withId: id)
    }
}
