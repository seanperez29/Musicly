//
//  CategoriesCell.swift
//  Musicly
//
//  Created by Sean Perez on 9/26/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CategoriesCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var categories: Category? = nil {
        didSet {
            collectionView.reloadData()
        }
    }
}

//The code associated with the injection of a CollectionView into a TableView in order to allow horizontal scrolling within separate categories was learned from a Robert Chen online tutorial.
extension CategoriesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories!.songs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.SongCell, for: indexPath) as! SongCell
        if let categories = categories {
            cell.artistTrack = categories.songs[indexPath.row]
        }
        return cell
    }
}
