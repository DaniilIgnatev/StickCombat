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
    private var Logic : LogicManager? = nil
    

    ///Набор джостиков для управления бойцами
    var Joysticks : JoystickSet?
    

    ///Подготовить игровую логику
    func SetUpGameLogic(mode : GameMode, joysticks : JoystickSet){
     
        self.Joysticks = joysticks
        
        let firstFighterNode = childNode(withName: "fighter_1") as! SKSpriteNode
        let secondFighterNode = childNode(withName: "fighter_2") as! SKSpriteNode
        
        Logic = LogicManagerFactory.BuildLogicFor(gameMode: mode, joysticks: Joysticks!, firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode)
        Logic!.delegate = self
    }


    ///Действия при изменении статуса
    func statusChanged(_ status: LobbyStatusEnum) {
        lobbyDelegate?.statusChanged(status)
    }


    ///Действия при переходе на сцену (игра началась)
    override func didMove(to view: SKView) {
        
        /*
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w, height: w))
*/
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
