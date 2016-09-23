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
    var artistTrack: Track!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackDetails()
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlayAudioViewController.closeButtonPressed(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        popupView.layer.cornerRadius = 10
    }
    
    func loadTrackDetails() {
        if let url = URL(string: artistTrack.albumURL) {
           downloadTask = albumImage.loadImageWithURL(url)
        }
        artistNameLabel.text = artistTrack.artistName
        songNameLabel.text = artistTrack.songName
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
        downloadTask?.cancel()
    }

}

extension PlayAudioViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension PlayAudioViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
