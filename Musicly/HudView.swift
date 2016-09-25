//
//  HudView.swift
//  Musicly
//
//  Created by Sean Perez on 9/24/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class HudView: UIView {
    var text = ""
    var image = ""
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: self.image) {
            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imagePoint)
        }
        
        let attribs = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white]
        
        let textSize = text.size(attributes: attribs)
        
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    class func hudInView(view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.showAnimated(view: view, animated: animated)
        return hudView
    }
    
    func showAnimated(view: UIView, animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.3, animations: { 
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                }, completion: { _ in
                    self.hideAnimated(view: view, animated: animated)
            })
        }
    }
    
    func hideAnimated(view: UIView, animated: Bool) {
        if animated {
            alpha = 1
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.3, animations: { 
                self.alpha = 0
                self.transform = CGAffineTransform.identity
                view.isUserInteractionEnabled = true
            })
        }
    }
    
}
