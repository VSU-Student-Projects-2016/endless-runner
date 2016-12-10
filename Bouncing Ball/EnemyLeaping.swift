//
//  LeapingEnemy.swift
//  Bouncing Ball
//
//  Created by Admin on 20.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class LeapingEnemy: Enemy{
    let horizontalForce = -75.0
    let verticalForce = 65.0
    
    let enemySound = SKAudioNode(fileNamed: SOUND_EFFECT_LEAPING_ENEMY)
    
    var actFrames = [SKTexture]()
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: "Freddy1", pos: pos, categoryBitMask: ColliderType.Enemy, contactTestBitMask: ColliderType.Hero | ColliderType.Ground, collisionBitMask: ColliderType.Ground)
    }
    
    override init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32){
        super.init(image: "Freddy1", pos: pos, categoryBitMask: categoryBitMask, contactTestBitMask: contactTestBitMask, collisionBitMask: collisionBitMask)
        
        for i in 1..<5 {
            actFrames.append(SKTexture(imageNamed: "Freddy" + String(i)))
        }
        
        standingFrames.append(SKTexture(imageNamed: "Freddy1"))
        standingFrames.append(SKTexture(imageNamed: "Freddy2"))
        standingFrames.append(SKTexture(imageNamed: "Freddy1"))
        standingFrames.append(SKTexture(imageNamed: "Freddy4"))
        
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //position = pos
        playerSensor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: 400.0))
        playerSensor.physicsBody!.affectedByGravity = false
        playerSensor.physicsBody!.categoryBitMask = ColliderType.EnemySensor
        playerSensor.physicsBody!.contactTestBitMask = ColliderType.Hero
        playerSensor.physicsBody!.isDynamic = false
        self.addChild(playerSensor)
        playerSensor.position = CGPoint(x: sensorPos, y: -150)
        
        self.run(SKAction.repeatForever(SKAction.animate(with: standingFrames,
                                                         timePerFrame: 0.1,
                                                         resize: false,
                                                         restore: true)), withKey: "wait")
        
        enemySound.autoplayLooped = false
        self.addChild(enemySound)
    }
    
    override func act() {
        self.removeAction(forKey: "wait")
        self.physicsBody!.applyImpulse(CGVector(dx: horizontalForce, dy: verticalForce))
        //self.run(SKAction.animate(with: actFrames, timePerFrame: 0.1, resize: false, restore: true))
        playerSensor.removeFromParent()
        enemySound.run(SKAction.play())
        texture = SKTexture(imageNamed: "Freddy3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
