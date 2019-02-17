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
    
    let button_left_left = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_left_right = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_left_up = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_left_down = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_right_left = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_right_right = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_right_up = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    let button_right_down = SKSpriteNode(color: UIColor.black, size: CGSize(width: 50, height: 50))
    
    var DeviceSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    override init() {
        super.init()
        AddChildren()
    }
    
    func AddChildren(){
        self.addChild(button_left_left)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if button_left_left.color == UIColor.black{
            button_left_left.color = UIColor.blue
        }
        else{
            button_left_left.color = UIColor.black
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        AddChildren()
    }
}
