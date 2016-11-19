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
    let maxTimeLimit = 300
    var currentTime = 300
    var hero: Hero?
    var shieldTextureOnHero: SKSpriteNode?
    
    public init(image: String) {
        let texture = SKTexture(imageNamed: image)
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
        hero.addChild(shieldTextureOnHero!)
        for i in 0..<hero.powerUps.count {
            if (hero.powerUps[i] is ShieldPU) {
                hero.powerUps[i].removeFromHero()
                //hero.powerUps.remove(at: i)
            }
        }
        hero.powerUps.append(self)
    }
    
    public func update() {
        if currentTime > 0 {
            currentTime -= 1
        } else {
            removeFromHero()
        }
    }
    
    public func onEnemyContact(enemy: Enemy) {
        removeFromHero()
        enemy.die()
    }
    
    public func removeFromHero() {
        for i in 0..<Int(hero!.powerUps.count) {
            if hero!.powerUps[i] is ShieldPU {
                print("Power up was removed")
                //hero!.powerUps[i].removeFromParent()
                shieldTextureOnHero?.removeFromParent()
                hero!.powerUps.remove(at: i)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
