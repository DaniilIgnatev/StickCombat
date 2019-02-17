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
    var SceneSize : CGSize {get set}
}


class HorizontalJoystick: SKNode, Joystick {
    
    var delegate: JoystickDelegate?
    
    //MARK: INIT
    override init() {
        super.init()
        InitActions()
    }
    
    func InitActions(){
        AddChildren()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitActions()
    }
    
    //MARK: ALLOCATION
    let button_left_left = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 30, height: 30))
    
    let button_left_right = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    
    let button_left_up = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 30, height: 30))
    
    let button_left_down = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 30, height: 30))
    
    let button_right_left = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 30, height: 30))
    
    let button_right_right = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
    
    let button_right_up = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 30, height: 30))
    
    let button_right_down = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 30, height: 30))
    
    func AddChildren(){
        self.addChild(button_left_left)
        self.addChild(button_left_right)
        self.addChild(button_left_up)
        self.addChild(button_left_down)
        
        self.addChild(button_right_left)
        self.addChild(button_right_right)
        self.addChild(button_right_up)
        self.addChild(button_right_down)
    }
    
    var sceneSize: CGSize = UIScreen.main.bounds.size
    var SceneSize: CGSize{
        get{
            return sceneSize
        }
        set{
            sceneSize = newValue
            ArrangeButtons()
        }
    }
    
    private func ArrangeButtons(){
        let leftOffset : CGFloat = 30
        let bottomOffset : CGFloat = 30
        let rightOffset : CGFloat = 40
        
        let leftStart : CGFloat = -sceneSize.width / 2 + leftOffset
        let bottomStart : CGFloat = -sceneSize.height / 2 + bottomOffset
        let rightStart : CGFloat = sceneSize.width / 2 - rightOffset
        
        
        let leftButtonsHorizontalOffset : CGFloat = 10
        let leftButtonsVerticalOffset: CGFloat = 10
        
        let rightButtonsHorizontalOffset : CGFloat = 10
        let rightButtonsVerticalOffset: CGFloat = 10
        
        
        button_left_left.position = CGPoint(x: leftStart + button_left_left.size.width / 2, y: bottomStart + button_left_down.size.height + leftButtonsVerticalOffset + button_left_left.size.height / 2)
        
        button_left_down.position = CGPoint(x: button_left_left.position.x + button_left_left.size.width / 2 + leftButtonsHorizontalOffset + button_left_down.size.width / 2, y: bottomStart + button_left_down.size.height / 2)
        
        button_left_up.position = CGPoint(x: button_left_down.position.x, y: button_left_down.position.y + button_left_down.size.height / 2 + leftButtonsVerticalOffset + button_left_left.size.height + leftButtonsVerticalOffset + button_left_up.size.height / 2)
        
        button_left_right.position = CGPoint(x: button_left_down.position.x + button_left_down.size.width / 2 + leftButtonsHorizontalOffset + button_left_right.size.width / 2, y: button_left_left.position.y)
        
        
        button_right_right.position = CGPoint(x: rightStart - button_right_right.size.width / 2, y: bottomStart + button_right_down.size.height + rightButtonsVerticalOffset + button_right_right.size.height / 2)
        
        button_right_down.position = CGPoint(x: button_right_right.position.x - button_right_right.size.width / 2 - rightButtonsHorizontalOffset - button_right_down.size.width / 2, y: bottomStart + button_right_down.size.height / 2)
        
        button_right_up.position = CGPoint(x: button_right_down.position.x, y: button_right_down.position.y + button_right_down.size.height / 2 + rightButtonsVerticalOffset + button_right_right.size.height + rightButtonsVerticalOffset + button_right_up.size.height / 2)
        
        button_right_left.position = CGPoint(x: button_right_up.position.x - button_right_up.size.width / 2 - rightButtonsHorizontalOffset - button_right_left.size.width / 2, y: button_right_right.position.y)
    }
    
    //MARK: COMMANDS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
   
}
