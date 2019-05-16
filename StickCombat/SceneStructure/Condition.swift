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
    
    public init(firstX : CGFloat, secondX : CGFloat, endTime : TimeInterval = 0.0){
        self.fighter_1 = FighterPresence(id: .first, X: firstX)
        self.fighter_2 = FighterPresence(id: .second, X: secondX)
        self.gameEndTime = endTime
    }
}



class FighterPresence {
    
    static public let maxHP : CGFloat = 100.0

    static public let width : CGFloat = 40.0

    static public let height : CGFloat = 80.0
    
    public let ID : FighterID
    
    public var X : CGFloat
    
    public var hp : CGFloat = maxHP
    
    public var comboPoints : Int = 0
    
    public init(id : FighterID, X : CGFloat){
        self.ID = id
        self.X = X
    }
}



enum SceneStatus {
    case Preparation, Play, Pause, Finished, ConnectionLost
}



enum FighterID: Int {
    case first = 0, second = 1
}
