//
//  DimmingPresentationController.swift
//  Musicly
//
//  Created by Sean Perez on 9/23/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
