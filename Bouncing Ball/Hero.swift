//
//  swift
//  Bouncing Ball
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

public class Hero: SKSpriteNode {
    
    private(set) public var onGround = false
    var energy = Float(1.0)
    let energyDelta = Float(0.05)
    let dashCost = Float(0.1)
    let doubleJumpCost = Float(0.05)
    var speedMult = Float(1.0)
    let maxJumpsAllowed = 2
    var jumpsAllowed = 2
    var jumped = false
    var powerUps = [PowerUp]()
    
    let jumpPower = 80.0
    
    private let heroAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    var walkFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        for i in 1..<9 {
            walkFrames.append(SKTexture(imageNamed: String(i) + "Cat"))
        }
        
        jumpsAllowed = maxJumpsAllowed
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        
        //physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().height/2)
        physicsBody!.allowsRotation = false
        physicsBody!.categoryBitMask = categoryBitMask
        physicsBody!.mass = (physicsBody?.mass)! * 3.5 //* 1.3 
        physicsBody!.contactTestBitMask = contactTestBitMask
        physicsBody!.collisionBitMask = collisionBitMask
        physicsBody!.affectedByGravity = true
        physicsBody!.restitution = 0.0
        //physicsBody!.velocity = CGVector(dx: 300.0, dy: 0.0)
        physicsBody!.linearDamping = 0
        physicsBody!.friction = 0
    }
    
    func ChangeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    public func update() {
        for powerUp in powerUps {
            powerUp.update()
        }
    }
    
    public func getShield() -> Int {
        for i in 0..<powerUps.count {
            if powerUps[i] is ShieldPU {
                return i
            }
        }
        return -1
    }
    
    func Jump() {
        if jumpsAllowed > 0 {
            if jumpsAllowed == maxJumpsAllowed {
                self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpPower))
                
                onGround = false
                StopRunning()
                ChangeImage(image: "3_Jump")
                
                jumpsAllowed -= 1
            }
            else {
                if energy >= doubleJumpCost {
                    energy -= doubleJumpCost
                    self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
                    self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpPower))
                    
                    onGround = false
                    StopRunning()
                    ChangeImage(image: "3_Jump")
                    
                    jumpsAllowed -= 1
                }
            }
        }
    }
    
    func Dash() {
        if (energy >= dashCost && speedMult == 1.0) {
            energy -= dashCost
            speedMult *= 4
        }
    }
    
    func Land() {
        if !onGround {
            self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
            onGround = true
            ChangeImage(image: "2_Fall")
            Run()
            jumpsAllowed = maxJumpsAllowed
            jumped = false
        }
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
