//
//  Action.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit



enum ActionType {
    case Strike, Horizontal,Vertical
}



protocol Action {
    
    var Kind: ActionType {get}
    
    
    var Fighter : FighterID {get}
}



class StrikeAction: Action {
    
    private let kind : ActionType
    public var Kind: ActionType{
        get{
            return kind
        }
    }
    
    
    private let fighter : FighterID
    public var Fighter: FighterID{
        get{
            return fighter
        }
    }
    
    
    required init(kind: ActionType, fighter: FighterID, vector : CGVector, point : CGPoint) {
        self.kind = kind
        self.fighter = fighter
        self.Vector = vector
        self.Point = point
    }
    
    
    public let Vector : CGVector
    
    
    public let Point : CGPoint
}



class HorizontalAction: Action {
    
    private let kind : ActionType
    public var Kind: ActionType{
        get{
            return kind
        }
    }
    
    
    private let fighter : FighterID
    public var Fighter: FighterID{
        get{
            return fighter
        }
    }
    
    required init(kind: ActionType, fighter: FighterID, from : Double, to : Double, by : Double = 0.0) {
        self.kind = kind
        self.fighter = fighter
        self.From = from
        self.To = to
        self.By = by
    }
    
    public let From : Double
    
    
    public let To : Double
    
    
    public let By : Double
}



class VerticalAction: Action {
    private let kind : ActionType
    public var Kind: ActionType{
        get{
            return kind
        }
    }
    
    
    private let fighter : FighterID
    public var Fighter: FighterID{
        get{
            return fighter
        }
    }
    
    required init(kind: ActionType, fighter: FighterID, from : VerticalStance, to : VerticalStance) {
        self.kind = kind
        self.fighter = fighter
        self.From = from
        self.To = to
    }
    
    public let From : VerticalStance
    
    
    public let To : VerticalStance
}


enum VerticalStance {
    case stand, jump, crouch
}
