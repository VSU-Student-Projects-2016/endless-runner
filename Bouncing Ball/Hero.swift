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
    let doubleJumpCost = Float(0.05)
    var speedMult = Float(1.0)
    let maxJumpsAllowed = 2
    var jumpsAllowed = 2
    var jumped = false
    
    let jumpPower = 80.0
    
    private let heroAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    var walkFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
//        walkFrames.append(SKTexture(imageNamed: "hero"))
//        walkFrames.append(SKTexture(imageNamed: "hero_move1"))
        
        for i in 1..<9 {
            walkFrames.append(SKTexture(imageNamed: String(i) + "Cat"))
        }
        
        jumpsAllowed = maxJumpsAllowed
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        //physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 2))
        physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.mass = (physicsBody?.mass)! * 1.7
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
//        if jumpsAllowed > 0 && energy >= doubleJumpCost || jumpsAllowed == maxJumpsAllowed {
//            if jumpsAllowed < maxJumpsAllowed {
//                energy -= doubleJumpCost
//            }
//            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0)) // don't hardcode the force
        
//        if jumpsAllowed > 0 {
//            self.physicsBody?.velocity = CGVector(dx: (self.physicsBody?.velocity.dx)!, dy: 0)
//            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: jumpPower)) // don't hardcode the force
//            
//            onGround = false
//            StopRunning()
//            ChangeImage(image: "hero_jump")
//            
//            jumpsAllowed -= 1
//            jumped = true
//        }
        
        if onGround {
            onGround = false
            self.physicsBody?.velocity = CGVector(dx: (self.physicsBody?.velocity.dx)!, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: jumpPower)) // don't hardcode the force
            StopRunning()
            ChangeImage(image: "3_Jump")
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
        ChangeImage(image: "2_Fall")
        Run()
        jumpsAllowed = maxJumpsAllowed
        jumped = false
    }
    
    func Run() {
        self.run(SKAction.repeatForever(SKAction.animate(with: walkFrames,
                                                         timePerFrame: 0.1,
                                                         resize: false,
                                                         restore: true)), withKey: "run")
    }
    
    func StopRunning() {
        self.removeAction(forKey: "run")
    }
    
    func Fall() {
        if !onGround && physicsBody!.velocity.dy < CGFloat(0) {
            ChangeImage(image: "1_Fall")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
