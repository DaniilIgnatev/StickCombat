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
    case Strike, Horizontal, Vertical, Block, Status, Connection
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

class ConnectionAction : GameAction{
    var Kind: ActionType = .Connection

    var Fighter: FighterID

    public let name: String
    public let password: String

    init(fighter: FighterID, name: String, password: String) {
        self.Fighter = fighter
        self.name = name
        self.password = password
    }
}


class StatusAction : GameAction{
    var Kind: ActionType = .Status

    var Fighter: FighterID

    public let statusID: LobbyStatusEnum

    init(fighter: FighterID, statusID: LobbyStatusEnum) {
        self.Fighter = fighter
        self.statusID = statusID
    }
}


internal enum LobbyStatusEnum : Int{
    case refused = 0//участие в лобби отказано сервером
    case casting = 1//сервер ждет подключения второго игрока
    case fight = 2//идет поединок
    case pause = 3//поединок преостановлен
    case finished = 4//поединок завершен
    case ConnectionLost = 100//соединение с сервером утрачено
}
