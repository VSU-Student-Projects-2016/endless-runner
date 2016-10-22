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
    var bonusPool = [Bonus]()
    var score = 0;
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var hero: Hero!
    
    
    var enemy: Enemy!
    
    let cameraNode = SKCameraNode()
    
    var garbageCollector : GarbageCollector!
     
    override func didMove(to view: SKView) {
        
        // don't hardcode "200" below
        hero = Hero(image: "hero", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY / 4), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
        
        enemy = Enemy(image: "block1", pos: position)
        
        garbageCollector = GarbageCollector(pos: CGPoint(x: frame.minX-100, y: frame.midY),
                                            size: CGSize(width: 50, height: frame.size.height*2))
        addChild(garbageCollector)
        
        
        for _ in (0..<10) {
            bonusPool.append(Bonus(image: "fish", pos: CGPoint(x: self.frame.maxX, y: self.frame.midY)))
        }
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.maxY - 40)
        self.addChild(scoreText)
        
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
    
    func addEnemy(position: CGPoint) {
        enemy.position = position
        addChild(enemy)
    }
    
    func addBonus(position: CGPoint) {
        if bonusPool.count >= 5 {
            for i in 0..<5 {
                let bonus = bonusPool[0]
                bonus.position = CGPoint(x: position.x + CGFloat(i*50), y: position.y)
                bonusPool.remove(at: 0)
                self.addChild(bonus)
            }
        
        }
        print("Bonus created")
    }

    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            hero.Land()
        }

        //died()
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Bonus){
            //bonus.removeFromParent()
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                bonusPool.append(contact.bodyA.node as! Bonus)
                contact.bodyA.node?.removeFromParent()
                //bonusPool.append(Bonus(image: "fish", pos: CGPoint(x: 0, y: 0)))
            } else {
                bonusPool.append(contact.bodyB.node as! Bonus)
                contact.bodyB.node?.removeFromParent()
                //bonusPool.append(Bonus(image: "fish", pos: CGPoint(x: 0, y: 0)))
            }
            score += 1
            scoreText.text = String(score)
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Enemy){
            print("Hit by enemy")
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Bonus | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                bonusPool.append(contact.bodyA.node as! Bonus)
                contact.bodyA.node?.removeFromParent()
                //bonusPool.append(Bonus(image: "fish", pos: CGPoint(x: 0, y: 0)))
            } else {
                bonusPool.append(contact.bodyB.node as! Bonus)
                contact.bodyB.node?.removeFromParent()
                //bonusPool.append(Bonus(image: "fish", pos: CGPoint(x: 0, y: 0)))
            }
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
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
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
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
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Create new ground block
        if self.hero.position.x > (self.currGroundBar.position.x) && (nextGroundBar == nil) {
            
            createNextGroundBlock(position: CGPoint(x: self.currGroundBar.position.x + self.currGroundBar.size.width,
                                                y: self.currGroundBar.position.y + currGroundBar.size.height / 2))
            
            let randNum = random(left: 0, right: 10)
            print(randNum)
            if (randNum % 2 == 0) {
                addBonus(position: CGPoint(x: nextGroundBar.position.x,
                                           y: nextGroundBar.position.y + 4*hero.size.height))
            }
            
            if (randNum % 3 == 0) {
                addEnemy(position: CGPoint(x: nextGroundBar.position.x,
                                           y: nextGroundBar.position.y + 4*hero.size.height))
            }
        }
        
        // Delete old ground and switch next and current blocks
        if self.currGroundBar.position.x + self.currGroundBar.size.width / 2 <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currGroundBar.removeFromParent()
            barsPool.append(currGroundBar)
            self.currGroundBar = self.nextGroundBar!
            self.nextGroundBar = nil
        }
        
        if hero.onGround {
            hero.physicsBody?.velocity = CGVector(dx: 300, dy: (hero.physicsBody?.velocity.dy)!)
        }
        hero.Fall()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        cameraNode.position = CGPoint(x: hero.position.x + self.frame.width / 4, y: cameraNode.position.y)
        self.scoreText.position = CGPoint(x: scene!.camera!.position.x - frame.size.width / 2.2,
                                          y: scene!.camera!.position.y + frame.size.height / 2.7)
        garbageCollector.position = CGPoint(x: scene!.camera!.position.x - frame.size.width / 2 - garbageCollector.size.width,
                                            y: garbageCollector.position.y)
    }
}
