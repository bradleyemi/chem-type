//
//  DrawView.swift
//  chem-type
//
//  Created by triki on 11/13/15.
//  Copyright © 2015 triki. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // initilization code
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        lastPoint = touches.first!.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let newPoint = touches.first!.locationInView(self)
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextBeginPath(context)
        for line in lines {
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
        }
        
        CGContextSetLineCap(context,CGLineCap.Round)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 10)
        CGContextStrokePath(context)
        
    }
    
    
}
