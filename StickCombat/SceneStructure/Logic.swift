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


    func requestConnectionAction(_: ConnectionAction) {

    }


    func requestGameAction(_: GameAction) {
        
    }


    func requestStatusAction(_: StatusAction) {

    }


    init(fighterID : FighterID, firstFighterNode: SKSpriteNode, secondFighterNode: SKSpriteNode, adress : URL) {
        self.fighterID = fighterID
        self.adress = adress
        
        let rectFiller = CGRect(x: 20, y: 20, width: 40, height: 80)
        self.sceneDescriptor = SceneCondition(firstShape: rectFiller, secondShape: rectFiller)
        
        self.View1 = FighterView(node: firstFighterNode)
        self.View2 = FighterView(node: secondFighterNode)
    }
    
    
    private let adress : URL
    
}
