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
    case pvpNet(playerID : FighterID, adress : URL)
    case pvpLocal
    case pveLocal(playerID : FighterID)
}


protocol LogicDelegate {
    func GameStatusChanged(status: SceneStatus)
}


protocol LogicController : ActionEngineDelegate {
    
    var delegate : LogicDelegate? {get}
    
    
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

class LogicControllerFactory {
    static func BuildLogicFor(gameMode : GameMode, joysticks : JoystickSet, firstFighterNode : SKSpriteNode , secondFighterNode : SKSpriteNode) -> LogicController?{
        switch gameMode {
        case .pvpNet(let fighterID, let adress):
            return ServerLogicController(fighterID: fighterID, firstFighterNode: firstFighterNode, secondFighterNode: secondFighterNode, joysticks: joysticks, adress: adress)
        default:
            return nil
        }
    }
}

///Алгоритм игры по протоколу websocket
class ServerLogicController: LogicController, WebSocketDelegate {
    
    
    let joysticks: JoystickSet
    
    
    var delegate: LogicDelegate?
    

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


    //MARK: REQUEST
    
    private let requestQueue = OperationQueue.init()
    
    func requestConnectionAction(_ action : ConnectionAction) {
        //отправить connection action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.connectionActionToJSON(connectionaction: action)
            self.socket.write(string: json)
        }
    }


    func requestGameAction(_ action : GameAction) {
        //отправить game action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.gameActionToJSON(gameaction: action)
            self.socket.write(string: json)
        }
    }


    func requestStatusAction(_ action : StatusAction) {
        //отправить status action на сервер
        //парсинг, отправка
        requestQueue.addOperation {
            let json = self.parser.statusActionToJSON(status: action)
            self.socket.write(string: json)
        }
    }



    init(fighterID : FighterID, firstFighterNode: SKSpriteNode, secondFighterNode: SKSpriteNode, joysticks : JoystickSet, adress : URL) {
        self.fighterID = fighterID
        self.joysticks = joysticks
        self.adress = adress
        self.socket = WebSocket.init(url: adress)

        //инициализация представления сцены
        self.sceneDescriptor = SceneCondition(firstX: 20, secondX: 150)

        self.View1 = FighterView(id : .first,node: firstFighterNode)
        self.View2 = FighterView(id : .second,node: secondFighterNode)

        if fighterID == .first{
            Engine1 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor, joysticks: joysticks)
            Engine1?.Delegate = self
        }else{
            Engine2 = GestureEngine(fighterID: fighterID, condition: sceneDescriptor, joysticks: joysticks)
            Engine2!.Delegate = self
        }
        
        requestQueue.isSuspended = true
    }

    //MARK: SOCKET
    
    private let parser = Parser()
    
    private let adress : URL

    private let socket : WebSocket

    func websocketDidConnect(socket: WebSocketClient) {
        requestQueue.isSuspended = false
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.GameStatusChanged(status: .ConnectionLost)
    }
    
    //MARK: WS TIMER
    
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
                if self.pingPongfails <= 3{
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

    //MARK: ANSWER

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
         //обработка ответа от сервера
        
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

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
