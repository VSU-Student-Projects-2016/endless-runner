//
//  GroundBar.swift
//  Bouncing Ball
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class GroundBar: SKSpriteNode {
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Ground, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.Hero)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = pos
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.contactTestBitMask = contactTestBitMask
        self.physicsBody!.collisionBitMask = collisionBitMask
        self.physicsBody!.restitution = 0.0
        self.physicsBody!.friction = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
