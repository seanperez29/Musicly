//
//  HomeViewController.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class HomeViewController: UIViewController {
    
    var favorites: Favorited!
    var recentlyPlayed: RecentlyPlayed!
    @IBOutlet weak var tableView: UITableView!
    lazy var favoritedFetchedResultsController: NSFetchedResultsController<ArtistTrack> = {
        let fetchRequest = NSFetchRequest<ArtistTrack>()
        let entity = ArtistTrack.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "favorited == %@", self.favorites)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    lazy var recentlyPlayedFetchedResultsController: NSFetchedResultsController<ArtistTrack> = {
        let fetchRequest = NSFetchRequest<ArtistTrack>()
        let entity = ArtistTrack.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "recentlyPlayed == %@", self.recentlyPlayed)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        performFavoritedFetch()
        performRecentlyPlayedFetch()
        let favorites = Category(name: "Favorites", songs: favoritedFetchedResultsController.fetchedObjects!)
        let recentlyPlayed = Category(name: "Recently Played", songs: recentlyPlayedFetchedResultsController.fetchedObjects!)
        Catalog.sharedInstance.categories = [favorites, recentlyPlayed]
        tableView.reloadData()
    }
    
    func performFavoritedFetch() {
        do {
            try favoritedFetchedResultsController.performFetch()
        } catch {
            fatalError("Could not perform fetch")
        }
    }
    func performRecentlyPlayedFetch() {
        do {
            try recentlyPlayedFetchedResultsController.performFetch()
        } catch {
            fatalError("Could not perform fetch")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let songCell = sender as? SongCell, let playAudioViewController = segue.destination as? PlayAudioViewController {
            let artistTrack = songCell.artistTrack
            playAudioViewController.artistTrack = artistTrack
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Catalog.sharedInstance.categories.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Catalog.sharedInstance.categories[section].name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.CategoriesCell) as! CategoriesCell
        cell.categories = Catalog.sharedInstance.categories[indexPath.section]
        return cell
    }
}
