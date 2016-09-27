//
//  SongCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/26/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class SongCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    var downloadTask: URLSessionDownloadTask?
    
    var artistTrack: ArtistTrack? = nil {
        didSet {
            if let artistTrack = artistTrack {
                self.artistNameLabel.text = artistTrack.artist
                self.songNameLabel.text = artistTrack.song
                if let url = URL(string: artistTrack.album) {
                    downloadTask = albumImage.loadImageWithURL(url)
                }
            }
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
