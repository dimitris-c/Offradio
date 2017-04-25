//
//  Shortcuts.swift
//  Offradio
//
//  Created by Dimitris C. on 25/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct Shortcuts {
    func handle(shortcut item: UIApplicationShortcutItem, `for` viewController: OffradioContentViewController) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: item.type) != nil else { return false }
        guard let shortCutType = item.type as String? else { return false }
        
        switch (shortCutType) {
        case ShortcutIdentifier.radio.type:
            handled = true
            viewController.turnRadioOn()
            break
        case ShortcutIdentifier.favourites.type:
            handled = true
            break
        case ShortcutIdentifier.playlist.type:
            viewController.showPlaylist()
            handled = true
            break
        case ShortcutIdentifier.schedule.type:
            viewController.showSchedule()
            handled = true
            break
        default:
            break
        }
        
        return handled
    }
}
