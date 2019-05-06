//
//  CSProtocol.swift
//  StickCombat
//
//  Created by Даниил Игнатьев on 02/05/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit

//парсинг json
class Parser{
    
    public func defineAction(action: String) -> defineActionEnum{
        let json = action
        do{
            let parsedAction = try JSONDecoder().decode(Head.self, from: json.data(using: .utf8)!)
            if parsedAction.type == "pause" || parsedAction.type == "surrender"{
                return defineActionEnum.statusAction
            }else if parsedAction.type == "strike" || parsedAction.type == "horizontalMove" || parsedAction.type == "block"{
                return defineActionEnum.gameAction
            }else{
                return defineActionEnum.error
            }
        }catch{
            return defineActionEnum.error
        }
    }
    
    public func connectionActionToJSON(connectionaction: ConnectionAction) -> String{
        let action = connectionaction
        let jsonStruct = ConnectionJSON(head: Head(id: 0, type: "connection"), body: ConnectionJSON.Body(name: action.name, password: action.password))
        do{
            let json = try JSONEncoder().encode(jsonStruct)
            return json.base64EncodedString()
        }catch{
            return ""
        }

//        let somestring: String = ""
//        return somestring
    }
    
    public func gameActionToJSON(gameaction: GameAction) -> String{
        let somestring: String = ""
        return somestring
    }
    public func JSONToGameAction(json: String) -> GameAction{
        let gameAction = StrikeAction.init(fighter: FighterID.first, vector: CGVector(dx: 0, dy: 1), point: CGPoint(x: 0, y: 0))
        return gameAction
    }
    
    public func statusActionToJSON(status: StatusAction) -> String{
        let somestring: String = ""
        return somestring
    }
    public func JSONToStatusAction(json: String) -> StatusAction{
        let status = StatusAction.pause
        return status
    }
}


struct Head: Codable{
    let id: Int
    let type: String
}

struct ConnectionJSON: Codable{
    struct Body: Codable {
        var name: String
        var password: String
    }
    
    let head: Head
    var body: Body
}

struct GameActionStrikeJSON: Codable{
    
    struct Body: Codable{
        //Strike
        let x: Float
        let y: Float
        let dx: Float
        let dy: Float
        let endHP: Float
    }

    let head: Head
    let body: Body
}

struct GameActionBlockJSON: Codable{
    
    struct Body: Codable{
        //Block
        let isOn: Bool
    }
    
    let head: Head
    let body: Body
}

struct GameActionMoveJSON: Codable{
    
    struct Body: Codable{
        //Move
        let from: Float
        let to: Float
        let by: Float
    }
    
    let head: Head
    let body: Body
}


struct StatusJSON: Codable{
    struct Body: Codable{
        
    }
    let head: Head
    let body: Body
}

enum defineActionEnum{
    case statusAction
    case gameAction
    case error
}
