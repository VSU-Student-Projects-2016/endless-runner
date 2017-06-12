//
//  ShieldPU.swift
//  Bouncing Ball
//
//  Created by xcode on 19.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

public class ShieldPU: SKSpriteNode, PowerUp {
    let maxTimeLimit = 500
    var currentTime = 500
    var hero: Hero?
    var shieldTextureOnHero: SKSpriteNode?
    
    public init(image: String) {
        //let texture = SKTexture(imageNamed: image)
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        shieldTextureOnHero = SKSpriteNode(texture: texture)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.categoryBitMask = ColliderType.PowerUp
        physicsBody!.contactTestBitMask = ColliderType.Hero
        physicsBody!.isDynamic = false
        physicsBody!.affectedByGravity = false
    }
 
    public func onAdd(to hero: Hero) {
        self.hero = hero
        shieldTextureOnHero?.zPosition = 99
        hero.addChild(shieldTextureOnHero!)
        if hero.powerUps[PowerUpTypes.Shield] != nil {
            hero.powerUps[PowerUpTypes.Shield]!.removeFromHero()
        }
        hero.powerUps[PowerUpTypes.Shield] = self
    }
    
    public func update() {
        if currentTime > 0 {
            currentTime -= 1
        } else {
            removeFromHero()
        }
    }
    
    public func onContact(with enemy: Enemy) {
        removeFromHero()
        enemy.die()
    }
    
    public func removeFromHero() {
        shieldTextureOnHero!.removeFromParent()
        hero!.powerUps[PowerUpTypes.Shield] = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
