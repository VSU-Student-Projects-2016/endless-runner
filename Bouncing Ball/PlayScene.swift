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
    var platformGenerator = PlatformGenerator()
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
        hero = Hero(image: "hero", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
        
        
        garbageCollector = GarbageCollector(pos: CGPoint(x: frame.minX-100, y: frame.midY),
                                            size: CGSize(width: 50, height: frame.size.height*2))
        addChild(garbageCollector)
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.maxY - 40)
        self.addChild(scoreText)
        
        // don't hardcode "200" below
        currGroundBar = GroundBar(image: "ice", pos: CGPoint(
                        x: self.frame.minX,
                        y: self.frame.midY * 0.35)) // put multiplier in variable
        
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
    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            hero.Land()
        }

        //died()
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Bonus){
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                platformGenerator.addBonusToPool(bonus: contact.bodyA.node as! Bonus)
                contact.bodyA.node!.removeFromParent()
            } else {
                platformGenerator.addBonusToPool(bonus: contact.bodyB.node as! Bonus)
                contact.bodyB.node!.removeFromParent()
            }
            score += 1
            scoreText.text = String(score)
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Enemy){
            print("Hit by enemy")
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Bonus | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {                platformGenerator.addBonusToPool(bonus: contact.bodyA.node as! Bonus)
                contact.bodyA.node!.removeFromParent()
            } else {
                platformGenerator.addBonusToPool(bonus: contact.bodyB.node as! Bonus)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                platformGenerator.addEnemyToPool(enemy: contact.bodyA.node as! Enemy)
                contact.bodyA.node!.removeFromParent()
            } else {
                platformGenerator.addEnemyToPool(enemy: contact.bodyB.node as! Enemy)
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
    
    override func update(_ currentTime: TimeInterval) {
        
        // Create new ground block
        if self.hero.position.x > (self.currGroundBar.position.x) && (nextGroundBar == nil) {
            nextGroundBar = platformGenerator.getPlatform(scene: self, pos: CGPoint(x: self.currGroundBar.position.x + self.currGroundBar.size.width,
                                                           y: self.currGroundBar.position.y))
        }
        
        // Delete old ground and switch next and current blocks
        if self.currGroundBar.position.x + self.currGroundBar.size.width / 2 <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currGroundBar.removeFromParent()
            platformGenerator.addPlatformToPool(platform: currGroundBar)
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
