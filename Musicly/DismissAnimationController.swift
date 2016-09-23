//
//  DismissAnimationController.swift
//  Musicly
//
//  Created by Sean Perez on 9/23/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view( forKey: UITransitionContextViewKey.from) {
        let containerView = transitionContext.containerView
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.center.y = containerView.center.y
                fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            }) }
    } }
