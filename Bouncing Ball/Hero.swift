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
    //let energyDelta = Float(0.05)
    let dashCost = Float(0.1)
    let doubleJumpCost = Float(0.05)
    var speedMult = Float(1.0)
    let maxJumpsAllowed = 2
    var jumpsAllowed = 2
    var jumped = false
    let jumpSound = SKAudioNode(fileNamed: SOUND_EFFECT_JUMP)
    let enemyContactSound = SKAudioNode(fileNamed: SOUND_EFFECT_ENEMY_CONTACT)
    
    let maxLives = 3
    var lives = 3
    
    var powerUps = [PowerUpTypes: PowerUp]()
    
    let jumpPower = 80.0
    var defaults = UserDefaults.standard
    
    
    private let heroAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    var walkFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        for i in 1..<6 {
            walkFrames.append(SKTexture(imageNamed: "sprint" + String(i)))
        }
        
        //jumpSound! = SKAudioNode(fileNamed: SOUND_EFFECT_JUMP)
        jumpSound.autoplayLooped = false
        self.addChild(jumpSound)
        
        enemyContactSound.autoplayLooped = false
        self.addChild(enemyContactSound)
        
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
    
    func changeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    public func hitByEnemy() {
        if !defaults.bool(forKey: "muted") {
            enemyContactSound.run(SKAction.play())
        }
        lives -= 1
    }
    
    public func update() {
        for powerUp in powerUps.values {
            powerUp.update()
        }
    }
    
    func jump() {
        if jumpsAllowed > 0 {
            if !defaults.bool(forKey: "muted") {
                jumpSound.run(SKAction.play())
            }
            
            if jumpsAllowed == maxJumpsAllowed {
                self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpPower))
                
                onGround = false
                stopRunning()
                changeImage(image: "3_Jump")
                
                jumpsAllowed -= 1
            }
            else {
                if energy >= doubleJumpCost {
                    energy -= doubleJumpCost
                    self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
                    self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpPower))
                    
                    onGround = false
                    stopRunning()
                    changeImage(image: "3_Jump")
                    
                    jumpsAllowed -= 1
                }
            }
        }
    }
    
    func dash() {
        if (energy >= dashCost && speedMult == 1.0) {
            energy -= dashCost
            speedMult *= 4
        }
    }
    
    func land() {
        if !onGround {
            self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
            onGround = true
            changeImage(image: "2_Fall")
            run()
            jumpsAllowed = maxJumpsAllowed
            jumped = false
        }
    }
    
    func run() {
        self.run(SKAction.repeatForever(SKAction.animate(with: walkFrames,
                                                         timePerFrame: 0.1,
                                                         resize: false,
                                                         restore: true)), withKey: "run")
    }
    
    func stopRunning() {
        self.removeAction(forKey: "run")
    }
    
    func fall() {
        if !onGround && physicsBody!.velocity.dy < CGFloat(0) {
            changeImage(image: "1_Fall")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
