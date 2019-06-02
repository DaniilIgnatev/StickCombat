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

    ///Ссылка на NIB
    @IBOutlet weak var contentView: UIView!


    //MARK: BUTTONS EVENTS

    @IBOutlet weak var button_A: UIButton!


    @IBAction func button_A_touchDown(_ sender: Any) {
        print("A pressed")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.first, buttonReleased: nil))
    }


    @IBAction func button_A_touchUp(_ sender: Any) {
        print("A released")
        delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .first))
    }


    @IBOutlet weak var button_B: UIButton!


    @IBAction func button_B_touchDown(_ sender: Any) {
        if isCanClick{
            print("B pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.second, buttonReleased: nil))
            HangOnClickDelay()
        }
    }


    @IBAction func button_B_touchUp(_ sender: Any) {
        if isCanClick{
            print("B released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .second))
            HangOnClickDelay()
        }
    }


    @IBOutlet weak var button_C: UIButton!


    @IBAction func button_C_touchDown(_ sender: Any) {
        if isCanClick{
            print("C pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.third, buttonReleased: nil))
            HangOnClickDelay()
        }
    }


    @IBAction func button_C_touchUp(_ sender: Any) {
        if isCanClick{
            print("C released")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: nil, buttonReleased: .third))
            HangOnClickDelay()
        }
    }


    @IBOutlet weak var button_D: UIButton!


    @IBAction func button_D_touchDown(_ sender: Any) {
        if isCanClick{
            print("D pressed")
            delegate?.ControlCommand(descriptor: JoystickDescriptor(axisShift: nil, buttonPressed: ButtonDescriptor.fourth, buttonReleased: nil))
            HangOnClickDelay()
        }
    }


    @IBAction func button_D_TouchUP(_ sender: Any) {
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
    

    //MARK: INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }


    private func commonInit(){
        self.contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = .init(arrayLiteral: .flexibleWidth, .flexibleHeight)
    }


    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }
}
