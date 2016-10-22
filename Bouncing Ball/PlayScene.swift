//
//  PlayScene.swift
//  Bouncing Ball
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var currGroundBar: GroundBar!
    var nextGroundBar: GroundBar!
    
    var barsPool = [GroundBar]()
    var bonusPool = [Bonus]()
    var enemyPool = [Enemy]()
    var score = 0;
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var hero: Hero!
    
    let cameraNode = SKCameraNode()
    
    var garbageCollector : GarbageCollector!
    
    var pauseButton : UIButton!
    var exitButton : UIButton!
     
    override func didMove(to view: SKView) {
        
        pauseButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.minY, width: 100.0, height: 100.0))
        pauseButton.setTitle("Pause Menu", for: .normal)
        pauseButton.setTitleColor(.red, for: .normal)
        pauseButton.addTarget(self, action: #selector(self.pauseButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(pauseButton)
        
        exitButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100.0, height: 100.0))
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(self.exitButtonPressed(_:)), for: .touchUpInside)
        
        // don't hardcode "200" below
        hero = Hero(image: "hero", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY / 4), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
        
        
        garbageCollector = GarbageCollector(pos: CGPoint(x: frame.minX-100, y: frame.midY),
                                            size: CGSize(width: 50, height: frame.size.height*2))
        addChild(garbageCollector)
        
        enemyPool.append(DashingEnemy(image: "block1", pos: CGPoint(x: 0, y : 0)))
        enemyPool.append(JumpingEnemy(image: "block1", pos: CGPoint(x: 0, y : 0)))
        enemyPool.append(Enemy(image: "block1", pos: CGPoint(x: 0, y : 0)))
        
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
    
    func pauseButtonPressed(_ sender: UIButton!){
        self.isPaused = !self.isPaused
        if self.isPaused{
            self.view?.addSubview(exitButton)
        }
        else {
            exitButton.removeFromSuperview()
        }
    }
    
    func exitButtonPressed(_ sender: UIButton!) {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {

            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
            pauseButton.removeFromSuperview()
            exitButton.removeFromSuperview()
        }
        
    }
    
    func addEnemy(position: CGPoint) {
        if (enemyPool.count != 0) {
            let enemy = enemyPool[0]
            enemy.position = position
            enemyPool.remove(at: 0)
            addChild(enemy)
        }
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
    }

    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            hero.Land()
        }

        //died()
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Bonus){
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                bonusPool.append(contact.bodyA.node as! Bonus)
                contact.bodyA.node!.removeFromParent()
            } else {
                bonusPool.append(contact.bodyB.node as! Bonus)
                contact.bodyB.node!.removeFromParent()
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
                contact.bodyA.node!.removeFromParent()
            } else {
                bonusPool.append(contact.bodyB.node as! Bonus)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                enemyPool.append(contact.bodyA.node as! Enemy)
                contact.bodyA.node!.removeFromParent()
            } else {
                enemyPool.append(contact.bodyB.node as! Enemy)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.Ground){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                if contact.bodyA.node is JumpingEnemy {
                    (contact.bodyA.node as! JumpingEnemy).Jump()
                }
            } else {
                if contact.bodyB.node is JumpingEnemy {
                    (contact.bodyB.node as! JumpingEnemy).Jump()
                }
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
            
            if (randNum % 2 == 0) {
                addBonus(position: CGPoint(x: nextGroundBar.position.x,
                                           y: nextGroundBar.position.y + 4*hero.size.height))
            }
            
            if (randNum % 3 == 0) {
                addEnemy(position: CGPoint(x: nextGroundBar.position.x,
                                           y: nextGroundBar.position.y + hero.size.height))
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
