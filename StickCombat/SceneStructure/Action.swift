//
//  Action.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit



enum GameActionType {
    case Strike, Horizontal, Block, Status, Connection
}



protocol GameAction {
    
    var Kind: GameActionType {get}
    
    
    var Fighter : FighterID {get}
}


enum StrikeActionImpact : Int {
    case Jeb = 0
    case leftKick = 1
    case RightKick = 2
}


class StrikeAction: GameAction {
    
    private let kind : GameActionType
    public var Kind: GameActionType{
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


    public let Impact : StrikeActionImpact?


    public let Direction : FighterDirection?


    init(fighter: FighterID, impact : StrikeActionImpact, direction : FighterDirection) {
        self.kind = .Strike
        self.fighter = fighter
        self.Impact = impact
        self.Direction = direction
        self.Vector = nil
        self.Point = nil
        self.endHP = nil
    }


    public let Vector : CGVector?


    public let Point : CGPoint?


    public let endHP : CGFloat?


    init(fighter: FighterID, impact : StrikeActionImpact, vector : CGVector, point : CGPoint, endHP : CGFloat) {
        self.kind = .Strike
        self.fighter = fighter
        self.Vector = vector
        self.Point = point
        self.endHP = endHP
        self.Impact = impact
        self.Direction = nil
    }
}



class HorizontalAction: GameAction {
    
    private let kind : GameActionType
    public var Kind: GameActionType{
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
    
    private let kind : GameActionType
    public var Kind: GameActionType{
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
    var Kind: GameActionType = .Connection

    var Fighter: FighterID

    public let name: String
    public let password: String
    public let nickname: String

    init(fighter: FighterID, name: String, password: String, nickname: String) {
        self.Fighter = fighter
        self.name = name
        self.password = password
        self.nickname = nickname
    }
}


class StatusAction : GameAction{
    var Kind: GameActionType = .Status
    
    var Fighter: FighterID

    public let statusID: LobbyStatusEnum
    public var nicknames: (String,String)? = nil

    init(fighter: FighterID, statusID: LobbyStatusEnum, nickname1: String?, nickname2: String?) {
        self.Fighter = fighter
        self.statusID = statusID
        
        if nickname1 != nil && nickname2 != nil{
            self.nicknames = (nickname1!,nickname2!)
        }
    }
    
    convenience init(fighter: FighterID, statusID: LobbyStatusEnum) {
        self.init(fighter: fighter,statusID: statusID,nickname1: nil,nickname2: nil)
        self.nicknames = nil
    }
}


internal enum LobbyStatusEnum : Int{
    case refused = 0//участие в лобби отказано сервером
    case casting = 1//сервер ждет подключения второго игрока
    case fight = 2//идет поединок
    case pause = 3//поединок преостановлен
    case over = 4//поединок завершен
    case surrender = 5//один из игроков досрочно завершил игру
    case ConnectionLost = 100//соединение с сервером утрачено по техническим причинам
    case victory = 101//победа
    case defeat = 102//поражение
    case draw = 103//ничья


     ///признак завершенной сессии, не заменяется другим статусом
    func isPersistent() -> Bool {
        if self == .surrender || self == .draw || self == .over || self == .defeat || self == .victory{
            return true
        }
        else{
            return false
        }
    }
}
