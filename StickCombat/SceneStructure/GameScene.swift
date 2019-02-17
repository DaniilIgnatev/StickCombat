//
//  GameScene.swift
//  StickCombat
//
//  Created by Даниил Игнатьев on 12/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var Logic : LogicController? = nil
    

    
    public func SetUpGameLogic(mode : GameMode){
        var horizontalJoystickNode = childNode(withName: "HorizontalJoystick") as! Joystick
        let firstFighterNode = childNode(withName: "fighter_1") as! SKSpriteNode
        let secondFighterNode = childNode(withName: "fighter_2") as! SKSpriteNode
        
        horizontalJoystickNode.SceneSize = self.size

        switch mode {
        case .pvpNet(let fighter, let url):
            Logic = ServerLogicController(firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode, gameMode: mode, adress: url)
            
            if fighter == .first{
                horizontalJoystickNode.delegate = (Logic!.Engine_1 as! GestureEngine)
            }
            else{
                horizontalJoystickNode.delegate = (Logic!.Engine_2 as! GestureEngine)
            }
        default:
            break
        }
    }
    
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
        /*
        let fighter1 = childNode(withName: "fighterModel_1")!
        
        if let touchLocation = touches.first?.location(in: self){
            if fighter1.contains(touchLocation){
                fighter1.physicsBody!.applyImpulse(CGVector(dx: 50, dy: -30), at: touchLocation)
            }
        }
 */
        
        
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
