//
//  Enemy.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

public class Enemy: SKSpriteNode {
    
    //private(set) public var onGround = true
    
    private let enemyAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    var standingFrames = [SKTexture]()
    var isDead = false
    let playerSensor = SKNode()
    var sensorPos = -300
    var defaults = UserDefaults.standard
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground | ColliderType.PlatformSensor)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        //self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 2))
        physicsBody!.categoryBitMask = categoryBitMask
        physicsBody!.contactTestBitMask = contactTestBitMask
        physicsBody!.collisionBitMask = collisionBitMask
        physicsBody!.affectedByGravity = true
        physicsBody!.isDynamic = true
        physicsBody!.restitution = 0.0
        physicsBody!.linearDamping = 0
        physicsBody!.friction = 0
    }
    
    func changeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    func die() {
        isDead = true
        self.removeFromParent()
    }
    
    func act() { }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
