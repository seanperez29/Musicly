//
//  TracksTableViewCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    var downloadTask: URLSessionDownloadTask?
    
    func configureCell(_ searchResult: Track) {
        artistNameLabel.text = searchResult.artistName
        songNameLabel.text = searchResult.songName
        if let url = URL(string: searchResult.albumURL) {
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
