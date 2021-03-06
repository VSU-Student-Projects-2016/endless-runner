//
//  PlatformBar.swift
//  Bouncing Ball
//
//  Created by Admin on 13.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformBar: SKSpriteNode {
    
    var sensor: SKSpriteNode?
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Ground, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.Hero)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
        
//        sensor = SKSpriteNode(color: UIColor.clear, size: texture.size())
//        //sensor!.position = CGPoint(x: pos.x, y: pos.y + texture.size().height * 2)
//        sensor!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width, height: 3.0))
//        sensor!.physicsBody!.isDynamic = false
//        sensor!.physicsBody!.categoryBitMask = ColliderType.PlatformSensor
//        sensor!.physicsBody!.contactTestBitMask = ColliderType.Hero  // enemy might be included too
//        sensor!.physicsBody!.collisionBitMask = ColliderType.None
//        self.addChild(sensor!)
//        sensor!.position = CGPoint(x: 0.0, y: texture.size().height * 2)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height * 2))
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = ColliderType.PlatformSensor
        self.physicsBody!.contactTestBitMask = ColliderType.Hero
        self.physicsBody!.collisionBitMask = ColliderType.Hero
        //        self.physicsBody!.categoryBitMask = categoryBitMask
        //        self.physicsBody!.contactTestBitMask = contactTestBitMask
        //        self.physicsBody!.collisionBitMask = collisionBitMask
        self.physicsBody!.restitution = 0.0
        self.physicsBody!.friction = 0
        
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = pos
        
        var textures = [SKSpriteNode]()
        let texturesCount = 5
        let texturesPerPlatform = 4
        let textureWidth = CGFloat(71)
        for i in 0..<texturesPerPlatform {
            let texture = SKTexture(imageNamed: "grass_" + String(random(left: 1, right: texturesCount)))
            let platform = SKSpriteNode(texture: texture)
            platform.zPosition = 100
            platform.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            textures.append(platform)
            self.addChild(textures[i])
            textures[i].position.x = CGFloat(i) * textureWidth - self.size.width / 2
        }
    }
    
    public func MakeSolid() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody!.categoryBitMask = ColliderType.Ground
        self.physicsBody!.isDynamic = false
        self.physicsBody!.contactTestBitMask = ColliderType.Hero
        self.physicsBody!.collisionBitMask = ColliderType.Hero
        self.physicsBody!.restitution = 0.0
        self.physicsBody!.friction = 0
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
