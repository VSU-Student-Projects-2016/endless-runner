//
//  swift
//  Bouncing Ball
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class Hero: SKSpriteNode {
    
    private(set) public var onGround = true
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 2))
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        physicsBody?.affectedByGravity = true
        physicsBody?.restitution = 0.0
        physicsBody?.velocity = CGVector(dx: 300.0, dy: 0.0)
        physicsBody?.linearDamping = 0
        physicsBody?.friction = 0
    }
    
    func Jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0)) // don't hardcode the force
        onGround = false
    }
    
    func Land() {
        onGround = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
