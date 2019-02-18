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
    
    let buttonsSize : CGFloat = 30
    
    var button_E : UIButton
    
     var button_R : UIButton
    
     var button_S : UIButton
    
     var button_D : UIButton

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButtons()
    }
    
    func initButtons(){
        let verticalOffset : CGFloat = 15
        let horizontalOffset : CGFloat = 10
        
        button_E = UIButton(frame: CGRect(x: 0, y: 0, width: buttonsSize, height: buttonsSize))
        button_R = UIButton(frame: CGRect(x: 0, y: 0, width: buttonsSize, height: buttonsSize))
        button_S = UIButton(frame: CGRect(x: 0, y: 0, width: buttonsSize, height: buttonsSize))
        button_D = UIButton(frame: CGRect(x: 0, y: 0, width: buttonsSize, height: buttonsSize))
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    /*
 
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
 
 */
    
}
