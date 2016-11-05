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
    var energy = Float(1.0)
    let energyDelta = Float(0.05)
    let dashCost = Float(0.1)
    var speedMult = Float(1.0)
    let maxJumpsAllowed = 2
    var jumpsAllowed = 2
    var jumped = false
    
    private let heroAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    var walkFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        walkFrames.append(SKTexture(imageNamed: "hero"))
        walkFrames.append(SKTexture(imageNamed: "hero_move1"))
        
        jumpsAllowed = maxJumpsAllowed
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 2))
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        physicsBody?.affectedByGravity = true
        physicsBody?.restitution = 0.0
        physicsBody?.velocity = CGVector(dx: 300.0, dy: 0.0)
        physicsBody?.linearDamping = 0
        physicsBody?.friction = 0
    }
    
    func ChangeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    func Jump() {
        if jumpsAllowed > 0 {
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0)) // don't hardcode the force
            onGround = false
            StopRunning()
            ChangeImage(image: "hero_jump")
            jumpsAllowed -= 1
            jumped = true
        }
    }
    
    func Dash() {
        if (energy >= dashCost && speedMult == 1.0) {
            energy -= dashCost
            speedMult *= 4
        }
    }
    
    func Land() {
        self.physicsBody?.velocity.dy = CGFloat(0)
        onGround = true
        ChangeImage(image: "hero")
        Run()
        jumpsAllowed = maxJumpsAllowed
        jumped = false
    }
    
    func Run() {
        self.run(SKAction.repeatForever(SKAction.animate(with: walkFrames,
                                                         timePerFrame: 0.5,
                                                         resize: false,
                                                         restore: true)), withKey: "run")
    }
    
    func StopRunning() {
        self.removeAction(forKey: "run")
    }
    
    func Fall() {
        if !onGround && physicsBody!.velocity.dy < CGFloat(0) {
            ChangeImage(image: "hero_fall")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
