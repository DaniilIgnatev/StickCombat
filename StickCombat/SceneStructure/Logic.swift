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
    case pvpNet(playerID : FighterID, adress : URL, lobbyName : String, lobbyPassword : String)
    case pvpLocal
    case pveLocal(playerID : FighterID)
}


protocol LogicManager : ActionEngineDelegate {
    
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
    static func BuildLogicFor(gameMode : GameMode, joysticks : JoystickSet, firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode) -> LogicManager?{
        switch gameMode {
        case .pvpNet(let fighterID, let adress, let name, let password):
            return ServerLogicManager(fighterID: fighterID, firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode, joysticks: joysticks, adress: adress, lobbyName: name,lobbyPassword: password)
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


    init(fighterID : FighterID, firstFighterNode: SKSpriteNode, secondFighterNode: SKSpriteNode, joysticks : JoystickSet, adress : URL, lobbyName : String, lobbyPassword : String) {
        self.fighterID = fighterID
        self.joysticks = joysticks
        self.adress = adress


        //инициализация представления сцены
        self.sceneDescriptor = SceneCondition(firstX: -130, secondX: 130)

        self.View1 = FighterView(id : .first,node: firstFighterNode,direction : .left)
        self.View2 = FighterView(id : .second,node: secondFighterNode,direction : .right)

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

        requestConnectionAction(ConnectionAction(fighter: fighterID, name: lobbyName, password: lobbyPassword))
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
        delegate?.statusChanged(.ConnectionLost)
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


    func requestConnectionAction(_ action : ConnectionAction) {
        //отправить connection action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.connectionActionToJSON(connectionAction: action)
            self.socket.write(string: json)
        }
    }


    func requestGameAction(_ action : GameAction) {
        //отправить game action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.gameActionToJSON(gameAction: action)
            self.socket.write(string: json)
        }
    }


    func requestStatusAction(_ action : StatusAction) {
        //отправить status action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.statusActionToJSON(statusAction: action)
            self.socket.write(string: json)
        }
    }


    //MARK: WS ANSWER

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
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


    //MARK: CONDITION UPDATE
    func processHorizontalAction(_ action : HorizontalAction){
        if action.Fighter == .first{
            self.sceneDescriptor.fighter_1.X = action.To
            self.View_1.playMoveAction(moveAction: action)
        }
        else{
             self.sceneDescriptor.fighter_2.X = action.To
            self.View_1.playMoveAction(moveAction: action)
        }
    }


    func processStrikeAction(_ action : StrikeAction){
        if action.Fighter == .first{
            self.sceneDescriptor.fighter_1.hp -= self.sceneDescriptor.fighter_1.hp
            self.View_1.playStrikeAction(action: action)
        }
        else{
            self.sceneDescriptor.fighter_2.hp -= self.sceneDescriptor.fighter_2.hp
            self.View_1.playStrikeAction(action: action)
        }
    }


    func processBlockAction(_ action : BlockAction){
        if action.Fighter == .first{
            self.sceneDescriptor.fighter_1.isBlock = action.IsOn
            //self.View_1
        }
        else{
            self.sceneDescriptor.fighter_2.isBlock = action.IsOn
            //self.View_1.playStrikeAction(action: action)
        }
    }

    func processStatusAction(_ action : StatusAction){
        self.sceneDescriptor.status = action.statusID
        delegate?.statusChanged(sceneDescriptor.status)
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
