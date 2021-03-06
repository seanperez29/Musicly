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
    var dataTask: URLSessionDataTask?
    
    func configureCell(_ favoriteTrack: ArtistTrack) {
        if favoriteTrack.imageData != nil {
            let image = UIImage(data: favoriteTrack.imageData!)
            albumImage.image = image
            artistNameLabel.text = favoriteTrack.artist
            songNameLabel.text = favoriteTrack.song
        } else {
            artistNameLabel.text = favoriteTrack.artist
            songNameLabel.text = favoriteTrack.song
            print(favoriteTrack.album)
            dataTask = SpotifyClient.sharedInstance.getImage(favoriteTrack.album) { (imageData, errorString) in
                guard (errorString == nil) else {
                    print("Error downloading image: \(errorString!)")
                    return
                }
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain {
                        self.albumImage.image = image
                        if let imageData = UIImagePNGRepresentation(image) {
                            favoriteTrack.imageData = imageData
                        }
                    }
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
