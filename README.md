# Musicly

Musicly is a Udacity student project developed in order to display skills learned and acquired throughout the length of the 
iOS Developer course. This app has been designed and developed by inspiration obtained from the Spotify app currently on the 
Apple App Store. It also utilizes the Spotify API in order to acquire search results from user input within the Musicly app.

## Usage

Musicly is separated into three tabbed sections and their associated scenes can be accessed upon tapping the appropriate tab 
near the bottom of the screen:

* Search Scene - From the 'Search Scene' the user has the ability to enter any artist's name, song, or album and obtain a list 
of tracks in return. From here the user has the ability to listen to a 30 second preview of the song by clicking on the cell 
directly, as well as determine if they would like to click the add button at the end of the table view cell in order to add 
the track to their favorites. The search results will all be linked to what songs are currently in the users favorites and 
will show a checkmark if the user already has that track in their favorites, or and add button will be displayed if it is not. 
The user can simply click this button to both add, as well as remove, any track from their favorites list.
* Favorites Scene - This scene will display a table view with all of the tracks the user has favorited. The user can also 
listen to a 30 second preview from this scene, as well as swipe to delete a song from their favorites list. In order to obtain 
more features from the Spotify API, including full length songs, a user would need a paid Spotify Premium account. Therefore, 
this app has maintained the features accessible without requiring such account.
* Home Scene - From this scene the user can swipe through horizontal collection views that have been separated into two 
categories (Favorites and Recently Played). The 'Recently Played' category will display songs that were clicked on from the 
Search Scene's search results only, as the users favorites will already be in the favorites list and will not need to be 
duplicated in the recently played list. The user can browse through these categories and click on the collection view cells in 
order to listen to a 30 second preview of any track.
* Play Audio Scene - This is the scene that will be displayed if a user were to select a song from any of the above scenes. 
The song's artist name, album image, and song name will all be displayed on this popup, along with a play and pause button in 
order to perform the associated actions with the song. The user can dismiss this scene either by clicking on the "x" at the top 
right of the popup, or by clicking anywhere in the view outside of the frame of such popup.
