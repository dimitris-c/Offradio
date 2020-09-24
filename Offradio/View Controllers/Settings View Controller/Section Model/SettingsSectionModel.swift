//
//  SectionModel.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import RxDataSources

enum SettingsSectionModel: SectionModelType, Equatable {
    case audioPlayback(title: String, items: [SettingsSectionItem])
    
    var items: [SettingsSectionItem] {
        switch self {
            case .audioPlayback(_, let items):
                return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
            case .audioPlayback(let title, _):
                return title
        }
    }
    
    init(original: SettingsSectionModel, items: [SettingsSectionItem]) {
        switch original {
            case .audioPlayback(let title, _):
                self = .audioPlayback(title: title, items: items)
        }
    }
    
}

enum SettingsSectionItem: Equatable {
    case toggable(type: SettingsItemType, value: Bool)
    case selectable(type: SettingsItemType, value: Bool, enabled: Bool)
    
    var type: SettingsItemType {
        switch self {
            case .toggable(let type, _):
                return type
            case .selectable(let type, _, _):
                return type
        }
    }
    
    func with(enabled: Bool) -> SettingsSectionItem {
        switch self {
            case .selectable(let type, let newValue, _):
                return .selectable(type: type, value: newValue, enabled: enabled)
            default:
                return self
        }
    }
}

enum SettingsItemType: Equatable {
    case audioPlayback(type: SettingsAudioPlaybackType)
    
    var title: String {
        switch self {
            case .audioPlayback(let type):
                return type.title
        }
    }
    
    var playbackType: SettingsAudioPlaybackType {
        switch self {
            case .audioPlayback(let type):
                return type
        }
    }
}

enum SettingsAudioPlaybackType: Equatable {
    case automatic
    case hdQuality
    case sdQuality
    
    var title: String {
        switch self {
            case .automatic:
                return "Automatic"
            case .hdQuality:
                return "HD Quality"
            case .sdQuality:
                return "SD Quality"
        }
    }
}

extension SettingsAudioPlaybackType {
    func toStreamQuality() -> OffradioStreamQuality {
        switch self {
            case .automatic: return .hd
            case .hdQuality: return .hd
            case .sdQuality: return .sd
        }
    }
}
