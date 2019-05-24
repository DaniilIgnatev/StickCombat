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
    
    private var textureAtlas = SKTextureAtlas()
    private var textureArray = [SKTexture]()
    
    init(id : FighterID, node : SKSpriteNode, direction : FighterDirection) {
        self.ID = id
        self.FighterNode = node
        self.Direction = direction
        
        self.textureAtlas = SKTextureAtlas(named: "walk")
        
        for i in 0...(textureAtlas.textureNames.count-1){
            let name = "\(i).png"
            self.textureArray.append(SKTexture(imageNamed: name))
        }
    }
    
    public func playStrikeAction(action : StrikeAction){
        //пробник
        
    }
    public func playMoveAction(moveAction : HorizontalAction){
        moveLeftFirst(to: moveAction.To)
    }
    
    private func moveLeftFirst(to: CGFloat){
        FighterNode.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.05)))
        //FighterNode.run(SKAction.repeatForever(SKAction.moveBy(x: 5, y: 0, duration: 0.05)))
        FighterNode.run(SKAction.repeatForever(SKAction.moveTo(x: to, duration: 0.05)))
    }
    
}
