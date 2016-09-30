//
//  AnimationController.swift
//  Musicly
//
//  Created by Sean Perez on 9/23/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    //The inspiration of the animation and certain UI elements of the 'PlayAudioViewController', as well as the HudView, were learned from a Ray Wenderlich tutorial. Aspects were customized and altered to fit my needs.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            let containerView = transitionContext.containerView
            toView.frame = transitionContext.finalFrame(for: toViewController)
            toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
                containerView.addSubview(toView)
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                    toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
