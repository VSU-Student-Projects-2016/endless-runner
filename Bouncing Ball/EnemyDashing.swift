//
//  EnemyDashing.swift
//  Bouncing Ball
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class DashingEnemy: Enemy {
    let velocity = CGVector(dx: -250, dy: 0)
    
    let enemySound = SKAudioNode(fileNamed: SOUND_EFFECT_DASHING_ENEMY)
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        super.init(image: image, pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
        //physicsBody!.velocity = velocity
        
        playerSensor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: 1000.0))
        playerSensor.physicsBody!.affectedByGravity = false
        playerSensor.physicsBody!.categoryBitMask = ColliderType.EnemySensor
        playerSensor.physicsBody!.contactTestBitMask = ColliderType.Hero
        playerSensor.physicsBody!.isDynamic = false
        self.addChild(playerSensor)
        playerSensor.position = CGPoint(x: sensorPos, y: 150)
        
        enemySound.autoplayLooped = false
        self.addChild(enemySound)
    }
    
    override func act() {
        //physicsBody!.applyImpulse(dashForce)
        physicsBody!.velocity = velocity
        if !defaults.bool(forKey: "muted") {
            enemySound.run(SKAction.play())
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
