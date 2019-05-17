//
//  Shortcuts.swift
//  Offradio
//
//  Created by Dimitris C. on 25/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct Shortcuts {
    func handle(shortcut item: UIApplicationShortcutItem, `for` viewController: OffradioContentViewController) -> Bool {
        var handled = false

        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: item.type) != nil else { return false }
        guard let shortCutType = item.type as String? else { return false }

        switch shortCutType {
        case ShortcutIdentifier.radio.type:
            handled = true
            viewController.turnRadioOn()
        case ShortcutIdentifier.favourites.type:
            handled = true
        case ShortcutIdentifier.playlist.type:
            viewController.showPlaylist()
            handled = true
        case ShortcutIdentifier.schedule.type:
            viewController.showSchedule()
            handled = true
        default:
            break
        }

        return handled
    }
}
