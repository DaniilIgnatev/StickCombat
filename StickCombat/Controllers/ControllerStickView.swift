//
//  HorizontalJoystickView.swift
//  StickCombat
//
//  Created by Даниил on 18/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import UIKit

@IBDesignable
class ControllerStickView: UIView, Joystick {
    var delegate: JoystickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        InitializationActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        InitializationActions()
    }
    
    private func InitializationActions(){
        backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
    private var _StickThickness : CGFloat = 4
    @IBInspectable public var StickThickness : CGFloat{
        get{
            return _StickThickness
        }
        set{
            _StickThickness = newValue
            setNeedsDisplay()
        }
    }
    
    private var _StickRadius : CGFloat = 20
    @IBInspectable public var StickRadius : CGFloat{
        get{
            return _StickRadius
        }
        set{
            _StickRadius = newValue
            setNeedsDisplay()
        }
    }
    
    private var _StickPosition : CGPoint? = nil
    private var StickPosition : CGPoint?{
        get{
            if _StickPosition == nil{
                return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            }
            else{
                return _StickPosition!
            }
        }
        set{
            _StickPosition = newValue
            setNeedsDisplay()
        }
    }
    
    private var _StickStrokeColor : UIColor = UIColor.darkGray
    @IBInspectable public var StickStrokeColor : UIColor{
        get{
            return _StickStrokeColor
        }
        set{
            _StickStrokeColor = newValue
            setNeedsDisplay()
        }
    }
    
    private var _StickFillColor : UIColor = UIColor.lightGray
    @IBInspectable public var StickFillColor : UIColor{
        get{
            return _StickFillColor
        }
        set{
            _StickFillColor = newValue
            setNeedsDisplay()
        }
    }
    
    private var _RingStartColor : UIColor = UIColor.red
    @IBInspectable public var RingStartColor : UIColor{
        get{
            return _RingStartColor
        }
        set{
            _RingStartColor = newValue
            setNeedsDisplay()
        }
    }
    
    private var _RingEndColor : UIColor = UIColor.blue
    @IBInspectable public var RingEndColor : UIColor{
        get{
            return _RingEndColor
        }
        set{
            _RingEndColor = newValue
            setNeedsDisplay()
        }
    }
    
    private var _RingColorPoint : CGFloat = 0.5
    @IBInspectable public var RingColorPoint : Int{
        get{
            return Int(_RingColorPoint * 10)
        }
        set{
            if newValue < 0{
                _RingColorPoint = 0.0
            }
            else
                if newValue > 10{
                    _RingColorPoint = 1.0
                }
                else{
                    _RingColorPoint = CGFloat(newValue) / 10.0
            }
            
            setNeedsDisplay()
        }
    }
    

    @IBInspectable public var RingRadius : CGFloat{
        return (bounds.width / 2) - _StickThickness - _StickRadius / 2
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if let context = UIGraphicsGetCurrentContext(){
            
            let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            
            context.setFillColor(StickFillColor.cgColor)
            context.addEllipse(in: CGRect(x: center.x - RingRadius, y: center.y - RingRadius, width: RingRadius * 2, height: RingRadius * 2))
            context.fillPath()
            
            context.setLineWidth(StickThickness)
            context.setStrokeColor(StickStrokeColor.cgColor)
            context.addEllipse(in: CGRect(x: center.x - RingRadius, y: center.y - RingRadius, width: RingRadius * 2, height: RingRadius * 2))
            context.strokePath()
            
            
            let colors = [RingStartColor.cgColor,RingEndColor.cgColor] as CFArray
            let locations : [CGFloat] = [0.0,_RingColorPoint,1.0]
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: locations)!
            context.drawRadialGradient(gradient, startCenter: StickPosition!, startRadius: 0, endCenter: StickPosition!, endRadius: StickRadius, options:  .drawsBeforeStartLocation)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
        print("x = \(loc.x); y = \(loc.y)")
        
        _ = Angle(pos: loc)
        
        StickPosition = loc
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        StickPosition = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
   
        
      
            print("x = \(loc.x); y = \(loc.y)")
             StickPosition = loc
        
    }
    
    func Distance(pos : CGPoint) -> CGFloat{
        return sqrt(pow(pos.x - RingRadius,2) + pow(pos.y - RingRadius,2))
    }
    
    func Angle(pos : CGPoint) -> CGFloat{
        //Local coordinates
        let localRadius = Distance(pos: pos)
  
        //Calculate cos
        let dx = pos.x - RingRadius >= 0 ? pos.x - RingRadius : -(pos.x - RingRadius)
        var cos = dx / localRadius;
        
        //Check negative cos
        if (pos.x < RingRadius)
        {
            cos *= -1;
        }
        
        var Angle = acos(cos) * 180.0 / CGFloat.pi
        
        //Check negative sin
        if (pos.y > RingRadius)
        {
            Angle = 360.0 - Angle;
        }
        
        print("angle = \(Angle)")
        
        return Angle;
    }
}
