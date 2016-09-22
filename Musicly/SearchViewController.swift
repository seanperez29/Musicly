//
//  SearchViewController.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "NoSearchResultsFound", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NoSearchResultsFound")
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func performSearch() {
        searchBar.resignFirstResponder()
        TrackResults.sharedInstance.tracks.removeAll(keepingCapacity: true)
        if let searchtext = searchBar.text {
            SpotifyClient.sharedInstance.loadTracks(searchtext, completionHandler: { (result, errorString) in
                guard (errorString == nil) else {
                    print(errorString)
                    return
                }
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hasSearched = true
        performSearch()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TrackResults.sharedInstance.tracks.count == 0 && hasSearched {
            return 1
        } else {
            return TrackResults.sharedInstance.tracks.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  TrackResults.sharedInstance.tracks.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "NoSearchResultsFound", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TracksTableViewCell
            let track = TrackResults.sharedInstance.tracks[(indexPath as NSIndexPath).row]
            cell.configureCell(track)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



