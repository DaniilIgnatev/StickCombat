//
//  ActionEngine.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit


protocol ActionEngineDelegate {
    func requestGameAction(_ action : GameAction)
}



protocol ActionEngine {
    ///От чьего имени генерируются действия
    var Fighter : FighterID{get}
    ///Состояние игровой сцены
    var Condition : SceneCondition {get set}
    ///Осведомленный объект
    var delegate : ActionEngineDelegate? {get set}
}



class GestureEngine: ActionEngine, JoystickDelegate {

    //MARK: Context
    let fighter: FighterID
    ///От чьего имени генерируются действия
    var Fighter: FighterID{
        get{
            return fighter
        }
    }
    
    
    var condition : SceneCondition
    var Condition: SceneCondition{
        get{
            return condition
        }
        set{
            condition = newValue
        }
    }
    
    
    var delegate: ActionEngineDelegate?
    
    
    public init(fighterID : FighterID, condition : SceneCondition, joysticks : JoystickSet){
        self.fighter = fighterID
        self.condition = condition
        joysticks.firstMoveJoystick?.delegate = self
        joysticks.firstStrikeJoystick?.delegate = self
        joysticks.secondMoveJoystick?.delegate = self
        joysticks.secondStrikeJoystick?.delegate = self
    }


    //MARK: Commands processing

    ///Генерация команды из данных дескриптора
    func ControlCommand(descriptor : JoystickDescriptor) {
        var xVector : CGFloat = -1.0
        var opponentPosition : CGFloat = self.condition.fighter_1.X
        if self.fighter == .first{
            xVector = -xVector
            opponentPosition = self.condition.fighter_2.X
        }

        var action : GameAction? = nil

        if descriptor.buttonPressed != nil{
            action = processPressedButton(descriptor: descriptor.buttonPressed!, xStrikeVector: xVector, xOpponentPosition: opponentPosition)
        }
        if descriptor.buttonReleased != nil{
            action = processReleasedButton(descriptor: descriptor.buttonReleased!)
        }
        if descriptor.axisShift != nil{
            action = processAxisDescriptor(angle: descriptor.axisShift!.angle, scale: descriptor.axisShift!.power)
        }

        if action != nil{
            delegate?.requestGameAction(action!)
        }
    }


    private func processPressedButton(descriptor : ButtonDescriptor, xStrikeVector : CGFloat, xOpponentPosition : CGFloat) -> GameAction?{

        var direction = FighterDirection.left
        if fighter == .first{
            direction = .right
        }

        switch descriptor {
        case .first:
            return BlockAction(fighter: fighter, isOn: true)//выставить блок
        case .second:
            //удар рукой
            return StrikeAction(fighter: fighter, impact: .Jeb, direction: direction)
        case .third:
            //удар левой ногой (вверх)
            return StrikeAction(fighter: fighter, impact: .leftKick, direction: direction)
        case .fourth:
            //удар правой ногой (прямо)
            return StrikeAction(fighter: fighter, impact: .RightKick, direction: direction)
        }
    }


    private func processReleasedButton(descriptor : ButtonDescriptor) -> GameAction?{
        switch descriptor {
        case .first:
            return BlockAction(fighter: fighter, isOn: false)//снять блок
        default:
            return nil
        }
    }


    private func processAxisDescriptor(angle : CGFloat, scale : CGFloat) -> GameAction{
        var selfXPos = self.condition.fighter_1.X

        if fighter == .second{
            selfXPos = self.condition.fighter_2.X
        }

        let xDirection = MoveDirection(angle: angle)
        let by = xDirection * scale * 30


        return HorizontalAction(fighter: fighter, from: selfXPos, by: by)
    }


    private func MoveDirection(angle : CGFloat) -> CGFloat{
        switch angle {
        case 0..<90:
            fallthrough
        case 270..<360:
            return 1
        case 90..<270:
            return -1
        default:
            return 0
        }
    }
}



class AIEngine: ActionEngine {
    
    let fighter: FighterID
    var Fighter: FighterID{
        get{
            return fighter
        }
    }
    
    
    var condition : SceneCondition
    var Condition: SceneCondition{
        get{
            return condition
        }
        set{
            condition = newValue
        }
    }
    
    
    var delegate: ActionEngineDelegate?
    
    
    public init(fighterID : FighterID, condition : SceneCondition){
        self.fighter = fighterID
        self.condition = condition
    }
    
}
