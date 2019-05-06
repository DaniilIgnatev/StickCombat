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
        let data = Data(action.utf8)
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let head = json["Head"] as? [String:Any] {
                    if let type = json["type"] as? String {
                        if type == "status"{
                            return defineActionEnum.statusAction
                        }else if type == "strikeApprove" || type == "horizontalMoveApprove" || type == "blockApprove"{
                            return defineActionEnum.gameAction
                        }else{
                            return defineActionEnum.error
                        }
                    }
                }
            }
        }catch let error as NSError{
            print("Error: \(error)")
            return defineActionEnum.error
        }
        return defineActionEnum.error
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
    }
    
//    public func gameActionToJSON(gameaction: GameAction) -> String{
//
//        if let action = gameaction as? StrikeAction{
//            //let jsonStruct = GameActionStrikeJSON(head: Head(id: action.Fighter.hashValue, type: <#T##String#>), body: GameActionStrikeJSON.Body(x: action.Point.x, y: action.Point.y, dx: action.Vector.dx
//                , dy: action.Vector.dy, endHP: nil))
//            do{
//                let json = try JSONEncoder().encode(jsonStruct)
//                return json.base64EncodedString()
//            }catch{
//                return ""
//            }
//        }else if let action = gameaction as? HorizontalAction{
//
//        }else if let action = gameaction as? BlockAction{
//
//        }
//
//
//
//
//        let action = gameaction
//        //let jsonStruct = ConnectionJSON(head: Head(id: 0, type: "connection"), body: ConnectionJSON.Body(name: action.name, password: action.password))
//        do{
//            let json = try JSONEncoder().encode(jsonStruct)
//            return json.base64EncodedString()
//        }catch{
//            return ""
//        }
//    }
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
        let x: CGFloat
        let y: CGFloat
        let dx: CGFloat
        let dy: CGFloat
        let endHP: CGFloat?
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
        let from: CGFloat
        let to: CGFloat
        let by: CGFloat
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
