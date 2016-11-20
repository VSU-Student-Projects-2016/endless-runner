//
//  ShieldPU.swift
//  Bouncing Ball
//
//  Created by xcode on 19.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

public class EnergyPU: SKSpriteNode, PowerUp {
    let maxTimeLimit = 300
    var currentTime = 300
    var hero: Hero?
    var energyTextureOnHero: SKSpriteNode?
    let energyIncrease = Float(0.001)
    
    public init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        energyTextureOnHero = SKSpriteNode(texture: texture)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.categoryBitMask = ColliderType.PowerUp
        physicsBody!.contactTestBitMask = ColliderType.Hero
        physicsBody!.isDynamic = false
        physicsBody!.affectedByGravity = false
    }
    
    public func onAdd(to hero: Hero) {
        self.hero = hero
        energyTextureOnHero?.zPosition = 99
        hero.addChild(energyTextureOnHero!)
        if hero.powerUps[PowerUpTypes.Energy] != nil {
            hero.powerUps[PowerUpTypes.Energy]!.removeFromHero()
        }
        hero.powerUps[PowerUpTypes.Energy] = self
    }
    
    public func update() {
        if currentTime > 0 {
            currentTime -= 1
            if hero!.energy < 1.0 {
                hero!.energy += energyIncrease
            }
        } else {
            removeFromHero()
        }
    }
    
    public func onContact(with enemy: Enemy) {
        removeFromHero()
        enemy.die()
    }
    
    public func removeFromHero() {
        energyTextureOnHero!.removeFromParent()
        hero!.powerUps[PowerUpTypes.Energy] = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
