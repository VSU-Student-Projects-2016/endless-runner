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
    
    //var currentRunningBar = SKSpriteNode(imageNamed: "bar")
    //var nextRunningBar: SKSpriteNode! = SKSpriteNode(imageNamed: "bar")
    var currGroundBar: GroundBar!
    var nextGroundBar: GroundBar!
    
    var barsPool = [GroundBar]()
    
    
    var hero: Hero!
    
    let cameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        // don't hardcode "200" below
        hero = Hero(image: "hero", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY / 4), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
        
        // don't hardcode "200" below
        currGroundBar = GroundBar(image: "ice", pos: CGPoint(
                        x: self.frame.minX,
                        y: self.frame.minY))

        // Create next running bar
        barsPool.append(GroundBar(image: "desert", pos: CGPoint.zero))
        
        // World initialization
        self.backgroundColor = UIColor.blue
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Camera initialization
        cameraNode.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        

        self.addChild(self.currGroundBar)
        self.addChild(self.hero)
    }
    

    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            hero.Land()
        }

        //died()
    }
    
    func didEnd(_ contact:SKPhysicsContact) {
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            
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
        if hero.onGround {
            hero.Jump()
        }
    }
    
    func createNextGroundBlock(position : CGPoint) {
        if barsPool.count > 0 {
            nextGroundBar = barsPool[0]
            nextGroundBar.position = position
            barsPool.remove(at: 0)
        } else {
            nextGroundBar = GroundBar(image: "ice", pos: position)
        }
        self.addChild(nextGroundBar)
        print(barsPool.count)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Create new ground block
        if self.hero.position.x > (self.currGroundBar.position.x) && (nextGroundBar == nil) {
            
            createNextGroundBlock(position: CGPoint(x: self.currGroundBar.position.x + self.currGroundBar.size.width,
                                                y: self.currGroundBar.position.y + currGroundBar.size.height / 2))
        }
        
        // Delete old ground and switch next and current blocks
        if self.currGroundBar.position.x + self.currGroundBar.size.width / 2 <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currGroundBar.removeFromParent()
            barsPool.append(currGroundBar)
            self.currGroundBar = self.nextGroundBar!
            self.nextGroundBar = nil
        }
        
        hero.physicsBody?.velocity = CGVector(dx: 300, dy: (hero.physicsBody?.velocity.dy)!)
        hero.Fall()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        cameraNode.position = CGPoint(x: hero.position.x + self.frame.width / 4, y: cameraNode.position.y)
        
    }
}
