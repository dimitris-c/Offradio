//
//  WidgetUpdater.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 25/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation
import WidgetKit

enum WidgetKind: String {
    case nowplaying = "NowPlayingWidget"
}

@available(iOS 14.0, *)
final class WidgerUpdater {
    
    func updateAllTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updateTimeline(for kind: WidgetKind) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind.rawValue)
    }
    
}
