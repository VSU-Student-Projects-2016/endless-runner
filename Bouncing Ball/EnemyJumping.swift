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
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
        playerSensor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: 400.0))
        playerSensor.physicsBody!.affectedByGravity = false
        playerSensor.physicsBody!.categoryBitMask = ColliderType.EnemySensor
        playerSensor.physicsBody!.contactTestBitMask = ColliderType.Hero
        playerSensor.physicsBody!.isDynamic = false
        self.addChild(playerSensor)
        playerSensor.position = CGPoint(x: sensorPos, y: -150)
        enemySound.autoplayLooped = false
        self.addChild(enemySound)
    }
    
    func jump() {
        if self.physicsBody!.velocity.dy <= 10 && active {
            self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: jumpForce))
            //ChangeImage(image: "hero_jump")
            enemySound.run(SKAction.play())
        }
    }
    
    override func act() {
        active = true
        jump()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
