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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
