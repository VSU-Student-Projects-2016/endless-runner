//
//  PlayScene.swift
//  Bouncing Ball
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var currentRunningBar = SKSpriteNode(imageNamed:"bar")
    var nextRunningBar: SKSpriteNode! = SKSpriteNode(imageNamed: "bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    
    let cameraNode = SKCameraNode()

    var onGround = true
    
    // Bit mask types
    enum ColliderType:UInt32 {
        case None = 0
        case Hero = 0b1
        case Ground = 0b10
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.blue
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        cameraNode.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.hero.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Create hero physics body
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width * 2, y: self.frame.midY / 4)
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.Hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.Ground.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.Ground.rawValue
        self.hero.physicsBody?.affectedByGravity = true
        self.hero.physicsBody?.restitution = 0.0
        self.hero.physicsBody?.velocity = CGVector(dx: 300.0, dy: 0.0)
        self.hero.physicsBody?.linearDamping = 0
        
        // Create current running bar
        self.currentRunningBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.currentRunningBar.position = CGPoint(
            x: self.frame.minX + self.currentRunningBar.size.width/4,
            y: self.frame.minY + (self.currentRunningBar.size.height / 2))
        self.currentRunningBar.physicsBody = SKPhysicsBody(rectangleOf: self.currentRunningBar.size)
        self.currentRunningBar.physicsBody?.isDynamic = false
        self.currentRunningBar.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        self.currentRunningBar.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.currentRunningBar.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        self.currentRunningBar.physicsBody?.restitution = 0.0
        
        // Create next running bar
        createGroundBlock(position: CGPoint(x: self.currentRunningBar.position.x + self.currentRunningBar.size.width,
                                            y: self.currentRunningBar.position.y + currentRunningBar.size.height/2))

        self.addChild(self.currentRunningBar)
        self.addChild(self.hero)
    }
    

    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero.rawValue | ColliderType.Ground.rawValue){
            onGround = true
        }

        //died()
    }
    
    func didEnd(_ contact:SKPhysicsContact) {
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero.rawValue | ColliderType.Ground.rawValue){
            onGround = false
        }
    }
    
    func died() {
//        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
//            let skView = self.view as SKView!
//            skView?.ignoresSiblingOrder = true
//            scene.size = (skView?.bounds.size)!
//            scene.scaleMode = .aspectFill
//            skView?.presentScene(scene)
//        }
        
    }
    
    func random() -> Int {
        let range = Int(-40)..<Int(40)
        return Int(arc4random_uniform(40))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.onGround {
            self.hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
        }
    }
    
    func createGroundBlock(position : CGPoint) {
        nextRunningBar = SKSpriteNode(imageNamed: "bar")
        self.nextRunningBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.nextRunningBar.physicsBody = SKPhysicsBody(rectangleOf: self.nextRunningBar.size)
        self.nextRunningBar.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        self.nextRunningBar.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.nextRunningBar.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        self.nextRunningBar.physicsBody?.restitution = 0.0
        self.nextRunningBar.physicsBody?.isDynamic = false
        self.nextRunningBar.position = position
        self.addChild(nextRunningBar)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position = CGPoint(x: hero.position.x + self.frame.width/4, y: cameraNode.position.y)
        
        // Create new ground block
        if self.hero.position.x > (self.currentRunningBar.position.x) && (nextRunningBar == nil) {
            createGroundBlock(position: CGPoint(x: self.currentRunningBar.position.x + self.currentRunningBar.size.width,
                                                y: self.currentRunningBar.position.y + currentRunningBar.size.height/2))
        }
        // Delete old ground and switch next and current blocks
        if self.currentRunningBar.position.x + self.currentRunningBar.size.width / 2 <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currentRunningBar.removeFromParent()
            self.currentRunningBar = self.nextRunningBar!
            self.nextRunningBar = nil
        }
    }
}
