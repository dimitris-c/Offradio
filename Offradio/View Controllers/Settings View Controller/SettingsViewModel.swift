//
//  SettingsViewModel.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

enum SettingsAction: Equatable {
    case load
    case toggle(type: SettingsItemType, indexPath: IndexPath, newValue: Bool)
    case select(type: SettingsItemType, indexPath: IndexPath, newValue: Bool)
    case none
}

protocol SettingsViewModelType {
    func connect(actions: Observable<SettingsAction>) -> Driver<[SettingsSectionModel]>
}

final class SettingsViewModel: SettingsViewModelType {
    
    private let settingsState: SettingsState
    
    private var userSettings: UserSettings
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        self.settingsState = SettingsState(sections: SettingsViewModel.loadSettings(using: userSettings))
    }
    
    func connect(actions: Observable<SettingsAction>) -> Driver<[SettingsSectionModel]> {
        return actions
            .startWith(.load)
            .do(onNext: { [weak self] action in self?.saveToSettings(action: action) })
            .scan(settingsState, accumulator: { (state: SettingsState, action: SettingsAction) -> SettingsState in
                state.execute(state: state, action: action)
            })
            .map { state in
                state.sections
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    private static func loadSettings(using settings: UserSettings) -> [SettingsSectionModel] {
        let isAutomatic = settings.audioStreamQualityAutomatic
        let selectedQuality = OffradioStreamQuality(rawValue: settings.audioStreamQuality) ?? .hd
        
        let qualityItems = [
            SettingsSectionItem.toggable(type: .audioPlayback(type: .automatic), value: isAutomatic),
            SettingsSectionItem.selectable(type: .audioPlayback(type: .hdQuality), value: selectedQuality == .hd, enabled: !isAutomatic),
            SettingsSectionItem.selectable(type: .audioPlayback(type: .sdQuality), value: selectedQuality == .sd, enabled: !isAutomatic)
        ]
        
        return [.audioPlayback(title: "Audio Quality", items: qualityItems)]
    }
    
    func saveToSettings(action: SettingsAction) {
        switch action {
            case .select(let type, _, _):
                if case .audioPlayback = type {
                    self.userSettings.audioStreamQuality = type.playbackType.toStreamQuality().rawValue
                }
            case .toggle(let type, _, let newValue):
                if type.playbackType == .automatic {
                    self.userSettings.audioStreamQualityAutomatic = newValue
                    if !newValue {
                        self.userSettings.audioStreamQuality = SettingsAudioPlaybackType.hdQuality.toStreamQuality().rawValue
                    }
                }
            case .load, .none:
                break
                
        }
    }
}

struct SettingsState {
    private(set) var sections: [SettingsSectionModel]
    
    init(sections: [SettingsSectionModel]) {
        self.sections = sections
    }
    
    func execute(state: SettingsState, action: SettingsAction) -> SettingsState {
        switch action {
            case .load:
                return SettingsState(sections: sections)
            case .select(let type, let indexPath, let newValue):
                if case .audioPlayback = sections[indexPath.section] {
                    return updateAudioPlaybackSelectSection(state: state,
                                                            type: type,
                                                            indexPath: indexPath,
                                                            newValue: newValue)
                }
                return updateSelectable(state: state, type: type, indexPath: indexPath, newValue: newValue)
            case .toggle(let type, let indexPath, let newValue):
                if case .audioPlayback = sections[indexPath.section] {
                    return updateAudioPlaybackToggleSection(state: state, type: type, indexPath: indexPath, newValue: newValue)
                }
                return updateToggable(state: state, type: type, indexPath: indexPath, newValue: newValue)
            case .none:
                return SettingsState(sections: sections)
        }
    }
    
    private func updateAudioPlaybackToggleSection(state: SettingsState,
                                            type: SettingsItemType,
                                            indexPath: IndexPath,
                                            newValue: Bool) -> SettingsState {
        var sections = state.sections
        if case .audioPlayback = sections[indexPath.section] {
            var items = sections[indexPath.section].items
            let item = SettingsSectionItem.toggable(type: type, value: newValue)
            items[indexPath.row] = item
            let audioQualityItems = items.filter({ item -> Bool in
                if case .selectable = item { return true }
                return false
            }).map { item -> SettingsSectionItem in
                if item.type == .audioPlayback(type: .hdQuality) {
                    return .selectable(type: .audioPlayback(type: .hdQuality), value: true, enabled: !newValue)
                }
                return .selectable(type: .audioPlayback(type: .sdQuality), value: false, enabled: !newValue)
            }
            items.replaceSubrange(1..., with: audioQualityItems)
            sections[indexPath.section] = SettingsSectionModel(original: sections[indexPath.section], items: items)
        }
        return SettingsState(sections: sections)
    }
    
    private func updateAudioPlaybackSelectSection(state: SettingsState,
                                                  type: SettingsItemType,
                                                  indexPath: IndexPath,
                                                  newValue: Bool) -> SettingsState {
        var sections = state.sections
        var items = sections[indexPath.section].items
        let selectedItem = SettingsSectionItem.selectable(type: type, value: newValue, enabled: true)

        let audioQualityItems = items.filter({ item -> Bool in
            if case .selectable = item { return true }
            return false
        }).map { item -> SettingsSectionItem in
            if item.type == selectedItem.type {
                return .selectable(type: type, value: true, enabled: true)
            }
            return .selectable(type: item.type, value: false, enabled: true)
        }
        items.replaceSubrange(1..., with: audioQualityItems)
        sections[indexPath.section] = SettingsSectionModel(original: sections[indexPath.section], items: items)
        return SettingsState(sections: sections)
    }
    
    private func updateSelectable(state: SettingsState,
                                  type: SettingsItemType,
                                  indexPath: IndexPath,
                                  newValue: Bool) -> SettingsState {
        var sections = state.sections
        var items = sections[indexPath.section].items
        let selectedItem = SettingsSectionItem.selectable(type: type, value: newValue, enabled: true)
        items[indexPath.row] = selectedItem
        sections[indexPath.section] = SettingsSectionModel(original: sections[indexPath.section], items: items)
        return SettingsState(sections: sections)
    }
    
    private func updateToggable(state: SettingsState,
                                type: SettingsItemType,
                                indexPath: IndexPath,
                                newValue: Bool) -> SettingsState {
        var sections = state.sections
        var items = sections[indexPath.section].items
        let item = SettingsSectionItem.toggable(type: type, value: newValue)
        items[indexPath.row] = item
        sections[indexPath.section] = SettingsSectionModel(original: sections[indexPath.section], items: items)
        return SettingsState(sections: sections)
    }
    
    
}
