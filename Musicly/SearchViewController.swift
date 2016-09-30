//
//  SearchViewController.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var hasSearched = false
    var favorites: Favorited!
    var recentlyPlayed: RecentlyPlayed!
    lazy var recentlyPlayedFetchedResultsController: NSFetchedResultsController<ArtistTrack> = {
        let fetchRequest = NSFetchRequest<ArtistTrack>()
        let entity = ArtistTrack.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "recentlyPlayed == %@", self.recentlyPlayed)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBarText = searchBar.value(forKey: "searchField") as! UITextField
        searchBarText.textColor = UIColor.white
        let cellNib = UINib(nibName: Constants.XIBs.NoSearchResults, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.XIBs.NoSearchResults)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func performRecentlyPlayedFetch() {
        do {
            try recentlyPlayedFetchedResultsController.performFetch()
        } catch {
            fatalError("Could not perform fetch")
        }
    }
        
    func performSearch() {
        searchBar.resignFirstResponder()
        AudioTrackResults.sharedInstance.audioTracks.removeAll(keepingCapacity: true)
        if let searchtext = searchBar.text {
            SpotifyClient.sharedInstance.loadTracks(searchtext, completionHandler: { (result, errorString) in
                guard (errorString == nil) else {
                    self.showAlert(errorString: errorString!)
                    return
                }
                performUIUpdatesOnMain {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    guard let favorite = self.favorites.artistTrack else {
                        print("Unable to obtain favorites array")
                        return
                    }
                    for artistTrack in favorite {
                        for track in AudioTrackResults.sharedInstance.audioTracks {
                            if track.id == (artistTrack as! ArtistTrack).trackID {
                                track.hasFavorited = true
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.PlayAudio {
            let playAudioViewController = segue.destination as! PlayAudioViewController
            let indexPath = sender as! NSIndexPath
            let audioTrack = AudioTrackResults.sharedInstance.audioTracks[indexPath.row]
            let artistTrack = ArtistTrack(audioTrack: audioTrack, context: CoreDataStack.sharedInstance().context)
            recentlyPlayed.addToArtistTrack(artistTrack)
            CoreDataStack.sharedInstance().save()
            playAudioViewController.audioTrack = audioTrack
        }
    }
    
    func showAlert(errorString: String) {
        let alert = UIAlertController(title: errorString, message: "Press okay to dismiss", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        performUIUpdatesOnMain {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension SearchViewController: FavoritesViewControllerDelegate {
    func favoritesViewController(viewController: FavoritesViewController, didDeleteTrack track: ArtistTrack) {
        for artistTrack in AudioTrackResults.sharedInstance.audioTracks {
            if artistTrack.id == track.trackID {
                artistTrack.hasFavorited = false
                tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: AudioTrackTableViewCellDelegate {
    func audioTrackTableViewCell(cell: AudioTrackTableViewCell, didPressFavorited button: UIButton) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = AudioTrackResults.sharedInstance.audioTracks[indexPath.row]
            track.hasFavorited = !track.hasFavorited
            let hudView = HudView.hudInView(view: (tabBarController!.view), animated: true)
            if track.hasFavorited {
                let newArtistTrack = ArtistTrack(audioTrack: track, context: CoreDataStack.sharedInstance().context)
                favorites.addToArtistTrack(newArtistTrack)
                CoreDataStack.sharedInstance().save()
                hudView.text = "Favorited"
                hudView.image = Constants.Images.FavoritedSuccessful
            } else {
                guard let favorite = favorites.artistTrack else {
                    print("Unable to obtain favorites array")
                    return
                }
                for artistTrack in favorite {
                    if (artistTrack as! ArtistTrack).trackID == track.id {
                        CoreDataStack.sharedInstance().context.delete(artistTrack as! NSManagedObject)
                        CoreDataStack.sharedInstance().save()
                    }
                }
                hudView.text = "Removed"
                hudView.image = Constants.Images.FavoritedRemoved
            }
            cell.configureCheckmarkForCell(track: track)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        hasSearched = true
        performSearch()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AudioTrackResults.sharedInstance.audioTracks.count == 0 && hasSearched {
            return 1
        } else {
            return AudioTrackResults.sharedInstance.audioTracks.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if AudioTrackResults.sharedInstance.audioTracks.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: Constants.XIBs.NoSearchResults, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.SearchCell) as! AudioTrackTableViewCell
            let track = AudioTrackResults.sharedInstance.audioTracks[(indexPath as NSIndexPath).row]
            cell.delegate = self
            cell.configureCell(track)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performRecentlyPlayedFetch()
        let audioTracks = recentlyPlayedFetchedResultsController.fetchedObjects!
        if audioTracks.count > 9 {
            let deleteTrack = audioTracks[0]
            CoreDataStack.sharedInstance().context.delete(deleteTrack)
        }
        CoreDataStack.sharedInstance().save()
        performSegue(withIdentifier: Constants.Segues.PlayAudio, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

