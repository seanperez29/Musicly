//
//  ShowErrorAlert.swift
//  Musicly
//
//  Created by Sean Perez on 9/30/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

func showAlert(errorString: String) -> UIAlertController {
    let alert = UIAlertController(title: errorString, message: "Press OK to dismiss", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    return alert
}
