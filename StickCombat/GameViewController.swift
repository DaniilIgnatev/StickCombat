//
//  GameViewController.swift
//  StickCombat
//
//  Created by Даниил Игнатьев on 12/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private let stickRadius : CGFloat = 50
    
    @IBOutlet weak var firstFighterStick: ControllerStickView!
    
    private var firstFighterButtons : ControllerButtonsView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstFighterButtons = ControllerButtonsView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
                scene.SetUpGameLogic(mode: .pvpNet(playerID: .first, moveController: firstFighterStick!, strikeController: firstFighterButtons!, adress: URL(string: "ws://localhost:8080/")!))
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchBeganInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchMovedInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchEndedInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
}
