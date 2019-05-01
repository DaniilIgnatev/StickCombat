//
//  ActionEngine.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation



protocol ActionEngineDelegate {
    func requestGameAction(_ : GameAction)
}



protocol ActionEngine {
    
    var Fighter : FighterID{get}
    
    var Condition : SceneCondition {get set}
    
    var Delegate : ActionEngineDelegate? {get set}
}



class GestureEngine: ActionEngine, JoystickDelegate {

    
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
    
    
    var Delegate: ActionEngineDelegate?
    
    
    public init(fighterID : FighterID, condition : SceneCondition){
        self.fighter = fighterID
        self.condition = condition
    }
    
    //MARK: Joystick Delegate
    
    func ControlCommand(_: JoystickDescriptor) {
        
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
    
    
    var Delegate: ActionEngineDelegate?
    
    
    public init(fighterID : FighterID, condition : SceneCondition){
        self.fighter = fighterID
        self.condition = condition
    }
    
}
