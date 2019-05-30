//
//  FighterView.swift
//  StickCombat
//
//  Created by Daniil Ignatev on 17/02/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import SpriteKit


class FighterView {
    
    public let ID : FighterID
    
    public var Direction : FighterDirection
    
    public let FighterNode : SKSpriteNode
    
    //Текстурки не для анимаций
    private var defaultPositionsArray = [SKTexture]()
    private var defaultPositionsMirroredArray = [SKTexture]()
    //Массивы текстур левого бойца
    private var leftKickArray = [SKTexture]()
    private var moveArray = [SKTexture]()
    private var leftPunchArray = [SKTexture]()
    private var rightKickArray = [SKTexture]()
    private var rightPunchArray = [SKTexture]()
    //Массивы текстур правого бойца
    private var leftKickMirroredArray = [SKTexture]()
    private var moveMirroredArray = [SKTexture]()
    private var leftPunchMirroredArray = [SKTexture]()
    private var rightKickMirroredArray = [SKTexture]()
    private var rightPunchMirroredArray = [SKTexture]()
    
    init(id : FighterID, node : SKSpriteNode, direction : FighterDirection) {
        self.ID = id
        self.FighterNode = node
        self.Direction = direction
        //Инициализация массивов текстур не для анимаций
        self.defaultPositionsArray = initTextureArray(nameAtlas: "defaultPositions")
        self.defaultPositionsMirroredArray = initTextureArray(nameAtlas: "defaultPositionsMirrored")
        //Инициализация массивов текстур для левого бойца
        self.moveArray = initTextureArray(nameAtlas: "move")
        self.leftKickArray = initTextureArray(nameAtlas: "leftKick")
        self.leftPunchArray = initTextureArray(nameAtlas: "leftPunch")
        self.rightKickArray = initTextureArray(nameAtlas: "rightKick")
        self.rightPunchArray = initTextureArray(nameAtlas: "rightPunch")
        //Инициализация массивов текстур для правого бойца
        self.moveMirroredArray = initTextureArray(nameAtlas: "moveMirrored")
        self.leftKickMirroredArray = initTextureArray(nameAtlas: "leftKickMirrored")
        self.leftPunchMirroredArray = initTextureArray(nameAtlas: "leftPunchMirrored")
        self.rightKickMirroredArray = initTextureArray(nameAtlas: "rightKickMirrored")
        self.rightPunchMirroredArray = initTextureArray(nameAtlas: "rightPunchMirrored")
    }
    
    
    public func playStrikeAction(strikeAction : StrikeAction){
        
        if FighterNode.action(forKey: "strikeTexturesAnimation") != nil{
            print("Сontinue to animate")
        }else{
            if Direction == .left{
                switch strikeAction.Impact! {
                case .Jeb:
                    self.strikeAction(textureArray: leftPunchMirroredArray)
                case .leftKick:
                    self.strikeAction(textureArray: leftKickMirroredArray)
                case .RightKick:
                    self.strikeAction(textureArray: rightKickMirroredArray)
                }
            }else if Direction == .right{
                switch strikeAction.Impact! {
                case .Jeb:
                    self.strikeAction(textureArray: leftPunchArray)
                case .leftKick:
                    self.strikeAction(textureArray: leftKickArray)
                case .RightKick:
                    self.strikeAction(textureArray: rightKickArray)
                }
            }
        }
    }
    
    private func strikeAction(textureArray: [SKTexture]){
        FighterNode.removeAction(forKey: "strikeTexturesAnimation")
        FighterNode.removeAction(forKey: "moveTexturesAnimation")
        FighterNode.run(SKAction.animate(with: textureArray, timePerFrame: 0.05), withKey: "strikeTexturesAnimation")
    }
    
    //Создание таймера для отслеживания времени. Если в течении заданного промежутка не приходит экшн, удаляем все экшны у бойца
    var moveTimer: Timer?
    
    func createMoveTimer() -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (t) in
            if self.FighterNode.action(forKey: "moveTexturesAnimation") != nil{
                _ = self.createMoveTimer()
            }else{
                self.FighterNode.removeAction(forKey: "moveTexturesAnimation")
            }
        })
        return timer
    }
    
    public func playMoveAction(moveAction : HorizontalAction){
        
        if FighterNode.action(forKey: "moveTexturesAnimation") != nil{
            self.moveAction(from: moveAction.From, to: moveAction.To)
            print("Сontinue to animate")
            if let timer = moveTimer{
                timer.invalidate()
                moveTimer = createMoveTimer()
            }
        }else{
            switch Direction {
            case .left:
                self.moveAction(from: moveAction.From, to: moveAction.To)
                self.moveActionAnimation(textureArray: moveMirroredArray)
            case .right:
                self.moveAction(from: moveAction.From, to: moveAction.To)
                self.moveActionAnimation(textureArray: moveArray)
            }
            moveTimer = createMoveTimer()
        }
    }
    
    private func moveAction(from: CGFloat, to: CGFloat){
        let time = calculateTimeOfMoveAnimation(from: from, to: to)
        let actionMove = SKAction.moveTo(x: to, duration: time)
        FighterNode.run(actionMove, withKey: "movePositionAnimation")
    }
    private func moveActionAnimation(textureArray: [SKTexture]){
        let actionAnimate = SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.05))
        FighterNode.run(actionAnimate, withKey: "moveTexturesAnimation")
    }
    
    public func playBlockAction(){
        if Direction == .left{
            self.FighterNode.texture = defaultPositionsMirroredArray[1]
        }else{
            self.FighterNode.texture = defaultPositionsArray[1]
        }
    }
    public func stopBlockAction(){
        if Direction == .left{
            self.FighterNode.texture = defaultPositionsMirroredArray[0]
        }else{
            self.FighterNode.texture = defaultPositionsArray[0]
        }
    }
    
    private func initTextureArray(nameAtlas: String) -> [SKTexture]{
        let atlas = SKTextureAtlas(named: nameAtlas)
        var textures = [SKTexture]()
        
        for i in 0...(atlas.textureNames.count-1){
            let name = "\(i).png"
            textures.append(SKTexture(imageNamed: name))
        }
        
        return textures
    }
    
    private func calculateTimeOfMoveAnimation(from: CGFloat, to: CGFloat) -> Double{
        let length: Double = Double(to) - Double(from)
        let time = abs(length)/80
        return time
    }
}
