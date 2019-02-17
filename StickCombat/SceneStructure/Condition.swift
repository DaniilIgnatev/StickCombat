//
//  Condition.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit



class SceneCondition {
    
    public let fighter_1 : FighterPresence
    
    public let fighter_2 : FighterPresence
    
    public var status = SceneStatus.Preparation
    
    public var gameTime : TimeInterval = 0.0
    
    public var gameEndTime : TimeInterval = 0.0
    
    public init(firstShape : CGRect, secondShape : CGRect, endTime : TimeInterval = 0.0){
        self.fighter_1 = FighterPresence(id: .first, firstShape: firstShape)
        self.fighter_2 = FighterPresence(id: .second, firstShape: secondShape)
        self.gameEndTime = endTime
    }
}



class FighterPresence {
    
    static let maxHP = 100.0
    
    public let ID : FighterID
    
    public var shape : CGRect
    
    public var hp : Double = maxHP
    
    public var comboPoints : Int = 0
    
    public init(id : FighterID, firstShape : CGRect){
        self.ID = id
        self.shape = firstShape
    }
}



enum SceneStatus {
    case Preparation, On, Finished
}



enum FighterID {
    case first,second
}
