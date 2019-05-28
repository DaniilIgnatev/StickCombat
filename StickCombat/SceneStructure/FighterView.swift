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
    
    private func strikeAction(textureArray: [SKTexture]){
        FighterNode.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.05)))
    }

    
    public func playMoveAction(moveAction : HorizontalAction){
        switch Direction {
        case .left:
            self.moveAction(from: moveAction.From, to: moveAction.To, textureArray: moveArray)
        case .right:
            self.moveAction(from: moveAction.From, to: moveAction.To, textureArray: moveMirroredArray)
        }
    }
   
    private func moveAction(from: CGFloat, to: CGFloat, textureArray: [SKTexture]){
        let time = calculateTimeOfMoveAnimation(from: from, to: to)
        FighterNode.run(SKAction.animate(with: textureArray, timePerFrame: 0.05))
        FighterNode.run(SKAction.moveTo(x: to, duration: time))
        //FighterNode.
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
}
