//
//  TwitterFactoryMessageTests.swift
//  Offradio
//
//  Created by Dimitris C. on 27/07/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import XCTest
@testable import Offradio

class TwitterFactoryMessageTests: XCTestCase {

    let factory = TwitterTitleFactory()

    override func setUp() {

    }

    override func tearDown() {

    }

    func test_FactoryCanCreateATitle () {
        let show = Show("A show", photo: "", largePhoto: "", body: "")
        let current = CurrentTrack(track: "Song", image: "", artist: "Artist", lastFMImageUrl: "")
        let nowplaying = NowPlaying(show: show, current: current)

        let title = factory.title(with: nowplaying)

        XCTAssert(!title.isEmpty)
        XCTAssert(title.contains("A show"))
    }

    func test_FactoryAdaptsItsTitleToFit140Limit() {
        let show = Show("Dimitris", photo: "", largePhoto: "", body: "")
        let current = CurrentTrack(track: "Hello", image: "", artist: "An Artist", lastFMImageUrl: "")
        let nowplaying = NowPlaying(show: show, current: current)

        let title = factory.title(with: nowplaying)

        XCTAssertEqual(title, "I've turned my Radio OFF! Listening to Dimitris #nowplaying An Artist - Hello @offradio")
        XCTAssert(title.count < 140)

        let longShow = Show("Dimitris Chatzieleftheriou", photo: "", largePhoto: "", body: "")
        let longCurrent = CurrentTrack(track: "Hello Sky World", image: "", artist: "An Artist With Long Name", lastFMImageUrl: "")
        let longNowplaying = NowPlaying(show: longShow, current: longCurrent)

        let title2 = factory.title(with: longNowplaying)

        XCTAssertEqual(title2, "I\'ve turned my Radio OFF! Listening to Dimitris Chatzieleftheriou #nowplaying An Artist With Long Name - Hello Sky World @offradio")
        XCTAssert(title2.count < 140)

        let veryLongShow = Show("Dimitris Chatzieleftheriou", photo: "", largePhoto: "", body: "")
        let veryLongCurrent = CurrentTrack(track: "This is way too long Hello Sky World", image: "", artist: "An Artist With Long Name", lastFMImageUrl: "")
        let veryLongNowplaying = NowPlaying(show: veryLongShow, current: veryLongCurrent)

        let title3 = factory.title(with: veryLongNowplaying)

        XCTAssertEqual(title3, "I\'ve turned my Radio OFF! Listening to An Artist With Long Name - This is way too long Hello Sky World #nowplaying @offradio")
        XCTAssert(title3.count < 140)


        let extremelyLongShow = Show("Dimitris Chatzieleftheriou", photo: "", largePhoto: "", body: "")
        let extremelyLongCurrent = CurrentTrack(track: "This is way too long Hello Sky World (With A Long Remix That Beats)", image: "", artist: "An Artist With Long Name", lastFMImageUrl: "")
        let extremelyLongNowplaying = NowPlaying(show: extremelyLongShow, current: extremelyLongCurrent)

        let title4 = factory.title(with: extremelyLongNowplaying)

        XCTAssertEqual(title4, "Listening to An Artist With Long Name - This is way too long Hello Sky World (With A Long Remix That Beats) #nowplaying @offradio")
        XCTAssert(title4.count < 140)
    }

}
