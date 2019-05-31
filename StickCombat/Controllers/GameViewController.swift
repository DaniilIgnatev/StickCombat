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
    func gameTimer(timeLeft : (Int,Int))
    func sceneCondition(condition : SceneCondition)
}


class GameViewController: UIViewController, LobbyDelegate  {
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    //MARK: NAVIGATION

    @IBAction func pauseGame(_ sender: Any) {
        combatScene.RequestStatus(status: .pause)
    }


    @IBAction func surrenderGame(_ sender: Any) {
        if self.combatScene.Logic?.SceneDescriptor.status != LobbyStatusEnum.pause{
            combatScene.RequestStatus(status: .surrender)
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
                let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
                let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "MenuViewController")
                self.present(destinationViewController, animated: true, completion: nil)
            }
        }
    }


    //MARK: JOYSTICKS VIEWS
    @IBOutlet weak var firstFighterStick: JoystickStickView!
    
    
    @IBOutlet weak var firstFighterButtons : JoystickButtonsView!


    func hideJoysticks(){
        self.firstFighterStick.isHidden = true
        self.firstFighterButtons.isHidden = true
    }


    func showJoysticks(){
        self.firstFighterStick.isHidden = false
        self.firstFighterButtons.isHidden = false
    }


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
                hideJoysticks()
            }
        }
    }


    ///Сцена боя
    private let combatScene : CombatScene = CombatScene(fileNamed: "GameScene")!

    ///Сцена ожидания
    private let receptionScene : SKScene = SKScene(fileNamed: "ReceptionScene")!

    ///Сцена отколненного соединения
    private let refusedConnectionScene : SKScene = SKScene(fileNamed: "RefusedConnectionScene")!

    ///Сцена потеряного соединения
    private let lostConnectionScene : SKScene = SKScene(fileNamed: "LostConnectionScene")!

    ///Сцена победы
    private let victoryScene : SKScene = SKScene(fileNamed: "VictoryScene")!

    ///Сцена поражения
    private let defeatScene : SKScene = SKScene(fileNamed: "DefeatScene")!

    ///Сцена сдачи
    private let surrenderScene : SKScene = SKScene(fileNamed: "SurrenderScene")!

    ///Сцена паузы
    private let pauseScene : SKScene = SKScene(fileNamed: "PauseScene")!


    var View: SKView {
        return self.view as! SKView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        combatScene.scaleMode = .aspectFill
        receptionScene.scaleMode = .aspectFill
        pauseScene.scaleMode = .aspectFill
        refusedConnectionScene.scaleMode = .aspectFill
        lostConnectionScene.scaleMode = .aspectFill
        surrenderScene.scaleMode = .aspectFill
        victoryScene.scaleMode = .aspectFill
        defeatScene.scaleMode = .aspectFill


        combatScene.lobbyDelegate = self
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
            print("Статус: fight")
            showJoysticks()
            View.presentScene(combatScene,transition: .doorsOpenHorizontal(withDuration: 0.2))
        case .casting:
            print("Статус: casting")
            hideJoysticks()
            View.presentScene(receptionScene,transition: .doorsCloseHorizontal(withDuration: 0.2))
        case .ConnectionLost:
            print("Статус: connection lost")
            hideJoysticks()
            View.presentScene(lostConnectionScene,transition: .flipVertical(withDuration: 0.2))
        case .over:
            print("Статус: connection over")
            print("Ошибка. Должен быть перевод на surrender,victory или defeat")
        case .surrender:
            print("Статус: connection surrender")
            hideJoysticks()
            View.presentScene(surrenderScene,transition: .flipVertical(withDuration: 0.2))
        case .refused:
            print("Статус: connection refused")
            hideJoysticks()
            View.presentScene(refusedConnectionScene,transition: .flipVertical(withDuration: 0.2))
        case .pause:
            print("Статус: connection pause")
            hideJoysticks()
            View.presentScene(pauseScene,transition: .doorsCloseHorizontal(withDuration: 0.2))
        case .victory:
            print("Статус: connection victory")
            hideJoysticks()
            View.presentScene(victoryScene,transition: .flipVertical(withDuration: 0.2))
        case .defeat:
            print("Статус: connection defeat")
            hideJoysticks()
            View.presentScene(defeatScene,transition: .flipVertical(withDuration: 0.2))
        }
    }
    
    
    //MARK: SCENE CONDITION
    
    func sceneCondition(condition: SceneCondition) {
        nickname1.text = condition.fighter_1.nickname
        nickname2.text = condition.fighter_2.nickname
    }
    
    //MARK: NICKNAMES
    
    @IBOutlet var nickname1: UILabel!
    
    
    @IBOutlet var nickname2: UILabel!
    

    //MARK: GAME  TIMER
    @IBOutlet weak var timeLeftLabel: UILabel!


    func gameTimer(timeLeft: (Int, Int)) {
        timeLeftLabel.text = String(timeLeft.0) + ":" + String(timeLeft.1)
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
