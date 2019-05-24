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
    //Атласы
    private var leftPunchAtlas = SKTextureAtlas()
    private var rightKickAtlas = SKTextureAtlas()
    private var rightPunchAtlas = SKTextureAtlas()
    private var moveAtlas = SKTextureAtlas()
    private var leftKickAtlas = SKTextureAtlas()
    //Массивы текстур
    private var leftKickArray = [SKTexture]()
    private var moveArray = [SKTexture]()
    private var leftPunchArray = [SKTexture]()
    private var rightKickArray = [SKTexture]()
    private var rightPunchArray = [SKTexture]()
    
    
    init(id : FighterID, node : SKSpriteNode, direction : FighterDirection) {
        self.ID = id
        self.FighterNode = node
        self.Direction = direction
        
        self.moveArray = initTextureArray(nameAtlas: "move")
        self.leftKickArray = initTextureArray(nameAtlas: "leftKick")
        self.leftPunchArray = initTextureArray(nameAtlas: "leftPunch")
        self.rightKickArray = initTextureArray(nameAtlas: "rightKick")
        self.rightPunchArray = initTextureArray(nameAtlas: "rightPunch")
    }

    
    public func playStrikeAction(action : StrikeAction){
        //пробник
        
    }
    public func playMoveAction(moveAction : HorizontalAction){
        self.moveAction(to: moveAction.To)
    }
    
    private func moveAction(to: CGFloat){
        FighterNode.run(SKAction.repeatForever(SKAction.animate(with: moveArray, timePerFrame: 0.05)))
        FighterNode.run(SKAction.repeatForever(SKAction.moveTo(x: to, duration: 0.05)))
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
    
}
