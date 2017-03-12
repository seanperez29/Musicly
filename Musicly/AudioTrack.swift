//
//  AudioTrack.swift
//  Musicly
//
//  Created by Sean Perez on 9/21/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class AudioTrack {
    
    private var _artistName: String!
    private var _songName: String!
    private var _mediaURL: String!
    private var _albumURL: String!
    private var _id: String!
    private var _hasFavorited = false
    
    var artistName: String {
        get {
            return _artistName
        } set {
            _artistName = newValue
        }
    }
    var songName: String {
        get {
            return _songName
        } set {
            _songName = newValue
        }
    }
    var mediaURL: String {
        get {
            return _mediaURL
        } set {
            _mediaURL = newValue
        }
    }
    var albumURL: String {
        get {
            return _albumURL
        } set {
            _albumURL = newValue
        }
    }
    var id: String {
        get {
            return _id
        } set {
            _id = newValue
        }
    }
    var hasFavorited: Bool {
        get {
            return _hasFavorited
        } set {
            _hasFavorited = newValue
        }
    }
    
    init(dictionary: [String:AnyObject]) {
        _artistName = dictionary[Constants.AudioTrack.ArtistName] as! String
        _songName = dictionary[Constants.AudioTrack.SongName] as! String
        _mediaURL = dictionary[Constants.AudioTrack.MediaURL] as! String
        _albumURL = dictionary[Constants.AudioTrack.AlbumURL] as! String
        _id = dictionary[Constants.AudioTrack.ID] as! String
    }
    
    func toggleFavorited() {
        _hasFavorited = !_hasFavorited
    }
    
}
