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

    //MARK: SETUP

    private var button_C: UIButton?

    private var button_A: UIButton?

    private var button_D: UIButton?

    private var button_B: UIButton?

    
    private func initButtons(){
        
        let rect = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        if (button_A == nil){
            button_A = UIButton(frame: rect)
            button_A!.addTarget(self, action: #selector(JoystickButtonsView.button_A_Clicked), for: .touchDown)
            button_A!.addTarget(self, action: #selector(JoystickButtonsView.button_A_Released), for: .touchUpInside)
            addSubview(button_A!)
        }
        else{
            button_A?.bounds = rect
        }
        
        if (button_B == nil){
            button_B = UIButton(frame: rect)
            button_B!.addTarget(self, action: #selector(JoystickButtonsView.button_B_Clicked), for: .touchDown)
            button_B!.addTarget(self, action: #selector(JoystickButtonsView.button_B_Released), for: .touchUpInside)
            addSubview(button_B!)
        }
        else{
            button_B?.bounds = rect
        }
        
        if (button_C == nil){
            button_C = UIButton(frame: rect)
            button_C!.addTarget(self, action: #selector(JoystickButtonsView.button_C_Clicked), for: .touchDown)
            button_C!.addTarget(self, action: #selector(JoystickButtonsView.button_C_Released), for: .touchUpInside)
            addSubview(button_C!)
        }
        else{
            button_C?.bounds = rect
        }
        
        if (button_D == nil){
            button_D = UIButton(frame: rect)
            button_D!.addTarget(self, action: #selector(JoystickButtonsView.button_D_Clicked), for: .touchDown)
            button_C!.addTarget(self, action: #selector(JoystickButtonsView.button_D_Released), for: .touchUpInside)
            addSubview(button_D!)
        }
        else{
            button_D?.bounds = rect
        }
        
        //button_C!.center = CGPoint(x: buttonSize / 2, y: buttonSize * 3)
        //button_A!.center = CGPoint(x: buttonSize * 1.5, y: buttonSize)
        //button_D!.center = CGPoint(x: buttonSize * 2.5, y: buttonSize * 2.5)
        //button_B!.center = CGPoint(x: buttonSize * 3.5, y: buttonSize / 2)

        let marginesOffset : CGFloat = 50.0
        button_A?.center = CGPoint(x: buttonSize - marginesOffset, y: buttonSize - marginesOffset)
        button_B?.center = CGPoint(x: buttonSize * 1.5 + buttonOffset  - marginesOffset, y: buttonSize - marginesOffset)
        button_C?.center = CGPoint(x: buttonSize  - marginesOffset, y: buttonSize * 1.5 + buttonOffset - marginesOffset)
        button_D?.center = CGPoint(x: buttonSize * 1.5 + buttonOffset  - marginesOffset, y: buttonSize * 1.5 + buttonOffset - marginesOffset)
    }



    //MARK: BUTTON EVENTS
    @objc func button_A_Clicked(){
        //if isCanClick{
            print("A pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.first, buttonReleased: nil))
            //HangOnClickDelay()
        //}
    }

    @objc func button_A_Released(){
        //if isCanClick{
            print("A released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .first))
            //HangOnClickDelay()
        //}
    }

    
    @objc func button_B_Clicked(){
        if isCanClick{
            print("B pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.second, buttonReleased: nil))
            HangOnClickDelay()
        }
    }

    @objc func button_B_Released(){
        if isCanClick{
            print("B released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .second))
            HangOnClickDelay()
        }
    }

    
    @objc func button_C_Clicked(){
        if isCanClick{
            print("C pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.third, buttonReleased: nil))
            HangOnClickDelay()
        }
    }

    @objc func button_C_Released(){
        if isCanClick{
            print("C released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .third))
            HangOnClickDelay()
        }
    }

    
    @objc func button_D_Clicked(){
        if isCanClick{
            print("D pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.fourth, buttonReleased: nil))
            HangOnClickDelay()
        }
    }

    @objc func button_D_Released(){
        if isCanClick{
            print("D released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .fourth))
            HangOnClickDelay()
        }
    }


    //MARK: CLICK DELAY

    //Наложить задержку следующего нажатия
    private func HangOnClickDelay(){
        isCanClick = false
        clickDelayTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (t) in
            self.isCanClick = true
        })
    }


    ///Состояние доступности нажатия
    private var isCanClick : Bool = true


    ///Таймер задержки для предотвращения спама
    private var clickDelayTimer : Timer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButtons()
    }


    //MARK: INSPECTABLE PARAMS
    private var buttonAImageName : String = ""
    @IBInspectable var ButtonAImageName : String{
        get{
            return buttonAImageName
        }
        set{
            buttonAImageName = newValue
            button_A!.setImage(UIImage(named: buttonAImageName), for: .normal)

            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    private var buttonBImageName : String = ""
    @IBInspectable var ButtonBImageName : String{
        get{
            return buttonBImageName
        }
        set{
            buttonBImageName = newValue
            button_B!.setImage(UIImage(named: buttonBImageName), for: .normal)

            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    private var buttonCImageName : String = ""
    @IBInspectable var ButtonCImageName : String{
        get{
            return buttonCImageName
        }
        set{
            buttonCImageName = newValue
            button_C!.setImage(UIImage(named: buttonCImageName), for: .normal)

            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    private var buttonDImageName : String = ""
    @IBInspectable var ButtonDImageName : String{
        get{
            return buttonDImageName
        }
        set{
            buttonDImageName = newValue
            button_D!.setImage(UIImage(named: buttonDImageName), for: .normal)

            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    
    private var buttonSize : CGFloat = 45
    @IBInspectable var ButtonSize : CGFloat{
        get{
            return buttonSize
        }
        set{
            buttonSize = newValue
            
            initButtons()
            setNeedsLayout()
            setNeedsDisplay()
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
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
}
