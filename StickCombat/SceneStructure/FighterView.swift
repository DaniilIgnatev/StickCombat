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
    
    //private var timer: Timer = Timer(timeInterval: 0, repeats: false, block: {_ in })
    
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
        
        if FighterNode.action(forKey: "strike") != nil{
            print("Сontinue to animate")
        }else{
            if Direction == .left{
                switch strikeAction.Impact! {
                case .Jeb:
                    self.strikeAction(textureArray: leftPunchArray)
                case .leftKick:
                    self.strikeAction(textureArray: leftKickArray)
                case .RightKick:
                    self.strikeAction(textureArray: rightKickArray)
                }
            }else if Direction == .right{
                switch strikeAction.Impact! {
                case .Jeb:
                    self.strikeAction(textureArray: leftPunchMirroredArray)
                case .leftKick:
                    self.strikeAction(textureArray: leftKickMirroredArray)
                case .RightKick:
                    self.strikeAction(textureArray: rightKickMirroredArray)
                }
            }
        }
    }
    
    private func strikeAction(textureArray: [SKTexture]){
        //FighterNode.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.05)))
        FighterNode.run(SKAction.animate(with: textureArray, timePerFrame: 0.05), withKey: "strike")
    }
    
    
    public func playMoveAction(moveAction : HorizontalAction){
        
        var timeLeft = 0.5
        
        if FighterNode.action(forKey: "moveAnimation") != nil{
            switch Direction {
            case .left:
                self.moveAction(from: moveAction.From, to: moveAction.To)
            case .right:
                self.moveAction(from: moveAction.From, to: moveAction.To)
            }
            print("Сontinue to animate")
            timeLeft = 0.5
        }else{
            switch Direction {
            case .left:
                self.moveAction(from: moveAction.From, to: moveAction.To)
                self.moveActionAnimation(textureArray: moveArray)
            case .right:
                self.moveAction(from: moveAction.From, to: moveAction.To)
                self.moveActionAnimation(textureArray: moveMirroredArray)
            }
        }
        //Создание таймера для отслеживания времени. Если в течении заданного промежутка не приходит экшн, удаляем все экшны у бойца
        var timer = Timer(timeInterval: 0.1, repeats: false){timer in
            timeLeft -= 0.1
            if timeLeft < 0{
                self.FighterNode.removeAllActions()
                timer.invalidate()
            }
        }
    }
    
    private func moveAction(from: CGFloat, to: CGFloat){
        let time = calculateTimeOfMoveAnimation(from: from, to: to)
        let actionMove = SKAction.moveTo(x: to, duration: time)
        FighterNode.run(actionMove, withKey: "move")
    }
    private func moveActionAnimation(textureArray: [SKTexture]){
        let actionAnimate = SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.05))
        FighterNode.run(actionAnimate, withKey: "moveAnimation")
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
        let time = length/80
        return time
    }
    
    @objc private func fireTimer(){
        self.FighterNode.removeAllActions()
    }
}
