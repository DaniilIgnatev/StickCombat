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
    case Strike, Horizontal, Vertical, Block
}



protocol GameAction {
    
    var Kind: ActionType {get}
    
    
    var Fighter : FighterID {get}
}



class StrikeAction: GameAction {
    
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
    
    
    required init(fighter: FighterID, vector : CGVector, point : CGPoint) {
        self.kind = .Strike
        self.fighter = fighter
        self.Vector = vector
        self.Point = point
    }
    
    
    public let Vector : CGVector
    
    
    public let Point : CGPoint
}



class HorizontalAction: GameAction {
    
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
    
    init(fighter: FighterID, from : CGFloat, to : CGFloat) {
        self.kind = .Horizontal
        self.fighter = fighter
        self.From = from
        self.To = to
        self.By = 0.0
    }
    
    init(fighter: FighterID, from : CGFloat, by : CGFloat) {
        self.kind = .Horizontal
        self.fighter = fighter
        self.From = from
        self.To = 0.0
        self.By = by
    }
    
    public let From : CGFloat
    
    
    public let To : CGFloat
    
    
    public let By : CGFloat
}

class BlockAction: GameAction{
    
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
    
    private let isOn: Bool
    public var IsOn: Bool{
        get{
            return isOn
        }
    }
    
    init(fighter: FighterID, isOn: Bool) {
        self.kind = .Block
        self.fighter = fighter
        self.isOn = isOn
    }
}
/*
class VerticalAction: GameAction {
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
    
    required init(fighter: FighterID, from : VerticalStance, to : VerticalStance) {
        self.kind = .Vertical
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
*/

struct ConnectionAction{
    ///true -- создать лобби,false -- присоединиться
    public let create: Bool
    public let name: String
    public let password: String
}

struct StatusAction{
    public let fighter: FighterID
    public let pause: Bool
    public let surrender: Bool
}
