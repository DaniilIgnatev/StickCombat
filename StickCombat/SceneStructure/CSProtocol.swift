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


    public func defineAction(action: String) -> GameActionType{
        let data = Data(action.utf8)
        

        if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let head = json["head"] as? [String:Any] {
                if let type = head["type"] as? String {
                    switch type{
                    case "status":
                        return .Status
                    case "strikeApprove":
                        return .Strike
                    case "horizontalMoveApprove":
                        return .Horizontal
                    case "blockApprove":
                        return .Block
                    default:
                        return .Connection
                    }
                }
            }
        }

        return .Connection
    }


    //+
    public func connectionActionToJSON(connectionAction: ConnectionAction) -> String{
        let action = connectionAction

        var type = "createLobby"
        if action.Fighter == .second{
            type = "joinLobby"
        }
        let jsonStruct = ConnectionJSON(head: Head(id: action.Fighter.hashValue, type: type), body: ConnectionJSON.Body(name: action.name, password: action.password))

        let json = String.init(data: try! JSONEncoder().encode(jsonStruct), encoding: .utf8)!
        return json
    }


    //+
    public func gameActionToJSON(gameAction: GameAction) -> String{

        if let action = gameAction as? StrikeAction{
            let jsonStruct = GameActionStrikeJSON(head: Head(id: action.Fighter.hashValue, type: "strike"), body: GameActionStrikeJSON.Body(x: action.Point.x, y: action.Point.y, dx: action.Vector.dx
                , dy: action.Vector.dy, endHP: nil))
            do{
                let json = String.init(data: try JSONEncoder().encode(jsonStruct), encoding: .utf8)!
                return json
            }catch{
                return ""
            }
        }else if let action = gameAction as? HorizontalAction{
            let jsonStruct = GameActionMoveJSON(head: Head(id: action.Fighter.hashValue, type: "horizontalMove"), body: GameActionMoveJSON.Body(from: action.From, to: action.To, by: action.By))
            do{
                let json = String.init(data: try JSONEncoder().encode(jsonStruct), encoding: .utf8)!
                return json
            }catch{
                return ""
            }
        }else if let action = gameAction as? BlockAction{
            let jsonStruct = GameActionBlockJSON(head: Head(id: action.Fighter.hashValue, type: "block"), body: GameActionBlockJSON.Body(isOn: action.IsOn))
            do{
                let json = String.init(data: try JSONEncoder().encode(jsonStruct), encoding: .utf8)!
                return json
            }catch{
                return ""
            }
        }else{
            print("Undefined GameAction")
            return ""
        }
    }


    public func JSONToGameAction(json: String) -> GameAction{
        let data = Data(json.utf8)
        
        do{
            if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let body = response["body"] as? [String:Any]
                
                if let head = response["head"] as? [String:Any] {
                    let fighter = head["id"] as! FighterID
                    
                    if let type = head["type"] as? String {
                        //Если тип "Удар"
                        if type == "strikeApprove"{
                            let x = body?["x"] as! CGFloat
                            let y = body?["y"] as! CGFloat
                            let dx = body?["dx"] as! CGFloat
                            let dy = body?["dy"] as! CGFloat
                            
                            let action = StrikeAction(fighter: fighter, vector: CGVector(dx: dx, dy: dy), point: CGPoint(x: x, y: y))
                            return action
                            //Если тип "Передвижение"
                        }else if type == "horizontalMoveApprove"{
                            let from = body?["from"] as! CGFloat
                            let to = body?["to"] as! CGFloat
                            
                            let action = HorizontalAction(fighter: fighter, from: from, to: to)
                            return action
                            //Если тип "Блок"
                        }else if type == "blockApprove"{
                            let isOn = body?["isOn"] as! Bool
                            
                            let action = BlockAction(fighter: fighter, isOn: isOn)
                            return action
                        }
                    }
                }
            }
        }catch let error as NSError{
            fatalError("Error: \(error)")
        }
        fatalError()
    }

    //+
    public func statusActionToJSON(statusAction: StatusAction) -> String{
        let action = statusAction
        let id = action.Fighter
        

        let jsonStruct = StatusJSON(head: Head(id: id.rawValue, type: "status"), body: StatusJSON.Body(code: 0, description: ""))
        do{
            let json = String.init(data: try JSONEncoder().encode(jsonStruct), encoding: .utf8)!
            return json
        }catch{
            return ""
        }
    }

    //+
    public func JSONToStatusAction(json: String) -> StatusAction{
        let data = Data(json.utf8)
        
        do{
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let head = json["head"] as? [String:Any] {
                    if let type = head["type"] as? String {
                        if type == "status"{
                            let body = json["body"] as? [String:Any]
                            
                            let id = head["id"] as! FighterID
                            let code = body?["code"] as! Int
                            
                            let action = StatusAction(fighter: id, statusID: LobbyStatusEnum(rawValue: code)!)
                            return action
                        }else{
                            fatalError("Error")
                        }
                    }
                }
            }
        }catch let error as NSError{
            fatalError("Error: \(error)")
        }
        fatalError("Not a status action")
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
        let code: Int
        let description: String
    }
    let head: Head
    let body: Body
}
