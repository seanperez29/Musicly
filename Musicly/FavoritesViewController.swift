//
//  FavoritesViewController.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import CoreData

protocol FavoritesViewControllerDelegate: class {
    func favoritesViewController(viewController: FavoritesViewController, didDeleteTrack track: ArtistTrack)
}

class FavoritesViewController: UITableViewController {
    
    var favorites: Favorited!
    var recentlyPlayed: RecentlyPlayed!
    weak var delegate: FavoritesViewControllerDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<ArtistTrack> = {
        let fetchRequest = NSFetchRequest<ArtistTrack>()
        let entity = ArtistTrack.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "favorited == %@", self.favorites)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
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

    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
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
        if segue.identifier == Constants.Segues.PlayFavorite {
            var doesTrackExist: Bool!
            let playAudioViewController = segue.destination as! PlayAudioViewController
            let indexPath = sender as! IndexPath
            let artistTrack = fetchedResultsController.object(at: indexPath)
            let recentlyPlayedTracks = recentlyPlayedFetchedResultsController.fetchedObjects!
            for track in recentlyPlayedTracks {
                if track.trackID == artistTrack.trackID {
                    doesTrackExist = true
                    break
                } else {
                    doesTrackExist = false
                }
            }
            if recentlyPlayedTracks.count == 0 || doesTrackExist == false {
                recentlyPlayed.addToArtistTrack(artistTrack)
                CoreDataStack.sharedInstance().save()
            }
            playAudioViewController.artistTrack = artistTrack
        }
    }

}

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.FavoritesCell, for: indexPath) as! FavoritesTableViewCell
        let artistTrack = fetchedResultsController.object(at: indexPath)
        cell.configureCell(artistTrack)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artistTrack = fetchedResultsController.object(at: indexPath)
            delegate?.favoritesViewController(viewController: self, didDeleteTrack: artistTrack)
            CoreDataStack.sharedInstance().context.delete(artistTrack)
            CoreDataStack.sharedInstance().save()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ReachabilityConvenience.sharedInstance.performReachability { (hasConnection) in
            if hasConnection {
                self.performRecentlyPlayedFetch()
                let audioTracks = self.recentlyPlayedFetchedResultsController.fetchedObjects!
                if audioTracks.count > 9 {
                    let deleteTrack = audioTracks[0]
                    CoreDataStack.sharedInstance().context.delete(deleteTrack)
                }
                CoreDataStack.sharedInstance().save()
                performUIUpdatesOnMain {
                    self.performSegue(withIdentifier: Constants.Segues.PlayFavorite, sender: indexPath)
                }
            } else {
                let alert = showAlert(errorString: "Unable to obtain internet access")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? FavoritesTableViewCell {
                let artistTrack = controller.object(at: indexPath!) as! ArtistTrack
                cell.configureCell(artistTrack)
            }
            
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }

}
