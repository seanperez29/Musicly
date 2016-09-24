//
//  TracksTableViewCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

protocol TracksTableViewCellDelegate: class {
    func trackTableViewCell(cell: TracksTableViewCell, didPressFavorited button: UIButton)
}

class TracksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var downloadTask: URLSessionDownloadTask?
    weak var delegate: TracksTableViewCellDelegate?
    
    func configureCell(_ searchResult: Track) {
        artistNameLabel.text = searchResult.artistName
        songNameLabel.text = searchResult.songName
        if let url = URL(string: searchResult.albumURL) {
            downloadTask = albumImage.loadImageWithURL(url)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
        delegate?.trackTableViewCell(cell: self, didPressFavorited: sender as! UIButton)
    }
    
    func configureCheckmarkForCell(track: Track) {
        if track.hasFavorited {
            favoriteButton.setImage(UIImage(named: "favoriteditemenabled-1"), for: .normal)
        } else {
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
