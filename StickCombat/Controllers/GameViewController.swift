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
        combatScene.RequestStatus(status: .surrender)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
            let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "MenuViewController")
            self.present(destinationViewController, animated: true, completion: nil)
        }
    }


    //MARK: JOYSTICKS VIEWS
    @IBOutlet weak var firstFighterStick: JoystickStickView!
    
    
    @IBOutlet weak var firstFighterButtons : JoystickButtonsView!


    private func hideJoysticks(){
        self.firstFighterStick.isHidden = true
        self.firstFighterButtons.isHidden = true
    }


    private func showJoysticks(){
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

    ///Сцена ничьи
    private let drawScene : SKScene = SKScene(fileNamed: "DrawScene")!

    ///Сцена сдачи
    private let surrenderScene : SKScene = SKScene(fileNamed: "SurrenderScene")!

    ///Сцена паузы
    private let pauseScene : SKScene = SKScene(fileNamed: "PauseScene")!


    var View: SKView {
        return self.view as! SKView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        combatScene.scaleMode = .fill
        receptionScene.scaleMode = .resizeFill
        pauseScene.scaleMode = .resizeFill
        refusedConnectionScene.scaleMode = .resizeFill
        lostConnectionScene.scaleMode = .resizeFill
        surrenderScene.scaleMode = .resizeFill
        victoryScene.scaleMode = .resizeFill
        defeatScene.scaleMode = .resizeFill
        drawScene.scaleMode = .resizeFill


        combatScene.lobbyDelegate = self
        View.ignoresSiblingOrder = true

        //дебаг
        //View.showsFPS = true
        //View.showsNodeCount = true

        View.presentScene(receptionScene)

        //Mode = .pvpNet(playerID: .second, adress: URL(string: "ws://192.168.0.106:8080")!, lobbyName: "test", lobbyPassword: "228")
    }
    

    ///Обработка изменения статуса лобби
    func statusChanged(_ status: LobbyStatusEnum) {
        switch status {
        case .fight:
            //print("Статус: fight")
            View.presentScene(combatScene,transition: .doorsOpenHorizontal(withDuration: 0.2))
            showJoysticks()
            View.presentScene(combatScene)
        case .casting:
            //print("Статус: casting")
            View.presentScene(receptionScene,transition: .doorsCloseHorizontal(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(receptionScene)
        case .ConnectionLost:
            //print("Статус: connection lost")
            View.presentScene(lostConnectionScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(lostConnectionScene)
        case .over:
            //print("Статус: connection over")
            //print("Ошибка. Должен быть перевод на surrender,victory или defeat")
            break
        case .surrender:
            //print("Статус: surrender")
            View.presentScene(surrenderScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(surrenderScene)
        case .refused:
            //print("Статус: connection refused")
            View.presentScene(refusedConnectionScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(refusedConnectionScene)
        case .pause:
            //print("Статус: pause")
            View.presentScene(pauseScene,transition: .doorsCloseHorizontal(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(pauseScene)
        case .victory:
            //print("Статус: victory")
            View.presentScene(victoryScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(victoryScene)
        case .defeat:
            //print("Статус: defeat")
            View.presentScene(defeatScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(defeatScene)
        case .draw:
            //print("Статус: draw")
            View.presentScene(drawScene,transition: .flipVertical(withDuration: 0.2))
            hideJoysticks()
            View.presentScene(drawScene)
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
        let min = timeLeft.0
        let sec = timeLeft.1

        var text = ""

        if min < 10 && min != 0{
            text += "0"
        }
        text += "\(min):"

        if sec < 10 && sec != 0{
            text += "0"
        }
        text += "\(sec)"

        timeLeftLabel.text = text
    }
    

    //MARK: VIEW PREFERENCES
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
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
