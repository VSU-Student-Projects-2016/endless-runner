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
    var energyParticlesOnHero: SKEmitterNode?
    let energyIncrease = Float(0.001)
    
    public init(image: String) {
        let texture = SKTexture(imageNamed: "PowerUp")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.size = CGSize(width: self.size.width * 0.5, height: self.size.height * 0.5)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.categoryBitMask = ColliderType.PowerUp
        physicsBody!.contactTestBitMask = ColliderType.Hero
        physicsBody!.isDynamic = false
        physicsBody!.affectedByGravity = false
        let particles = SKEmitterNode(fileNamed: "EnergyPowerupParticle")
        addChild(particles!)
        particles!.position = CGPoint(x: 0, y: 0)
    }
    
    public func onAdd(to hero: Hero) {
        self.hero = hero
        if hero.powerUps[PowerUpTypes.Energy] != nil {
            hero.powerUps[PowerUpTypes.Energy]!.removeFromHero()
        }
        hero.powerUps[PowerUpTypes.Energy] = self
        energyParticlesOnHero = SKEmitterNode(fileNamed: "EnergyPlayerParticle")
        hero.addChild(energyParticlesOnHero!)
        energyParticlesOnHero!.position = CGPoint(x: 0, y: 0)
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
        energyParticlesOnHero!.removeFromParent()
        hero!.powerUps[PowerUpTypes.Energy] = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
