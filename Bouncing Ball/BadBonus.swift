//
//  BadBonus.swift
//  EndlessRunner
//
//  Created by xcode on 26.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class BadBonus: Bonus {
    
    convenience init(pos: CGPoint) {
        self.init(image: "bad_fish", pos: pos, categoryBitMask: ColliderType.Bonus, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.None, energyMod: -0.05, score: 0)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32, energyMod: Float, score: Int) {
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask, energyMod: energyMod, score: score)
        
        let particles = SKEmitterNode(fileNamed: "BadFishParticle")
        addChild(particles!)
        particles!.position = CGPoint(x: 0, y: self.size.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
