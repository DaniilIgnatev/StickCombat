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
    var axisShift : (angle : Double,power : Double)?
    var buttonPressed : ButtonDescriptor?
}



protocol Joystick {
    var delegate : JoystickDelegate? {get set}
}

