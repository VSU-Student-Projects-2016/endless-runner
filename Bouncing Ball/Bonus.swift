//
//  Bonus.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class Bonus: SKSpriteNode {
    
    //private let bonusAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    //var walkFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Bonus, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.None)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        //walkFrames.append(SKTexture(imageNamed: "fish"))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 1.5)) // find the best size
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        //physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
    }
    
    func ChangeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
