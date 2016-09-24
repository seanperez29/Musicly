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
    var audioTrack: AudioTrack!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackDetails()
        view.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlayAudioViewController.closeButtonPressed(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        popupView.layer.cornerRadius = 10
    }
    
    func loadTrackDetails() {
        if let url = URL(string: audioTrack.albumURL) {
           downloadTask = albumImage.loadImageWithURL(url)
        }
        artistNameLabel.text = audioTrack.artistName
        songNameLabel.text = audioTrack.songName
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
