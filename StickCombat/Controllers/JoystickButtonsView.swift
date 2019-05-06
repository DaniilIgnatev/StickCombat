//
//  ControllerButtonsView.swift
//  StickCombat
//
//  Created by Даниил on 18/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import UIKit

@IBDesignable
class JoystickButtonsView: UIView, Joystick {
    var delegate: JoystickDelegate?
    
    private func initButtons(){
        
        let rect = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        if (button_A == nil){
            button_A = UIButton(frame: rect)
            button_A!.addTarget(self, action: #selector(JoystickButtonsView.button_A_Clicked), for: .touchUpInside)
            addSubview(button_A!)
        }
        else{
            button_A?.bounds = rect
        }
        
        if (button_B == nil){
            button_B = UIButton(frame: rect)
            button_B!.addTarget(self, action: #selector(JoystickButtonsView.button_B_Clicked), for: .touchUpInside)
            addSubview(button_B!)
        }
        else{
            button_B?.bounds = rect
        }
        
        if (button_C == nil){
            button_C = UIButton(frame: rect)
            button_C!.addTarget(self, action: #selector(JoystickButtonsView.button_C_Clicked), for: .touchUpInside)
            addSubview(button_C!)
        }
        else{
            button_C?.bounds = rect
        }
        
        if (button_D == nil){
            button_D = UIButton(frame: rect)
            button_D!.addTarget(self, action: #selector(JoystickButtonsView.button_D_Clicked), for: .touchUpInside)
            addSubview(button_D!)
        }
        else{
            button_D?.bounds = rect
        }
        
        button_A!.setImage(UIImage(named: "Abutton"), for: .normal)
        button_B!.setImage(UIImage(named: "Bbutton"), for: .normal)
        button_C!.setImage(UIImage(named: "Cbutton"), for: .normal)
        button_D!.setImage(UIImage(named: "Dbutton"), for: .normal)
        
        //button_C!.center = CGPoint(x: buttonSize / 2, y: buttonSize * 3)
        //button_A!.center = CGPoint(x: buttonSize * 1.5, y: buttonSize)
        //button_D!.center = CGPoint(x: buttonSize * 2.5, y: buttonSize * 2.5)
        //button_B!.center = CGPoint(x: buttonSize * 3.5, y: buttonSize / 2)
        
        button_A?.center = CGPoint(x: buttonSize / 2, y: buttonSize / 2 + buttonOffset)
        button_B?.center = CGPoint(x: buttonSize * 1.5 + buttonOffset, y: buttonSize / 2 + buttonOffset)
        button_C?.center = CGPoint(x: buttonSize / 2 + buttonOffset, y: buttonSize * 1.5)
        button_D?.center = CGPoint(x: buttonSize * 1.5, y: buttonSize * 1.5 )
    }
    
    @objc func button_A_Clicked(){
        print("A")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.first))
    }
    
    @objc func button_B_Clicked(){
        print("B")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.second))
    }
    
    @objc func button_C_Clicked(){
        print("C")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.third))
    }
    
    @objc func button_D_Clicked(){
        print("D")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.fourth))
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButtons()
    }
    
    
    private var buttonSize : CGFloat = 45
    @IBInspectable var ButtonSize : CGFloat{
        get{
            return buttonSize
        }
        set{
            buttonSize = newValue
            
            initButtons()
        }
    }
    
    
    private var buttonOffset : CGFloat = 15
    @IBInspectable var ButtonOffset : CGFloat{
        get{
            return buttonOffset
        }
        set{
            buttonOffset = newValue
            
            initButtons()
        }
    }
    
    private var button_C: UIButton?
    
    private var button_A: UIButton?
    
    private var button_D: UIButton?
    
    private var button_B: UIButton?
    
    
    
    
}
