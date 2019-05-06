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
    
    @IBOutlet weak var firstFighterStick: JoystickStickView!
    
    @IBOutlet weak var firstFighterButtons : JoystickButtonsView!
    
    private var mode : GameMode?
    internal var Mode : GameMode?{
        get{
            return mode
        }
        set{
            mode = newValue
            
            if let mode = mode{
                //настройка джойстиков
                var joysticks : JoystickSet? = nil
                
                switch(mode){
                case .pvpNet:
                    joysticks = JoystickSet(fmJ: firstFighterStick, fsJ: firstFighterButtons, smJ: nil, ssJ: nil)
                    //
                    break
                case .pvpLocal:
                    joysticks = JoystickSet(fmJ: firstFighterStick, fsJ: firstFighterButtons, smJ: nil, ssJ: nil)
                    break
                case .pveLocal:
                    joysticks = JoystickSet(fmJ: firstFighterStick, fsJ: firstFighterButtons, smJ: nil, ssJ: nil)
                    break
                }
                
                scene.SetUpGameLogic(mode: mode, joysticks: joysticks!)
            }
        }
    }
    
    private var scene : GameScene = SKScene(fileNamed: "GameScene") as! GameScene
    
    var View: SKView {
        return self.view as! SKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        scene.scaleMode = .fill
        View.presentScene(scene)
        
        View.ignoresSiblingOrder = true
        
        View.showsFPS = true
        View.showsNodeCount = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        //firstFighterStick?.touchBeganInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchMovedInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchEndedInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
}
