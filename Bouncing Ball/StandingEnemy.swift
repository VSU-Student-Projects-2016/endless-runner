//
//  Enemy.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

public class StandingEnemy: Enemy {
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground | ColliderType.PlatformSensor)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        super.init(image: "Jason1", pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
        for i in 1..<9 {
            standingFrames.append(SKTexture(imageNamed: "Jason" + String(i)))
        }
        self.run(SKAction.repeatForever(SKAction.animate(with: standingFrames,
                                                         timePerFrame: 0.1,
                                                         resize: false,
                                                         restore: true)), withKey: "wait")
    }
    
    override func act() { }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
