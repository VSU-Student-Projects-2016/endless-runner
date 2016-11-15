//
//  EnemyJumping.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class JumpingEnemy: Enemy{
    let jumpForce = 35.0
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
    }
    
    func Jump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: jumpForce))
        //ChangeImage(image: "hero_jump")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
