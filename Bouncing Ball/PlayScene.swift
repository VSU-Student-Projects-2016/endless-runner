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
    
//    var currGroundBar: GroundBar!
//    var nextGroundBar: GroundBar!
    var currPlatform: PlatformTemplate!
    var nextPlatform: PlatformTemplate!
    
    var platformGenerator = PlatformGenerator()
    var score = 0;
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var hero: Hero!
    
    
    let cameraNode = SKCameraNode()
    
    var garbageCollector : GarbageCollector!
    var fallDetector : GarbageCollector!
    
    var pauseButton : UIButton!
    var exitButton : UIButton!
    
    var DashButton : UIButton!
    
    var progressView : UIProgressView!
     
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        pauseButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.minY, width: 100.0, height: 100.0))
        pauseButton.setTitle("Pause Menu", for: .normal)
        pauseButton.setTitleColor(.red, for: .normal)
        pauseButton.addTarget(self, action: #selector(self.pauseButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(pauseButton)
        
        DashButton = UIButton(frame: CGRect(x: self.frame.minX, y: self.frame.maxY - 100, width: 100.0, height: 100.0))
        DashButton.setTitle("Dash", for: .normal)
        DashButton.setTitleColor(.red, for: .normal)
        DashButton.addTarget(self, action: #selector(self.dashButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(DashButton)
        
        exitButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100.0, height: 100.0))
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(self.exitButtonPressed(_:)), for: .touchUpInside)
        
        // don't hardcode "200" below
        hero = Hero(image: "hero", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground, collisionBitMask: ColliderType.Ground)
        
        
        garbageCollector = GarbageCollector(pos: CGPoint(x: frame.minX-200, y: frame.midY),
                                            size: CGSize(width: 50, height: frame.size.height*2))
        addChild(garbageCollector)
        
        fallDetector = GarbageCollector(pos: CGPoint(x: frame.minX, y: frame.minY - 500), size : CGSize(width: frame.size.width * 1.5, height: 10.0))
        addChild(fallDetector)
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.maxY - 40)
        self.addChild(scoreText)
        
        // don't hardcode "200" below
        
        // World initialization
        self.backgroundColor = UIColor.blue
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Camera initialization
        cameraNode.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        currPlatform = platformGenerator.getPlatform(scene: self, pos: CGPoint(x: frame.minX, y: frame.minY * 0.35))
        self.addChild(currPlatform)
        self.addChild(self.hero)
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView.center = CGPoint(x: frame.maxX - 150, y: frame.minY + 20)
        progressView.progressTintColor = UIColor.init(red: 26/255, green: 148/255, blue: 49/255, alpha: 1.0)
        progressView.transform = progressView.transform.scaledBy(x: 1.5, y: 10)
        view.addSubview(progressView)
        progressView.progress = hero.energy
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
    
    func dashButtonPressed(_ sender: UIButton!){
        hero.Dash();
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

        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Bonus){
            
            if hero.energy < 1.0 {
                hero.energy += hero.energyDelta
            }
            
            if hero.energy > 1.0 {
                hero.energy = 1.0
            }
            
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
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                platformGenerator.addBonusToPool(bonus: contact.bodyA.node as! Bonus)
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
        
        
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.GarbageCollector) {
                died()
        }
        
    }
    
    func didEnd(_ contact:SKPhysicsContact) {
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground) {
            if (!hero.jumped) {
                hero.jumpsAllowed -= 1
            }
        }
    }
    
    func died() {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if hero.onGround {
//            hero.Jump()
//        }
        hero.Jump()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        progressView.progress = hero.energy
        // Create new ground block
        if self.hero.position.x > self.currPlatform.position.x + self.currPlatform.width / 2 && (nextPlatform == nil) {
            
            nextPlatform = platformGenerator.getPlatform(scene: self, pos: CGPoint(x: self.currPlatform.position.x + self.currPlatform.width, y: self.frame.minY * 0.35))//y: self.currPlatform.position.y))
            addChild(nextPlatform)
            print("Next platform created")
            print("next platform pos: ")
            print(self.currPlatform.position.x + self.currPlatform.width)
        }
        
        // Delete old ground and switch next and current blocks
        if self.currPlatform.position.x + self.currPlatform.width <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currPlatform.removeFromParent()
            print("Left camera border: ")
            print(self.scene!.camera!.position.x - self.frame.width / 2)
            print("Template pos + half template width: ")
            print(self.currPlatform.position.x + self.currPlatform.width / 2)
            
            //platformGenerator.addPlatformToPool(platform: currPlatform)
            self.currPlatform = self.nextPlatform!
            self.nextPlatform = nil
        }
        
        if hero.speedMult > 1.0 {
            hero.speedMult -= 0.05
        }
        if hero.speedMult < 1.0 {
            hero.speedMult = 1.0
        }
        
//        if hero.onGround {
            hero.physicsBody?.velocity = CGVector(dx: CGFloat(300 * hero.speedMult), dy: (hero.physicsBody?.velocity.dy)!)
//        }
        hero.Fall()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        cameraNode.position = CGPoint(x: hero.position.x + self.frame.width / 4, y: cameraNode.position.y)
        self.scoreText.position = CGPoint(x: scene!.camera!.position.x - frame.size.width / 2.2,
                                          y: scene!.camera!.position.y + frame.size.height / 2.7)
        garbageCollector.position = CGPoint(x: scene!.camera!.position.x - frame.size.width / 2 - garbageCollector.size.width, y: garbageCollector.position.y)
        
        fallDetector.position = CGPoint(x: scene!.camera!.position.x - frame.size.width / 2, y: fallDetector.position.y)
    }
}
