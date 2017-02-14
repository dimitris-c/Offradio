//
//  PlaylistTableViewCell.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import SDWebImage

final class PlaylistTableViewCell: UITableViewCell, ConfigurableCell {
    
    private(set) var item: PlaylistSong!
    
    fileprivate var albumArtwork: UIImageView!
    
    fileprivate var timeLabel: UILabel!
    fileprivate var artistLabel: UILabel!
    fileprivate var songLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.00)
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.clear
        
        self.albumArtwork = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
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
        
        let arranger = VerticalArranger()
        
        arranger.add(SizeObject(type: .Fixed, size: CGSize(width: 0, height: 10)))
        arranger.add(SizeObject(type: .Flexible, view: self.timeLabel))
        arranger.add(SizeObject(type: .Fixed, size: CGSize(width: 0, height: 5)))
        arranger.add(SizeObject(type: .Flexible, view: self.artistLabel))
        arranger.add(SizeObject(type: .Fixed, size: CGSize(width: 0, height: 5)))
        arranger.add(SizeObject(type: .Flexible, view: self.songLabel))
        
        arranger.resizeToFit()
        arranger.arrange()
        
        self.timeLabel.frame.size.width = self.timeLabel.frame.size.width + 5
        self.artistLabel.frame.size.width = self.artistLabel.frame.size.width + 5
        self.songLabel.frame.size.width = self.songLabel.frame.size.width + 5
    }
    
    func configure(with item: PlaylistSong) {
        self.item = item
        
        self.timeLabel.text = self.item.time.uppercased()
        
        do {
            self.artistLabel.text = try self.item.artist.convertHTMLEntities()?.uppercased()
            self.songLabel.text = try self.item.songTitle.convertHTMLEntities()?.uppercased()
        } catch {
            
        }
        
        if let url = URL(string: self.item.imageUrl) {
            self.albumArtwork.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "turn-your-radio-off"))
        }
        
        self.setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumArtwork.sd_cancelCurrentImageLoad()
    }
}
