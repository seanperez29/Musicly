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
    var dataTask: URLSessionDataTask?
    
    var artistTrack: ArtistTrack? = nil {
        didSet {
            if let artistTrack = artistTrack {
                self.artistNameLabel.text = artistTrack.artist
                self.songNameLabel.text = artistTrack.song
                if artistTrack.imageData != nil {
                    let image = UIImage(data: artistTrack.imageData!)
                    albumImage.image = image
                } else {
                    dataTask = SpotifyClient.sharedInstance.getImage(artistTrack.album, completionHandler: { (imageData, errorString) in
                        guard (errorString == nil) else {
                            print("Error downloading image: \(errorString)")
                            return
                        }
                        if let image = UIImage(data: imageData!) {
                            performUIUpdatesOnMain {
                                self.albumImage.image = image
                                if let imageData = UIImagePNGRepresentation(image) {
                                    artistTrack.imageData = imageData
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func prepareForReuse() {
        dataTask?.cancel()
        dataTask = nil
        artistNameLabel.text = nil
        songNameLabel.text = nil
        albumImage.image = nil
    }
    
}
