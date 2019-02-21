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
    
    
    private var RingRadius : CGFloat{
        return (bounds.width / 2) - _StickThickness - _StickRadius 
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

    
    func StickerPosBy(angle : CGFloat, scale : CGFloat) -> CGPoint{
        let stock_x = RingRadius
        let stock_y = RingRadius

        let rotated_x = stock_x * cos(angle * CGFloat.pi / 180)
        let rotated_y = stock_y * -sin(angle * CGFloat.pi / 180)
        
        let scaled_x = rotated_x * scale
        let scaled_y = rotated_y * scale
        
        let final_x = frame.width / 2 + scaled_x
        let final_y = frame.height / 2 + scaled_y
        
        //print("New position: \(final_x),\(final_y)")
        
        return CGPoint(x: final_x, y: final_y)
    }
    
    func GetAngleRespectively(superPos : CGPoint) -> CGFloat{
        let posinsuper = frame.origin
        let center = CGPoint(x : posinsuper.x + frame.width / 2,y : posinsuper.y + frame.height / 2)
        //print("center: \(center)")
        
        //Local coordinates
        let localRadius = sqrt(pow(superPos.x - center.x,2) + pow(superPos.y - center.y,2))
        
        //Calculate cos
        //модуль
        let dx = superPos.x - center.x >= 0 ? superPos.x - center.x : -(superPos.x - center.x)
        var cos = dx / localRadius;
        
        //Check negative cos
        if (superPos.x < center.x)
        {
            cos *= -1;
        }
        
        var Angle = acos(cos) * 180.0 / CGFloat.pi
        
        //Check negative sin
        if (superPos.y > center.y)
        {
            Angle = 360.0 - Angle;
        }
        
        //print("angle = \(Angle)")
        
        return Angle;
    }
    
    func GetScaleRespectively(superPos : CGPoint) -> (xyScale : CGFloat,xScale : CGFloat, yScale : CGFloat){
        let xOffset = superPos.x - center.x > 0 ? superPos.x - center.x : -(superPos.x - center.x)
        let yOffset = superPos.y - center.y > 0 ? superPos.y - center.y : -(superPos.y - center.y)
        let maxOffset = RingRadius
        
        let xScale = xOffset / maxOffset > 1.0 ? 1.0 : xOffset / maxOffset
        let yScale = yOffset / maxOffset > 1.0 ? 1.0 : yOffset / maxOffset

        var xyScale = sqrt(pow(xScale, 2) + pow(yScale, 2))

        if xyScale > 1.0{
            xyScale = 1.0
        }
        
        return (xyScale,xScale,yScale)
    }
    
    public func touchBeganInSuperView(_ t : UITouch, superpos : CGPoint){
        //print("Began at superpos \(superpos)")
        
    }
    
    public func touchMovedInSuperView(_ t : UITouch, superpos : CGPoint){
        //print("Moved at superpos \(superpos)")
   
        let angle = GetAngleRespectively(superPos: superpos)
        let scale = GetScaleRespectively(superPos: superpos)
        
        if scale.xyScale < 1.0 {
            let pos = t.location(in: self)
            StickPosition = pos
        }
        else{
            StickPosition = StickerPosBy(angle: angle, scale: 1.0)
        }
        
        //print("angle: \(angle); scale\(scale.xyScale)")
    }
    
    public func touchEndedInSuperView(_ t : UITouch, superpos : CGPoint){
        //print("Ended at superpos \(superpos)")
        StickPosition = nil
    }

}
