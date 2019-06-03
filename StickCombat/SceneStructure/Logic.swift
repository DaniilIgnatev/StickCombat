//
//  LogicController.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit
import Starscream


enum GameMode {
    case pvpNet(playerID : FighterID, nickname : String, adress : URL, lobbyName : String, lobbyPassword : String)
    case pvpLocal
    case pveLocal(playerID : FighterID)
}


protocol LogicManager : ActionEngineDelegate {

    func StopProcessingLogic()
    
    var delegate : LobbyDelegate? {get set}
    
    
    var joysticks : JoystickSet {get}
    
    
    var View_1 : FighterView{ get }
    
    
    var View_2 : FighterView {get }
    
    
    var Engine_1 : ActionEngine?{get}
    
    
    var Engine_2 : ActionEngine?{get}
    
    
    var FighterID : FighterID{get}
    
    ///Описывается все положение сцены
    var SceneDescriptor : SceneCondition {get}
    
    
    func requestGameAction(_ action : GameAction)

    
    func requestConnectionAction(_ action : ConnectionAction)

    
    func requestStatusAction(_ action : StatusAction)
    
}


class LogicManagerFactory {
    static func BuildLogicFor(gameMode : GameMode, joysticks : JoystickSet, firstFighterNode : SKSpriteNode, firstHpNode : SKLabelNode, secondFighterNode : SKSpriteNode, secondHpNode : SKLabelNode) -> LogicManager?{
        switch gameMode {
        case .pvpNet(let fighterID,let nickname, let adress, let name, let password):
            return ServerLogicManager(fighterID: fighterID, nickname: nickname, firstFighterNode: firstFighterNode, firstHpNode: firstHpNode, secondFighterNode: secondFighterNode, secondHpNode: secondHpNode, joysticks: joysticks, adress: adress, lobbyName: name,lobbyPassword: password)
        default:
            return nil
        }
    }
}


///Алгоритм игры по протоколу websocket
class ServerLogicManager: LogicManager, WebSocketDelegate, WebSocketPongDelegate {

    //MARK: INIT
    
    let joysticks: JoystickSet
    
    
    var delegate: LobbyDelegate?
    

    private var fighterID : FighterID
    var FighterID: FighterID{
        return fighterID
    }
    
    private var View1 : FighterView
    var View_1: FighterView{
        return View1
        
    }
    
    private var View2 : FighterView
    var View_2: FighterView{
        return View2
    }
    
    fileprivate var Engine1: ActionEngine?
    var Engine_1: ActionEngine?{
        return Engine1
    }
    
    fileprivate var Engine2: ActionEngine?
    var Engine_2: ActionEngine?{
        return Engine2
    }
    
    private var sceneDescriptor: SceneCondition
    var SceneDescriptor: SceneCondition{
        return sceneDescriptor
    }


    ///Дескриптор играющего бойца
    private var playingFighterDescriptor : FighterPresence{
        return fighterID == .first ? self.sceneDescriptor.fighter_1 : self.sceneDescriptor.fighter_2
    }


    ///Дескриптор бойца оппонента
    private var opponentFighterDescriptor : FighterPresence{
        return fighterID == .first ? self.sceneDescriptor.fighter_2 : self.sceneDescriptor.fighter_1
    }


    ///Осталось играть минут
    private var GameTimeLeft_Minutes : Int = 2

    ///Осталось играть секунд
    private var GameTimeLeft_Seconds : Int = 0


    private var gameTimer : Timer? = nil

    
    private func decreaseGameTime(){
        if GameTimeLeft_Seconds != 0 || GameTimeLeft_Minutes != 0{
            if GameTimeLeft_Seconds == 0{
                GameTimeLeft_Minutes -= 1
                GameTimeLeft_Seconds = 59
            }
            else{
                GameTimeLeft_Seconds -= 1
            }
        }

        if GameTimeLeft_Minutes == 0 && GameTimeLeft_Seconds == 0{
            stopGameTimer()
            requestStatusAction(StatusAction(fighter: self.fighterID, statusID: .surrender))
        }

        delegate?.gameTimer(timeLeft: (GameTimeLeft_Minutes, GameTimeLeft_Seconds))
    }


    func stopGameTimer(){
        self.View1.FighterNode.removeAction(forKey: "gameTimer")
    }

    func startGameTimer(){
        if self.View1.FighterNode.action(forKey: "gameTimer") == nil{
            self.View1.FighterNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run
                {
                    self.decreaseGameTime()
                }
                ])
            ), withKey: "gameTimer")
        }
    }


    init(fighterID : FighterID, nickname: String, firstFighterNode: SKSpriteNode, firstHpNode : SKLabelNode, secondFighterNode: SKSpriteNode, secondHpNode : SKLabelNode, joysticks : JoystickSet, adress : URL, lobbyName : String, lobbyPassword : String) {
        self.fighterID = fighterID
        self.joysticks = joysticks
        self.adress = adress
        


        //инициализация представления сцены
        self.sceneDescriptor = SceneCondition(firstX: -130, secondX: 130)
        self.sceneDescriptor.fighter_1.nickname = nickname
        
        self.View1 = FighterView(id : .first,fighterNode: firstFighterNode, hpNode: secondHpNode,direction : .right)
        self.View2 = FighterView(id : .second,fighterNode: secondFighterNode,hpNode: firstHpNode,direction : .left)

        self.socket = WebSocket.init(url: adress)
        self.socket.delegate = self

        if fighterID == .first{
            Engine1 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor, joysticks: joysticks)
            Engine1?.delegate = self
        }else{
            Engine2 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor, joysticks: joysticks)
            Engine2!.delegate = self
        }
        
        requestQueue.isSuspended = true

        requestConnectionAction(ConnectionAction(fighter: fighterID, name: lobbyName, password: lobbyPassword, nickname: nickname))
        socket.connect()
    }


    //MARK: WEB SOCKET
    
    private let parser = Parser()
    
    private let adress : URL

    private let socket : WebSocket

    func websocketDidConnect(socket: WebSocketClient) {
        requestQueue.isSuspended = false
        //doPingPong(interval: 5, timeout: 10)
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        processStatusAction(StatusAction.init(fighter: fighterID, statusID: .ConnectionLost))
    }


    //MARK: WS SESSION PINGPONG CONTROL
    
    private var pingTimer = Timer.init()
    private var pongTimer = Timer.init()
    private var pingBegan = false
    
    private var pingPongfails = 0
    private let maxpingPongFails = 2
    
    ///посылает команду пинг на сервер через interval секунд, ждет ответа и разрывает соединение через timeout секунд
    func doPingPong(interval : Double,timeout : Double){
        pingBegan = true
        pingTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
            //послать пинг
            
            self.socket.write(ping: String("This is the ping, call me back!").data(using: .utf8)!)
            print("PING at: \(Date.CurrentTime())")
            
            //через timeout времени оборвать соединение
            self.pongTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) {timer in
                if self.pingPongfails < self.maxpingPongFails{
                    self.pingPongfails += 1
                    print("WS: ping pong fails number = \(self.pingPongfails) of \(self.maxpingPongFails)")
                    self.doPingPong(interval: 0, timeout: 2)
                }
                else{
                    print("WS: Connection droped-out of the \(self.adress.absoluteString) at: \(Date.CurrentTime())")
                    self.socket.disconnect(forceTimeout: 0, closeCode: 0)
                }
            }
        }
    }
    
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        self.pingPongfails = 0
        print("PONG at: \(Date.CurrentTime())")
        pingTimer.invalidate()
        pongTimer.invalidate()
        doPingPong(interval: 5, timeout: 10)
    }


    //MARK: WS REQUEST

    private let requestQueue = OperationQueue.init()

    private var isProcessAnswers = true

    ///Остановка обработки данных
    func StopProcessingLogic() {
        isProcessAnswers = false
        requestQueue.isSuspended = true
        //requestQueue.cancelAllOperations()
        socket.disconnect()
    }


    ///Запрос соединения действия
    func requestConnectionAction(_ action : ConnectionAction) {
        //отправить connection action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.connectionActionToJSON(connectionAction: action)
            self.socket.write(string: json)
        }
    }

    ///Запрос игрвого действия
    func requestGameAction(_ action : GameAction) {
        //отправить game action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.gameActionToJSON(gameAction: action)
            self.socket.write(string: json)
        }
    }


    ///Запрос статуса действия
    func requestStatusAction(_ action : StatusAction) {
        if action.statusID == .surrender{
            if action.statusID != .surrender && action.statusID != .defeat && action.statusID != .over && action.statusID != .victory{
                SceneDescriptor.status = .defeat//поражение не требует подтверждения
            }

            //остановка движка по таймеру
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (_) in
                self.StopProcessingLogic()
            }
        }

        //отправить status action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.statusActionToJSON(statusAction: action)
            self.socket.write(string: json)
        }
    }


    //MARK: WS ANSWER
    ///Обработчик входящих сообщений от сокета
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard isProcessAnswers else{
            return
        }

        //обработка ответа от сервера
        let type = parser.defineAction(action: text)
        switch type {
        case .Strike:
            let action = parser.JSONToGameAction(json: text) as! StrikeAction
            processStrikeAction(action)
            break
        case .Horizontal:
            let action = parser.JSONToGameAction(json: text) as! HorizontalAction
            processHorizontalAction(action)
            break
        case .Block:
            let action = parser.JSONToGameAction(json: text) as! BlockAction
            processBlockAction(action)
            break
        case .Status:
            let action = parser.JSONToStatusAction(json: text)
            //обновить состояние сцены, распространить выше, если требуется
            processStatusAction(action)
            break
        default:
            break
        }
    }


    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        //не используется
    }


    ///Обработка расположения надписи хп
    private func updateHPNodePosition(label: SKLabelNode,from: CGFloat, to: CGFloat){
        let duration =  FighterView.calculateTimeOfMoveAnimation(from: from, to: to)
        label.run(SKAction.move(to: CGPoint(x: to, y: label.position.y), duration: duration))
    }

    ///Обработка ответа передвижения
    private func processHorizontalAction(_ action : HorizontalAction){
        //let (direct1,direct2) = determineDirection()

        if action.Fighter == .first{
            self.sceneDescriptor.fighter_1.X = action.To
            self.sceneDescriptor.fighter_1.direction = .right
            self.View1.Direction = .right
            self.View_1.playMoveAction(moveAction: action)
            updateHPNodePosition(label: View1.hpNode, from: View1.hpNode.position.x, to: sceneDescriptor.fighter_1.X)
        }
        else{
            self.sceneDescriptor.fighter_2.X = action.To
            self.sceneDescriptor.fighter_2.direction = .left
            self.View2.Direction = .left
            self.View_2.playMoveAction(moveAction: action)
            updateHPNodePosition(label: View2.hpNode, from: View2.hpNode.position.x, to: sceneDescriptor.fighter_2.X)
        }
    }
    
    
    ///Обновления надписи хп
    private func updateHPNodeContent(label: SKLabelNode,endHp : CGFloat){
        let intHp = Int(endHp)
        label.text = "\(intHp)"
    }
    

    ///Обработка ответа удара
    private func processStrikeAction(_ action : StrikeAction){
        if action.Fighter == .first{
            //удар, вызваный первым бойцом
            self.sceneDescriptor.fighter_2.hp = action.endHP!
            self.View_1.playStrikeAction(strikeAction: action)
            updateHPNodeContent(label: View_2.hpNode,endHp: sceneDescriptor.fighter_2.hp)
        }
        else{
            //удар, вызваный вторым бойцом
            self.sceneDescriptor.fighter_1.hp = action.endHP!
            self.View_2.playStrikeAction(strikeAction: action)
            updateHPNodeContent(label: View_1.hpNode,endHp: sceneDescriptor.fighter_1.hp)
        }
    }


    ///Обработка ответа блока
    private func processBlockAction(_ action : BlockAction){
        if action.Fighter == .first{
            self.sceneDescriptor.fighter_1.isBlock = action.IsOn

            if action.IsOn{
                self.View_1.playBlockAction()
            }
            else{
                self.View_1.stopBlockAction()
            }
        }
        else{
            self.sceneDescriptor.fighter_2.isBlock = action.IsOn

            if action.IsOn{
                self.View_2.playBlockAction()
            }
            else{
                self.View_2.stopBlockAction()
            }
        }
    }


    ///Обработка ответа статуса
    private func processStatusAction(_ action : StatusAction){
        switch action.statusID {
        case .refused:
            processRefusedStatusAnswer()
        case .pause:
            processPauseStatusAnswer()
        case .fight:
            processFightStatusAnswer(nicknames: action.nicknames)
        case .over:
            processOverStatusAnswer()
        case .surrender:
            processSurrenderStatusAnswer()
        case .ConnectionLost:
            processConnectionLostStatusAnswer()
        default:
            self.sceneDescriptor.status = self.sceneDescriptor.status//без изменений
        }

        delegate?.statusChanged(sceneDescriptor.status)
    }


    private func processRefusedStatusAnswer(){
        stopGameTimer()
        self.sceneDescriptor.status = .refused
    }


    private func processPauseStatusAnswer(){
        stopGameTimer()
        self.sceneDescriptor.status = .pause
    }


    private func processDrawStatusAnswer(){
        stopGameTimer()
        self.sceneDescriptor.status = .pause
    }


    private func processFightStatusAnswer(nicknames : (String,String)?){
        if let nicknames = nicknames{
            self.sceneDescriptor.fighter_1.nickname = nicknames.0
            self.sceneDescriptor.fighter_2.nickname = nicknames.1
        }
        startGameTimer()

        self.sceneDescriptor.status = .fight
        self.delegate?.sceneCondition(condition: self.sceneDescriptor)
    }


    private func processOverStatusAnswer(){
        stopGameTimer()
        let myFighter = playingFighterDescriptor
        let opponentFighter = opponentFighterDescriptor


        //уточнение итогов окончания матча
        if  myFighter.hp <= opponentFighter.hp{
            self.sceneDescriptor.status = .defeat
        }
        else{
            self.sceneDescriptor.status = .victory
        }

    }


    private func processSurrenderStatusAnswer(){
        stopGameTimer()

        if sceneDescriptor.status == .over || sceneDescriptor.status == .fight || sceneDescriptor.status == .defeat || sceneDescriptor.status == .victory{
            //блокировка от установления статуса surrender, у перечисленных статусов ниже приоритет выше
            return
        }
        else{
            if sceneDescriptor.status == .fight && GameTimeLeft_Minutes == 0 && GameTimeLeft_Seconds < 2{//таймер игры закончился -- ничья
                sceneDescriptor.status = .draw
                return
            }
        }

        sceneDescriptor.status = .surrender
    }


    private func processConnectionLostStatusAnswer(){
        stopGameTimer()
        //статусы ниже считаются приоритетнее чем потеря соединения или предусматривают ее
        if sceneDescriptor.status != .surrender && sceneDescriptor.status != .draw && sceneDescriptor.status != .over && sceneDescriptor.status != .defeat && sceneDescriptor.status != .victory {
            self.sceneDescriptor.status = .ConnectionLost
        }
    }
}



fileprivate extension Date{
    
    ///Формирует дату и время по одиночным параметрам
    static func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hr
        components.minute = min
        components.second = sec
        let date = calendar.date(from: components as DateComponents)
        return date!
    }
    
    
    ///Формирует дату и время по строке, предоставленной сервером
    static func convertToDayTime(from string : String) -> Date?{
        
        let values = string.split(separator: " ")
        
        guard values.count == 2 else {
            return nil
        }
        
        let date = values[0]
        let time = values[1]
        
        let dateValues = date.split(separator: ".")
        let timeValues = time.split(separator: ":")
        
        guard timeValues.count == 3 && dateValues.count == 3 else {
            return nil
        }
        
        let day = Int(dateValues[0])
        let month = Int(dateValues[1])
        let year = Int(dateValues[2])
        let hours = Int(timeValues[0])
        let minutes = Int(timeValues[1])
        let seconds = Int(timeValues[2])
        
        guard day != nil && month != nil && year != nil && hours != nil && minutes != nil && seconds != nil else {
            return nil
        }
        
        return makeDate(year: year!, month: month!, day: day!, hr: hours!, min: minutes!, sec: seconds!)
    }
    
    
    ///Текущие дата и время строкой в указанном стиле
    static func CurrentTime(style : DateFormatter.Style = DateFormatter.Style.medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        
        let timeString = dateFormatter.string(from: Date())
        return timeString
    }
    
}
