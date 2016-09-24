//
//  AudioTrackTableViewCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

protocol AudioTrackTableViewCellDelegate: class {
    func audioTrackTableViewCell(cell: AudioTrackTableViewCell, didPressFavorited button: UIButton)
}

class AudioTrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var downloadTask: URLSessionDownloadTask?
    weak var delegate: AudioTrackTableViewCellDelegate?
    
    func configureCell(_ searchResult: AudioTrack) {
        artistNameLabel.text = searchResult.artistName
        songNameLabel.text = searchResult.songName
        if let url = URL(string: searchResult.albumURL) {
            downloadTask = albumImage.loadImageWithURL(url)
        }
        configureCheckmarkForCell(track: searchResult)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
        delegate?.audioTrackTableViewCell(cell: self, didPressFavorited: sender as! UIButton)
    }
    
    func configureCheckmarkForCell(track: AudioTrack) {
        if track.hasFavorited {
            favoriteButton.alpha = 1
            favoriteButton.setImage(UIImage(named: "CheckEdit"), for: .normal)
        } else {
            favoriteButton.alpha = 0.5
            favoriteButton.setImage(UIImage(named: "favoriteditem-1"), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
        artistNameLabel.text = nil
        songNameLabel.text = nil
        albumImage.image = nil
    }
}