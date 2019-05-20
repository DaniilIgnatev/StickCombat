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


protocol LobbyDelegate {
    func statusChanged(_ status : LobbyStatusEnum)
}


class GameViewController: UIViewController, LobbyDelegate  {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBOutlet weak var firstFighterStick: JoystickStickView!
    
    
    @IBOutlet weak var firstFighterButtons : JoystickButtonsView!
    

    //MARK: GAME SETUP
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
                
                combatScene.SetUpGameLogic(mode: mode, joysticks: joysticks!)
            }
        }
    }

    ///Сцена боя
    private let combatScene : CombatScene = CombatScene(fileNamed: "GameScene")!

    ///Сцена ожидания
    private let receptionScene : SKScene = SKScene(fileNamed: "ReceptionScene")!

    ///Сцена паузы
    private let pauseScene : SKScene = SKScene(fileNamed: "PauseScene")!


    var View: SKView {
        return self.view as! SKView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        combatScene.scaleMode = .fill
        receptionScene.scaleMode = .fill
        pauseScene.scaleMode = .fill
        
        View.ignoresSiblingOrder = true

        //дебаг
        View.showsFPS = true
        View.showsNodeCount = true

        //Mode = .pvpNet(playerID: .second, adress: URL(string: "ws://192.168.0.106:8080")!, lobbyName: "test", lobbyPassword: "228")
    }
    

    ///Обработка изменения статуса лобби
    func statusChanged(_ status: LobbyStatusEnum) {
        switch status {
        case .fight:
            View.presentScene(combatScene)
        case .casting:
            View.presentScene(receptionScene)
        case .ConnectionLost:
            //возврат в меню
            break
        case .finished:
            //показ сцены с результатами
            break
        case .refused:
            //возврат в меню
            break
        case .pause:
            View.presentScene(pauseScene)
        }
    }
    

    //MARK: VIEW PREFERENCES
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
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let superpos = touch.location(in: self.View)
        
        firstFighterStick?.MoveStick(superposition: superpos, touch: touch)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstFighterStick?.touchEndedInSuperView(touches.first!,superpos : touches.first!.location(in: view))
    }
}
