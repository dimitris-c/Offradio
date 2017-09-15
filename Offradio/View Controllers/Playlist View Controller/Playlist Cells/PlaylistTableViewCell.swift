//
//  PlaylistTableViewCell.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SwipeCellKit

final class PlaylistTableViewCell: SwipeTableViewCell, ConfigurableCell {
    fileprivate var disposeBag: DisposeBag?

    private(set) var viewModel: PlaylistCellViewModel!

    private(set) var item: PlaylistSong!

    fileprivate var albumArtwork: UIImageView!

    fileprivate var timeLabel: UILabel!
    fileprivate var artistLabel: UILabel!
    fileprivate var songLabel: UILabel!

    fileprivate var favouriteButton: UIButton!

    // This cell is shared both on Playlist and on Favourites view controllers
    // The boolean below changes the layout for each case.
    var shownInFavouritesList: Bool = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.00)
        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor.clear

        self.albumArtwork = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        self.albumArtwork.image = UIImage(named: "artwork-image-placeholder")
        self.contentView.addSubview(self.albumArtwork)

        self.timeLabel = UILabel(frame: .zero)
        self.timeLabel.textColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.00)
        self.timeLabel.font = UIFont.letterGothicBold(withSize: 14)
        self.contentView.addSubview(self.timeLabel)

        self.artistLabel = UILabel(frame: .zero)
        self.artistLabel.textColor = UIColor.white
        self.artistLabel.font = UIFont.leagueGothicItalic(withSize: 25)
        self.artistLabel.textAlignment = .left
        self.artistLabel.lineBreakMode = .byWordWrapping
        self.artistLabel.numberOfLines = 2
        self.contentView.addSubview(self.artistLabel)

        self.songLabel = UILabel(frame: .zero)
        self.songLabel.font = UIFont.leagueGothicItalic(withSize: 20)
        self.songLabel.textAlignment = .left
        self.songLabel.lineBreakMode = .byWordWrapping
        self.songLabel.textColor = UIColor.white
        self.songLabel.numberOfLines = 3
        self.contentView.addSubview(self.songLabel)

        self.favouriteButton = UIButton(type: .custom)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon"), for: .normal)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon"), for: .highlighted)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon-added"), for: .selected)
        let shadow = Shadow(color: UIColor.black, offset: CGSize.zero, radius: 5, opacity: 0.3)
        self.favouriteButton.applyShadow(with: shadow)
        self.contentView.addSubview(self.favouriteButton)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let bottomPadding: CGFloat = 5
        let actualHeight = self.contentView.frame.height - bottomPadding
        self.albumArtwork.frame.size = CGSize(width: actualHeight, height: actualHeight)

        let labelsMinX: CGFloat = self.albumArtwork.frame.maxX + 10
        let labelsMinY: CGFloat = 5

        self.timeLabel.frame.origin = CGPoint(x: labelsMinX, y: labelsMinY)
        self.artistLabel.frame.origin.x = labelsMinX
        self.songLabel.frame.origin.x = labelsMinX

        self.timeLabel.frame.size.width = self.contentView.frame.width - self.timeLabel.frame.minX
        self.artistLabel.frame.size.width = self.contentView.frame.width - self.artistLabel.frame.minX
        self.songLabel.frame.size.width = self.contentView.frame.width - self.songLabel.frame.minX

        var arranger = VerticalArranger()

        if !shownInFavouritesList {
            arranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 10)))
            arranger.add(object: SizeObject(type: .flexible, view: self.timeLabel))
        }
        arranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        arranger.add(object: SizeObject(type: .flexible, view: self.artistLabel))
        arranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        arranger.add(object: SizeObject(type: .flexible, view: self.songLabel))

        arranger.resizeToFit()
        arranger.arrange()

        self.timeLabel.frame.size.width += 5
        self.artistLabel.frame.size.width += 5
        self.songLabel.frame.size.width += 5

        self.favouriteButton.sizeToFit()
        self.favouriteButton.frame.origin.x = self.albumArtwork.frame.minX + 5
        self.favouriteButton.frame.origin.y = self.albumArtwork.frame.minY + 5
    }

    func configure(with viewModel: PlaylistCellViewModel) {
        self.viewModel = viewModel
        self.item = self.viewModel.item

        self.disposeBag = DisposeBag()

        self.timeLabel.text = self.item.time.uppercased()

        self.artistLabel.text = self.item.artist.uppercased()
        self.songLabel.text = self.item.songTitle.uppercased()

        if let url = URL(string: self.item.imageUrl) {
            self.albumArtwork.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "artwork-image-placeholder"))
        }

        self.viewModel.initialise(with: self.favouriteButton.rx.tap.asDriver().scan(false) { state, _ in !state })

        let disposable = self.viewModel.favourited.asObservable().bind(to: self.favouriteButton.rx.isSelected)
        self.disposeBag?.insert(disposable)

        if shownInFavouritesList {
            self.timeLabel.isHidden = true
        }

        self.setNeedsLayout()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
        self.viewModel.disposeBag = nil
        self.favouriteButton.isSelected = false
        self.timeLabel.isHidden = false
        self.albumArtwork.kf.cancelDownloadTask()
    }
}
