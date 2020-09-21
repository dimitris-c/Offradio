//
//  UserSettings.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

protocol UserSettings {
    var audioStreamQuality: String { get set }
    var audioStreamQualityAutomatic: Bool { get set }
}

final class UserSettingsService: UserSettings {
    
    @UserDefault("audio_stream_quality_automatic", defaultValue: true)
    var audioStreamQualityAutomatic: Bool
    
    @UserDefault("audio_stream_quality", defaultValue: OffradioStreamQuality.hd.rawValue)
    var audioStreamQuality: String
    
}
