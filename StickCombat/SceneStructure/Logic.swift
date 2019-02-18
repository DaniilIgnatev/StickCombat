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
    case pvpNet(figherID : FighterID, moveController : Joystick, strikeController : Joystick , adress : URL)
    case pvpLocal(figherID : FighterID, firstMoveController : Joystick, firstStrikeController : Joystick, secondMoveController : Joystick, secondStrikeController : Joystick)
    case pveLocal(figherID : FighterID, moveController : Joystick, strikeController : Joystick)
}



class LogicController : ActionEngineDelegate {
    
    fileprivate let View_1 : FighterView
    
    
    fileprivate let View_2 : FighterView
    
    
    internal var Engine_1 : ActionEngine? = nil
    
    
    internal var Engine_2 : ActionEngine? = nil
    
    
    fileprivate let Mode : GameMode
    
    
    ///Описывается все положение сцены
    fileprivate let sceneCondition = SceneCondition(firstShape: CGRect(x: -122.5, y: -92, width: 75, height: 150), secondShape: CGRect(x: 122.5, y: -92, width: 75, height: 150))
    
    
    func requestAction(_: Action) {
        
    }
    
    fileprivate init(firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode, gameMode : GameMode) {
        self.View_1 = FighterView(node: firstFighterNode)
        self.View_2 = FighterView(node: secondFighterNode)
        self.Mode = gameMode
        
        //определяются actionEngine ()
        switch Mode {
        case .pvpNet(let id,_,_,_):
            if id == .first{
                Engine_1 = GestureEngine(fighterID: id, condition: sceneCondition)
                Engine_1!.Delegate = self
            }
            else{
                Engine_2 = GestureEngine(fighterID: id, condition: sceneCondition)
                Engine_2!.Delegate = self
            }
        default:
            break
        }
        
        View_1.PlayAction(HorizontalAction(fighter: .first, from: View_1.FighterNode.position.x, to: sceneCondition.fighter_1.shape.origin.x))
        View_2.PlayAction(HorizontalAction(fighter: .second, from: View_2.FighterNode.position.x, to: sceneCondition.fighter_2.shape.origin.x))
    }
}



class ServerLogicController: LogicController {
    required init(firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode, gameMode : GameMode, adress : URL) {
        super.init(firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode, gameMode: gameMode)
    }
    
    
}
