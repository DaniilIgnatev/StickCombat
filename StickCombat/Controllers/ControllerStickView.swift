//
//  HorizontalJoystickView.swift
//  StickCombat
//
//  Created by Даниил on 18/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import UIKit

@IBDesignable
class ControllerStickView: UIView, Joystick {
    var delegate: JoystickDelegate?
    

    private let StickRadius : CGFloat = 20
    
    private let RingRadius : CGFloat = 60
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    if let context = UIGraphicsGetCurrentContext(){
            context.addEllipse(in: CGRect(x: 0, y: 0, width: StickRadius, height: StickRadius))
         
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: superview!)
        print("x = \(loc.x); y = \(loc.y)")
    }

}
