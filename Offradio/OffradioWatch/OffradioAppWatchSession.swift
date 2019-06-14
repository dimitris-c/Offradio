//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 26/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity
import SwiftyJSON
import RxSwift
import Moya

class OffradioAppWatchSession: NSObject, WCSessionDelegate {

    var disposeBag: DisposeBag? = DisposeBag()
    var radio: Offradio!
    var viewModel: RadioViewModel!
    let playlistService = MoyaProvider<PlaylistService>()
    let playlistFavouritesLayer = PlaylistFavouritesLayer()

    init(with radio: Offradio, andViewModel model: RadioViewModel) {
        super.init()
        self.radio = radio
        self.viewModel = model
    }

    func activate() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        self.parseMessage(with: message)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        let application = UIApplication.shared
        var identifier = UIBackgroundTaskIdentifier.invalid
        let endBlock = {
            if identifier != UIBackgroundTaskIdentifier.invalid {
                application.endBackgroundTask(identifier)
            }
            identifier = UIBackgroundTaskIdentifier.invalid
        }

        identifier = application.beginBackgroundTask(expirationHandler: endBlock)

        let replyHandler = { (replyInfo: [String: Any]) in
            replyHandler(replyInfo)
            endBlock()
        }

        self.parseMessage(with: message, andReply: replyHandler)
    }

    func sessionDidDeactivate(_ session: WCSession) {
        self.activate()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    fileprivate func parseMessage(with message: [String: Any]) {

    }
    // swiftlint:disable cyclomatic_complexity
    fileprivate func parseMessage(with message: [String: Any], andReply reply: @escaping ([String: Any]) -> Void) {
        print("Message \(message)")
        guard let actionString = message["action"] as? String else { return }
        guard let action = OffradioWatchAction(rawValue: actionString) else { return }

        switch action {
        case .toggleRadio:
            let data: Bool = message["data"] as? Bool ?? false
            self.toggleRadio(with: data)
            reply(["": ""])
        case .radioStatus:
            self.radioStatus(withReply: { (state) in
                reply(["action": OffradioWatchAction.radioStatus.rawValue, "data": state.rawValue])
            })
        case .currentTrack:
            self.fetchCurrentTrack(withReply: { track in
                let data = track.toDictionary()
                reply(["action": OffradioWatchAction.currentTrack.rawValue, "data": data])
            })
        case .currentShow:
            self.fetchCurrentShow(withReply: { show in
                let data = show.toDictionary()
                reply(["action": OffradioWatchAction.currentShow.rawValue, "data": data])
            })
        case .playlist:
            self.fetchPlaylist(withReply: { songs in
                var data: [[String: Any]] = []
                for song in songs {
                    data.append(song.toDictionary())
                }
                reply(["action": OffradioWatchAction.playlist.rawValue, "data": data])
            })
        case .toggleFavourite:
            if let data = message["data"] as? [String: Any] {
                let track = CurrentTrack(json: JSON(data))
                let isAlreadyFavourite = self.isAlreadyFavourited(with: track)
                reply(["action": OffradioWatchAction.favouriteStatus.rawValue, "data": ["isFavourite": !isAlreadyFavourite]])

            }
        case .favouriteStatus:
            let data = message["data"] as? [String: Any]
            if let artist = data?["artist"] as? String, let title = data?["track"] as? String {
                let isFavourite: Bool = playlistFavouritesLayer.isFavourite(for: artist,
                                                                            songTitle: title)
                reply(["action": OffradioWatchAction.favouriteStatus.rawValue, "data": ["isFavourite": isFavourite]])
            } else {
                reply(["action": OffradioWatchAction.favouriteStatus.rawValue, "data": ["isFavourite": false]])
            }
        }
    }

    fileprivate func isAlreadyFavourited(with track: CurrentTrack) -> Bool {
        let isAlreadyFavourite: Bool = playlistFavouritesLayer.isFavourite(for: track.artist, songTitle: track.track)
        if !isAlreadyFavourite {
            try? self.playlistFavouritesLayer.createFavourite(with: track.toPlaylistSong())
        } else {
            try? self.playlistFavouritesLayer.deleteFavourite(for: track.artist, songTitle: track.track)
        }

        return isAlreadyFavourite
    }

    fileprivate func toggleRadio(with status: Bool) {
        if status {
            self.viewModel.toggleRadioTriggered.onNext(true)
        } else {
            self.viewModel.toggleRadioTriggered.onNext(false)
        }
    }

    fileprivate func radioStatus(withReply reply: (RadioState) -> Void) {
        reply(self.radio.status)
    }

    fileprivate func fetchPlaylist(withReply reply: @escaping ([Song]) -> Void) {
        let disposable = self.playlistService.rx.request(.playlist(page: 0))
            .mapJSON()
            .map { data -> [Song] in
                let json = JSON(data)
                let playlist: [Song] = json["playlist"].arrayValue
                    .map(Song.init(with:))
                return playlist
            }
            .catchErrorJustReturn([])
            .asObservable()
            .take(1)
            .subscribe(onNext: { songs in
                reply(songs)
            })
        disposeBag?.insert(disposable)
    }

    fileprivate func fetchCurrentTrack(withReply reply: @escaping (CurrentTrack) -> Void) {
        let disposable = self.radio.metadata.fetchNowPlaying().asObservable()
            .catchErrorJustReturn(NowPlaying.empty)
            .map { $0.current }
            .subscribe(onNext: { track in
                reply(track)
            }, onCompleted: { [weak self] in
                self?.disposeBag = nil
            })
        disposeBag?.insert(disposable)
    }

    fileprivate func fetchCurrentShow(withReply reply: @escaping (Show) -> Void) {
        let disposable = self.radio.metadata.fetchNowPlaying().asObservable()
            .catchErrorJustReturn(NowPlaying.empty)
            .map { $0.show }
            .subscribe(onNext: { show in
                reply(show)
            }, onCompleted: { [weak self] in
                self?.disposeBag = nil
            })
        disposeBag?.insert(disposable)
    }
}
