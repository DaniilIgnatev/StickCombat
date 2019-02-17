//
//  Joystick.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit

protocol JoystickDelegate {
    func ControlCommand(_ : JoystickDescriptor)
}



enum ButtonDescriptor{
    case w,a,s,d
}



struct JoystickDescriptor {
    var direction : Double
    var buttonPressed : ButtonDescriptor
}



protocol Joystick {
    var delegate : JoystickDelegate? {get set}
}


class HorizontalJoystick: SKNode, Joystick {
    var delegate: JoystickDelegate?
    
    let button = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20, height: 20))
    
    override init() {
        super.init()
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if button.color == UIColor.black{
            button.color = UIColor.blue
        }
        else{
            button.color = UIColor.black
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
