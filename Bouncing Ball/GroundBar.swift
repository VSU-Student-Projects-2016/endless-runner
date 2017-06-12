//
//  GroundBar.swift
//  Bouncing Ball
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class GroundBar: SKSpriteNode {
    
    convenience init(image: String, pos: CGPoint) {
        self.init(image: image, pos: pos, categoryBitMask: ColliderType.Ground, contactTestBitMask: ColliderType.Hero, collisionBitMask: ColliderType.Hero)
    }
    
    init(image: String, pos: CGPoint, categoryBitMask: UInt32, contactTestBitMask: UInt32, collisionBitMask: UInt32) {
        
        //let texture = SKTexture(imageNamed: image)
        let texture = SKTexture(imageNamed: "desert_rnd")
        super.init(texture: texture, color: .clear, size: CGSize(width: round(texture.size().width), height: round(texture.size().height)))
        
        //print("Ground width: " + String(describing: texture.size().width))
        //print("Ground height: " + String(describing: texture.size().height))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = pos
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.0, size: texture.size())
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.contactTestBitMask = contactTestBitMask
        self.physicsBody!.collisionBitMask = collisionBitMask
        self.physicsBody!.restitution = 0.0
        self.physicsBody!.friction = 0
        
        var textures = [SKSpriteNode]()
        let texturesCount = 5
        let texturesPerPlatform = 16
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
        
        var backGrounds = [SKSpriteNode]()
        let backGroundsCount = 5
        let backGroundsPerPlatform = 16
        let backGroundWidth = CGFloat(71)
        for i in 0..<backGroundsPerPlatform {
            let backGroundImg = SKTexture(imageNamed: "ground_" + String(random(left: 1, right: backGroundsCount)))
            let backGround = SKSpriteNode(texture: backGroundImg)
            backGround.zPosition = 80
            backGround.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            backGrounds.append(backGround)
            self.addChild(backGrounds[i])
            backGrounds[i].position.x = CGFloat(i) * backGroundWidth - self.size.width / 2
            backGrounds[i].position.y -= backGrounds[i].size.height / 2 - 8
        }
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
