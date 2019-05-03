//
//  CSProtocol.swift
//  StickCombat
//
//  Created by Даниил Игнатьев on 02/05/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation

//парсинг json
class Parser{
    
    func connectionToJSON(){
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
    }
    func connectionToAction(){
        
    }
    
    func gameActionToJSON(){
        
    }
    func gameActionToAction(){
        
    }
    
    func statusActionToJSON(){
        
    }
    func statusActionToAction(){
        
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

struct GameActionJSON: Codable{
    
    struct Body: Codable{
        //Strike
        let x: Float
        let y: Float
        let dx: Float
        let dy: Float
        let endHP: Float
        //Block
        let isOn: Bool
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
