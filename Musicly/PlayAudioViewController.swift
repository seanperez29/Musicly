//
//  PlayAudioViewController.swift
//  Musicly
//
//  Created by Sean Perez on 9/22/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    var audioTrack: AudioTrack!
    var artistTrack: ArtistTrack!
    var dataTask: URLSessionDataTask?
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackDetailsAndPlay()
        view.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlayAudioViewController.closeButtonPressed(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        popupView.layer.cornerRadius = 10
    }
    
    @IBAction func pauseButtonPressed(_ sender: AnyObject) {
        if player.rate == 0 {
            player.play()
            pauseButton.setImage(UIImage(named: "PauseBtn1"), for: .normal)
        } else {
            player.pause()
            pauseButton.setImage(UIImage(named: "PlayBtn"), for: .normal)
        }
    }
    
    func loadTrackDetailsAndPlay() {
        if let artistTrack = artistTrack {
            let image = UIImage(data: artistTrack.imageData!)
            albumImage.image = image
            if let mediaURL = URL(string: artistTrack.media) {
                playerItem = AVPlayerItem(url: mediaURL)
            }
            player = AVPlayer(playerItem: playerItem)
            artistNameLabel.text = artistTrack.artist
            songNameLabel.text = artistTrack.song
            player.play()
        } else {
            dataTask = SpotifyClient.sharedInstance.getImage(audioTrack.albumURL, completionHandler: { (imageData, errorString) in
                guard (errorString == nil) else {
                    print("Unable to download image: \(errorString)")
                    return
                }
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain {
                        self.albumImage.image = image
                    }
                }
            })
            if let mediaURL = URL(string: audioTrack!.mediaURL) {
                playerItem = AVPlayerItem(url: mediaURL)
            }
            player = AVPlayer(playerItem: playerItem)
            artistNameLabel.text = audioTrack!.artistName
            songNameLabel.text = audioTrack!.songName
            player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        dataTask?.cancel()
    }

}

extension PlayAudioViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimationController()
    }
}

extension PlayAudioViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
