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
    
    //private let bonusAnimatedAtlas = SKTextureAtlas(named: "Hero Images")
    //var walkFrames = [SKTexture]()
    
    var energyMod: Float?
    var score: Int?
    let bonusSound = SKAudioNode(fileNamed: SOUND_EFFECT_BONUS)
    
    convenience init(pos: CGPoint) {
        self.init(image: "fish", pos: pos, categoryBitMask: ColliderType.Bonus, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.None, energyMod: 0.03, score: 1)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32, energyMod: Float, score: Int) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.energyMod = energyMod
        self.score = score
        
        bonusSound.autoplayLooped = false
        self.addChild(bonusSound)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        position = pos
        physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.size.width / 1.5)) // find the best size
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = categoryBitMask
        physicsBody!.contactTestBitMask = contactTestBitMask
        physicsBody!.collisionBitMask = collisionBitMask
        physicsBody!.isDynamic = false
    }
    
    func ChangeImage(image: String) {
        self.texture = SKTexture(imageNamed: image)
    }
    
    func playSound() {
        //let bonusSound = SKAudioNode(fileNamed: SOUND_EFFECT_BONUS)
        //bonusSound.autoplayLooped = false
        //self.addChild(bonusSound)
        bonusSound.run(SKAction.play())
        print("Sound played")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
