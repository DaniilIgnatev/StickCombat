//
//  ControllerButtonsView.swift
//  StickCombat
//
//  Created by Даниил on 18/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import UIKit

class ControllerButtonsView: UIView, Joystick {
    var delegate: JoystickDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButtons()
    }
    

    private static let buttonSize = CGRect(x: 0, y: 0, width: 30, height: 30)
    
    private static let buttonsGap : CGFloat = 10.0
    
    private let button_left = UIButton(frame: buttonSize)
    
    private let button_right = UIButton(frame: buttonSize)
    
    private let button_up = UIButton(frame: buttonSize)
    
    private let button_down = UIButton(frame: buttonSize)
    
    private func AddButtons(){
        addSubview(button_left)
        addSubview(button_right)
        addSubview(button_up)
        addSubview(button_down)
    }
    
    private func initButtons(){
        button_left.backgroundColor = UIColor.blue
        button_up.backgroundColor = UIColor.yellow
        button_right.backgroundColor = UIColor.red
        button_down.backgroundColor = UIColor.green
    }
    
    
    private func ArrangeButtons(){
        
        button_left.center = CGPoint(x: button_left.frame.width / 2, y: button_up.frame.height + ControllerButtonsView.buttonsGap + button_left.frame.height / 2)
        
        button_up.center = CGPoint(x: button_left.frame.width / 2 + button_up.frame.width / 2, y: button_up.frame.height / 2)
        
        //button_right.center = CGPoint(x: button_up.center.x + button_up.frame.width / 2 + ControllerButtonsView.buttonsGap + button_right.frame.width / 2, y: <#T##CGFloat#>)
        
        //button_down.center = CGPoint(x: button_right_up.position.x - button_right_up.size.width / 2 - rightButtonsHorizontalOffset - button_right_left.size.width / 2, y: button_right_right.position.y)
    }
        
}
