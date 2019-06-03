//
//  GameScene.swift
//  StickCombat
//
//  Created by Даниил Игнатьев on 12/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import SpriteKit
import GameplayKit

class JoystickSet {
    internal var firstMoveJoystick : Joystick?
    internal var firstStrikeJoystick : Joystick?
    internal var secondMoveJoystick : Joystick?
    internal var secondStrikeJoystick : Joystick?
    
    init(fmJ : Joystick?, fsJ : Joystick?,smJ : Joystick?,ssJ:Joystick?) {
        firstMoveJoystick = fmJ
        firstStrikeJoystick = fsJ
        secondMoveJoystick = smJ
        secondStrikeJoystick = ssJ
    }
}


class CombatScene: SKScene, LobbyDelegate {
  
    
    var lobbyDelegate : LobbyDelegate? = nil


    ///Набор игровой логики
    internal var Logic : LogicManager? = nil

    ///Запросить изменение статуса извне
    func RequestStatus(status: LobbyStatusEnum) {
        Logic!.requestStatusAction(StatusAction(fighter: Logic!.FighterID, statusID: status, nickname1: nil, nickname2: nil))
    }


    ///Набор джостиков для управления бойцами
    var Joysticks : JoystickSet?
    

    ///Подготовить игровую логику
    func SetUpGameLogic(mode : GameMode, joysticks : JoystickSet){
     
        self.Joysticks = joysticks
        
        let firstFighterNode = childNode(withName: "fighter_1") as! SKSpriteNode
        firstFighterNode.physicsBody?.isDynamic = false
        firstFighterNode.physicsBody?.affectedByGravity = false
        
        let secondFighterNode = childNode(withName: "fighter_2") as! SKSpriteNode
        secondFighterNode.physicsBody?.isDynamic = false
        secondFighterNode.physicsBody?.affectedByGravity = false
        
        let firstHpNode = childNode(withName: "hp_1") as! SKLabelNode
        let secondHpNode = childNode(withName: "hp_2") as! SKLabelNode
        
        Logic = LogicManagerFactory.BuildLogicFor(gameMode: mode, joysticks: Joysticks!, firstFighterNode: firstFighterNode, firstHpNode: firstHpNode, secondFighterNode: secondFighterNode, secondHpNode: secondHpNode)
        Logic!.delegate = self
    }


    func gameTimer(timeLeft: (Int, Int)) {
        lobbyDelegate?.gameTimer(timeLeft: timeLeft)
    }


    ///Действия при изменении статуса
    func statusChanged(_ status: LobbyStatusEnum) {
        lobbyDelegate?.statusChanged(status)
    }
    
    
    func sceneCondition(condition: SceneCondition) {
        lobbyDelegate?.sceneCondition(condition: condition)
    }


    ///Действия при переходе на сцену (игра началась)
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    /*
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }*/
}
