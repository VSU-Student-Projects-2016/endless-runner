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
    
    var energyMod: Float?
    var score: Int?
    
    convenience init(pos: CGPoint) {
        self.init(image: "fish", pos: pos, categoryBitMask: ColliderType.Bonus, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.None, energyMod: 0.03, score: 1)
        let particles = SKEmitterNode(fileNamed: "BonusParticle")
        addChild(particles!)
        particles!.position = CGPoint(x: 0, y: 0)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32, energyMod: Float, score: Int) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.energyMod = energyMod
        self.score = score
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 1.5)) // find the best size
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = categoryBitMask
        physicsBody!.contactTestBitMask = contactTestBitMask
        physicsBody!.collisionBitMask = collisionBitMask
        physicsBody!.isDynamic = false
        
//        let particles = SKEmitterNode()
//        particles.particleColor = UIColor.yellow
//        particles.advanceSimulationTime(1)
//        particles.numParticlesToEmit = 500
//        particles.particleSpeed = 10
//        self.addChild(particles)
    }
    
    func ChangeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
