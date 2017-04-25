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
    let jumpForce = 75.0
    var active = false
    
    let enemySound = SKAudioNode(fileNamed: SOUND_EFFECT_JUMPING_ENEMY)
    
    var actFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: "Jumper1", pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
        //self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 16.0, height: 16.0))
        //self.physicsBody!.mass *= 2
        self.physicsBody!.mass *= 3
        playerSensor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: 1000.0))
        playerSensor.physicsBody!.affectedByGravity = false
        playerSensor.physicsBody!.categoryBitMask = ColliderType.EnemySensor
        playerSensor.physicsBody!.contactTestBitMask = ColliderType.Hero
        playerSensor.physicsBody!.isDynamic = false
        self.addChild(playerSensor)
        playerSensor.position = CGPoint(x: sensorPos, y: 150)
        enemySound.autoplayLooped = false
        self.addChild(enemySound)
        
        for i in 2..<4 {
            actFrames.append(SKTexture(imageNamed: "Jumper" + String(i)))
        }
        
    }
    
    func jump() {
        if self.physicsBody!.velocity.dy <= 10 && active {
            self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpForce))
            
            if !defaults.bool(forKey: "muted") {
                enemySound.run(SKAction.play())
            }
        }
    }
    
    override func act() {
        self.run(SKAction.animate(with: actFrames, timePerFrame: 0.1, resize: false, restore: true))
        active = true
        jump()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
