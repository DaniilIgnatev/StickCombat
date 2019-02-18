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

    let stickRadius : CGFloat = 50
    
    let firstFighterStick = ControllerStickView.init(frame: CGRect(x: 0, y: 0, width: stickRadius, height: stickRadius))
    
    let firstFighterButtons = ControllerButtonsView.init(frame: CGRect(x: 0, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
                scene.SetUpGameLogic(mode: .pvpNet(figherID: .first, adress: URL(string: "ws://localhost:8080/")!))
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
}
