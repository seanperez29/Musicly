//
//  FavoritesTableViewCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/25/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    var downloadTask: URLSessionDownloadTask?
    
    func configureCell(_ favoriteTrack: ArtistTrack) {
        artistNameLabel.text = favoriteTrack.artist
        songNameLabel.text = favoriteTrack.song
        if let url = URL(string: favoriteTrack.album) {
            downloadTask = albumImage.loadImageWithURL(url)
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
