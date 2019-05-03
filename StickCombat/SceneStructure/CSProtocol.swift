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
    
    public func connectionActionToJSON(connectionaction: ConnectionAction) -> String{
        //ЭТО МОЙ ПРИМЕР ЧТОБЫ НЕ ЗАБЫТЬ ЧТО-ТО
        
//        if let name = nameCardsBox.text{
//            if name != ""{
//                let nameWOSpaces = name.replacingOccurrences(of: " ", with: "%20")
//
//                //MARK: Формирую строку запроса на основе введенного названия карты
//                let addPart = "cards/\(nameWOSpaces)"
//                let nameCardsURL = URL(string: hsURLString + addPart)
//
//                //TODO: При неверном имени карты выдает ошибку, так как nil. Исправить!
//                var hsRequest = URLRequest(url: nameCardsURL!)
//                hsRequest.allHTTPHeaderFields = hsHeaders
//                hsRequest.httpMethod = "GET"
//                hsRequest.httpBody = Data()
//                hsRequest.addValue("contentType", forHTTPHeaderField: "Application/JSON")
//
//                let request = URLSession.shared.dataTask(with: hsRequest, completionHandler: {data, response, error in
//                    if error == nil {
//                        do {
//                            //MARK: Парсинг полученной структурки в структурку hsCard
//                            let json = try JSONDecoder().decode([hsCard].self, from: data!)
//                            DispatchQueue.main.async {
//                                searchCardImage = json.map({ (card: hsCard) in return card.img ?? ""}).first
//                                searchCardGoldImage = json.map({ (card: hsCard) in return card.imgGold ?? ""}).first
//                                //MARK: Переход на одиночную вьюху
//                                let singleStoryboard = UIStoryboard(name: "SingleViews", bundle: Bundle.main)
//                                guard let destViewController = singleStoryboard.instantiateViewController(withIdentifier: "SingleCardViewController") as? SingleCardViewController  else {
//                                    return
//                                }
//                                destViewController.modalTransitionStyle = .crossDissolve
//                                self.present(destViewController, animated: true, completion: nil)
//                            }
//                        } catch {
//                            print(error)
//                        }
//                    } else {
//                        print(error ?? "Undefined error")
//                    }
//                }
//                )
//                request.resume()
//            }else{
//                //MARK: Если пользователь ничего не ввел в TextField
//                nameCardsBox.text = nil
//                nameCardsBox.placeholder = "Please enter the name"
//            }
//        }
        let somestring: String = ""
        return somestring
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
        let name: String
        let password: String
    }
    
    let head: Head
    let body: Body
    
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
