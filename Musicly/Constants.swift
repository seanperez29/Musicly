//
//  Constants.swift
//  Musicly
//
//  Created by Sean Perez on 9/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation


class Constants {

    struct SpotifyParameterKeys {
        static let Q = "q"
        static let SearchType = "type"
        static let Limit = "limit"
    }
    
    struct SpotifyParameterValues {
        static let SearchTracks = "track"
        static let SearchLimit = "50"
    }
    
    struct SpotifyJSONKeys {
        static let Name = "name"
        static let PreviewURL = "preview_url"
        static let Artists = "artists"
        static let Album = "album"
        static let Images = "images"
        static let ID = "id"
        static let URL = "url"
        static let Tracks = "tracks"
        static let Items = "items"
    }
    
    struct SpotifyURL {
        static let Scheme = "https"
        static let Host = "api.spotify.com"
        static let Path = "/v1/search"
    }
    
    struct AudioTrack {
        static let ArtistName = "artistName"
        static let SongName = "songName"
        static let MediaURL = "mediaURL"
        static let AlbumURL = "albumURL"
        static let ID = "id"
    }
    
    struct Images {
        static let Checkmark = "CheckEdit"
        static let AddButton = "favoriteditem-1"
        static let FavoritedSuccessful = "check_icon"
        static let FavoritedRemoved = "cancel_btn"
        static let PlayButton = "PlayBtn"
        static let PauseButton = "PauseBtn1"
    }
    
    struct Cells {
        static let SongCell = "SongCell"
        static let CategoriesCell = "CategoriesCell"
        static let SearchCell = "SearchCell"
        static let FavoritesCell = "FavoritesCell"
    }
    
    struct XIBs {
        static let NoSearchResults = "NoSearchResultsFound"
    }
    
    struct Segues {
        static let PlayAudio = "PlayAudio"
        static let PlayFavorite = "PlayFavorite"
        static let PlayFromSongCell = "PlayFromSongCell"
    }

}
