//
//  GradientView.swift
//  Musicly
//
//  Created by Sean Perez on 9/23/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit


class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)!
        let x = bounds.midX
        let y = bounds.midY
        let point = CGPoint(x: x, y : y)
        let radius = max(x, y)
        let context = UIGraphicsGetCurrentContext()
        context!.drawRadialGradient(gradient, startCenter: point, startRadius: 0, endCenter: point, endRadius: radius, options: .drawsAfterEndLocation)
    }
}
