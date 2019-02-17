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
    case coopNet
}



class LogicController : ActionEngineDelegate {
    
    fileprivate let View_1 : FighterView
    
    fileprivate let View_2 : FighterView
    
    fileprivate var Engine_1 : ActionEngine?
    
    fileprivate var Engine_2 : ActionEngine?
    
    fileprivate let Mode : GameMode
    
    func requestAction(_: Action) {
        
    }
    
    init(firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode, gameMode : GameMode) {
        self.View_1 = FighterView(node: firstFighterNode)
        self.View_2 = FighterView(node: secondFighterNode)
        self.Mode = gameMode
        
        SetUpGameMode()
    }
    
    func SetUpGameMode(){
        if Mode == .coopNet{
            Engine_1 = GestureEngine(fighterID: <#T##FighterID#>, condition: <#T##SceneCondition#>)
        }
    }
}
