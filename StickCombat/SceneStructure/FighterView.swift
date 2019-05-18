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

    public let FighterNode : SKSpriteNode
    
    init(id : FighterID,node : SKSpriteNode) {
        self.ID = id
        self.FighterNode = node
    }
    
    public func PlayAction(action : GameAction){
        //пробник
        
    }
    
    
    
}
