//
//  GarbageCollector.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class GarbageCollector: SKSpriteNode {
    
    convenience init(pos: CGPoint, size: CGSize) {
        self.init(pos: pos, size: size, categoryBitMask: ColliderType.GarbageCollector, contactTestBitMask: ColliderType.Bonus | ColliderType.Enemy, collisionBitMask: ColliderType.None)
    }
    
    init(pos: CGPoint, size: CGSize, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        let texture = SKTexture()
        super.init(texture: texture, color: .red, size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
