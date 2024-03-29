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
    
    public var status = LobbyStatusEnum.casting
    
    public init(firstX : CGFloat, secondX : CGFloat){
        self.fighter_1 = FighterPresence(id: .first, X: firstX)
        self.fighter_2 = FighterPresence(id: .second, X: secondX)
        //self.gameEndTime = endTime
    }
}


///Направление взгляда бойца
enum FighterDirection : Int {
    case left = 0, right = 1
}


class FighterPresence {
    
    static public let maxHP : CGFloat = 100.0

    static public let width : CGFloat = 100.0

    static public let height : CGFloat = 150.0

    public var nickname : String
    
    private var halfWidth : CGFloat{
        return FighterPresence.width / 2
    }

    ///Направление взгляда бойца
    public var direction : FighterDirection

    public let ID : FighterID
    
    public var X : CGFloat
    
    public var hp : CGFloat = maxHP
    
    public var isBlock : Bool = false
    
    public init(id : FighterID, X : CGFloat){
        direction = .left
        nickname = "боец1"

        if id == .first{
            direction = .right
            nickname = "боец2"
        }

        self.ID = id
        self.X = X
    }
}


enum FighterID: Int {
    case first = 0, second = 1
}
