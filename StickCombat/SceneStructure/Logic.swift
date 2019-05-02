//
//  LogicController.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit



enum GameMode {
    case pvpNet(playerID : FighterID, adress : URL)
    case pvpLocal
    case pveLocal(playerID : FighterID)
}



protocol LogicController : ActionEngineDelegate {
    
    var View_1 : FighterView{ get }
    
    
    var View_2 : FighterView {get }
    
    
    var Engine_1 : ActionEngine?{get}
    
    
    var Engine_2 : ActionEngine?{get}
    
    var FighterID : FighterID{get}
    
    ///Описывается все положение сцены
    var SceneDescriptor : SceneCondition {get}
    
    
    func requestGameAction(_: GameAction)

    func requestConnectionAction(_: ConnectionAction)

    func requestStatusAction(_: StatusAction)
    
}

class LogicControllerFactory {
    static func BuildLogicFor(gameMode : GameMode, joysticks : JoystickSet, firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode) -> LogicController?{
        switch gameMode {
        case .pvpNet(let fighterID, let adress):
            return ServerLogicController(fighterID: fighterID, firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode, adress: adress)
        default:
            return nil
        }
    }
}

///Алгоритм игры по протоколу websocket
class ServerLogicController: LogicController {

    private var fighterID : FighterID
    var FighterID: FighterID{
        return fighterID
    }
    
    private var View1 : FighterView
    var View_1: FighterView{
        return View1
        
    }
    
    private var View2 : FighterView
    var View_2: FighterView{
        return View2
    }
    
    fileprivate var Engine1: ActionEngine?
    var Engine_1: ActionEngine?{
        return Engine1
    }
    
    fileprivate var Engine2: ActionEngine?
    var Engine_2: ActionEngine?{
        return Engine2
    }
    
    private var sceneDescriptor: SceneCondition
    var SceneDescriptor: SceneCondition{
        return sceneDescriptor
    }


    //MARK: REQUEST
    func requestConnectionAction(_: ConnectionAction) {
        //отправить connection action на сервер
    }


    func requestGameAction(_: GameAction) {
        //отправить game action на сервер
    }


    func requestStatusAction(_: StatusAction) {
        //отправить status action на сервер
    }



    init(fighterID : FighterID, firstFighterNode: SKSpriteNode, secondFighterNode: SKSpriteNode, adress : URL) {
        self.fighterID = fighterID
        self.adress = adress

        //инициализация представления сцены
        self.sceneDescriptor = SceneCondition(firstX: 20, secondX: 150)

        self.View1 = FighterView(id : .first,node: firstFighterNode)
        self.View2 = FighterView(id : .second,node: secondFighterNode)

        if fighterID == .first{
            Engine1 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor)
            Engine1?.Delegate = self
        }else{
            Engine2 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor)
            Engine2!.Delegate = self
        }
    }

    //MARK: SOCKET
    private let adress : URL

    //обработка ответа от сервера
    //MARK: ANSWER

}
