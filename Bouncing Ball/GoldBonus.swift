//
//  GoldBonus.swift
//  EndlessRunner
//
//  Created by xcode on 26.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class GoldBonus: Bonus {
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Bonus, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.None, energyMod: 0.1, score: 5)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32, energyMod: Float, score: Int) {
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask, energyMod: energyMod, score: score)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
