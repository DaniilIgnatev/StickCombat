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
    func ControlCommand(descriptor : JoystickDescriptor)
}


enum ButtonDescriptor{
    case first,second,third,fourth
}


struct JoystickDescriptor {
    let axisShift : (angle : CGFloat,power : CGFloat)?
    let buttonPressed : ButtonDescriptor?
}


protocol Joystick {
    var delegate : JoystickDelegate? {get set}
}
