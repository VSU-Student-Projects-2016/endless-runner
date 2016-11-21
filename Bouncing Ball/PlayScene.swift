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
    
    var currPlatform: PlatformTemplate!
    var nextPlatform: PlatformTemplate!
    
    var heroVelocity = Float(300)
    let maxVelocity = Float(600)
    
    var platformGenerator = PlatformGenerator()
    var score = 0;
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var hero: Hero!
    var energyConsumption = Float(0.0001)
    let energyConsumptionIncrease = Float(0.0001)
    let maxEnergyConsumption = Float(0.001)
    
    var difficulty = 0
    var stopErrorText = SKLabelNode(fontNamed: "Chalkduster")
    var lastHeroPosition = CGPoint(x: 0.0, y: 0.0)
    
    //var lastUpdateTimeInterval: TimeInterval = 0
    var platformsPassed = 0
    var platformPassToSpeedUp = 5
    
    var speedUpMult = Float(1.1)
    
    let cameraNode = SKCameraNode()
    
    var garbageCollector : GarbageCollector!
    var fallDetector : GarbageCollector!
    
    var pauseButton : UIButton!
    var exitButton : UIButton!
    
    var dashButton : UIButton!
    
    var energyBar : UIProgressView!
     
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        pauseButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.minY, width: 100.0, height: 100.0))
        pauseButton.setTitle("Pause Menu", for: .normal)
        pauseButton.setTitleColor(.red, for: .normal)
        pauseButton.addTarget(self, action: #selector(self.pauseButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(pauseButton)
        
        dashButton = UIButton(frame: CGRect(x: self.frame.minX, y: self.frame.maxY - 100, width: 100.0, height: 100.0))
        dashButton.setTitle("Dash", for: .normal)
        dashButton.setTitleColor(.red, for: .normal)
        dashButton.addTarget(self, action: #selector(self.dashButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(dashButton)
        
        exitButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100.0, height: 100.0))
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(self.exitButtonPressed(_:)), for: .touchUpInside)
        
        // don't hardcode "200" below
        hero = Hero(image: "1Cat", pos: CGPoint(x: self.frame.minX + 200, y: self.frame.midY), categoryBitMask: ColliderType.Hero, contactTestBitMask: ColliderType.Ground | ColliderType.PlatformSensor, collisionBitMask: ColliderType.Ground)
        //hero.zPosition = -12
        
        garbageCollector = GarbageCollector(pos: CGPoint(x: frame.minX - 200, y: frame.midY),
                                            size: CGSize(width: 50, height: frame.size.height * 2))
        addChild(garbageCollector)
        
        fallDetector = GarbageCollector(pos: CGPoint(x: frame.minX, y: frame.minY - 500), size : CGSize(width: frame.size.width * 1.5, height: 10.0))
        addChild(fallDetector)
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.maxY - 40)
        self.addChild(scoreText)
        
        // World initialization
        self.backgroundColor = UIColor.lightGray
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Camera initialization
        cameraNode.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        // Temporary error notice
        stopErrorText.text = "Hero doesn't move"
        stopErrorText.fontSize = 42
        stopErrorText.position = cameraNode.position
        lastHeroPosition = hero.position
        
        currPlatform = platformGenerator.getPlatform(scene: self, pos: CGPoint(x: frame.minX, y: frame.minY + frame.midY * 0.3), difficulty: difficulty)
        self.addChild(currPlatform)
        self.addChild(self.hero)
        print(currPlatform.position.y) // log
        
        energyBar = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        energyBar.center = CGPoint(x: frame.maxX - 150, y: frame.minY + 20)
        energyBar.progressTintColor = UIColor.init(red: 26/255, green: 148/255, blue: 49/255, alpha: 1.0)
        energyBar.transform = energyBar.transform.scaledBy(x: 1.5, y: 10)
        view.addSubview(energyBar)
        energyBar.progress = hero.energy
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
        hero.dash();
    }
    
    func exitButtonPressed(_ sender: UIButton!) {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {

            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
            removeViews()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Hero touches the ground
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.Ground){
            let heroTmp: SKNode
            let groundTmp: SKNode
            if contact.bodyA.categoryBitMask == ColliderType.Hero {
                heroTmp = contact.bodyA.node!
                groundTmp = contact.bodyB.node!
            }
            else {
                heroTmp = contact.bodyB.node!
                groundTmp = contact.bodyA.node!
            }
            if heroTmp.position.y > groundTmp.position.y {
                hero.land()
            }
        }

        // Hero collects a bonus
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
        
        // Hero rushes into an enemy
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Hero | ColliderType.Enemy {
            var enemy: Enemy
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                enemy = contact.bodyA.node as! Enemy
            }
            else {
                enemy = contact.bodyB.node as! Enemy
            }
            
            hero.powerUps[PowerUpTypes.Shield]?.onContact(with: enemy)
            
            if !enemy.isDead {
                hero.energy -= 0.5
                if hero.energy < 0 {
                    hero.energy = 0
                }
            }
        }
        
        // Hero touches enemy sensor
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Hero | ColliderType.EnemySensor {
            if contact.bodyA.categoryBitMask == ColliderType.EnemySensor {
                (contact.bodyA.node!.parent as! LeapingEnemy).leap()
            } else {
                (contact.bodyB.node!.parent as! LeapingEnemy).leap()
            }
        }
        
        // Remove an off-screen bonus
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Bonus | ColliderType.GarbageCollector {
            if contact.bodyA.categoryBitMask == ColliderType.Bonus {
                platformGenerator.addBonusToPool(bonus: contact.bodyA.node as! Bonus)
                contact.bodyA.node!.removeFromParent()
            } else {
                platformGenerator.addBonusToPool(bonus: contact.bodyB.node as! Bonus)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        // Remove an off-screen power-up
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.PowerUp | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.PowerUp {
                contact.bodyA.node!.removeFromParent()
            } else {
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        // Remove an off-screen enemy
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.GarbageCollector){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                platformGenerator.addEnemyToPool(enemy: contact.bodyA.node as! Enemy)
                contact.bodyA.node!.removeFromParent()
            } else {
                platformGenerator.addEnemyToPool(enemy: contact.bodyB.node as! Enemy)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
        // Enemy touches the ground
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Enemy | ColliderType.Ground){
            if contact.bodyA.categoryBitMask == ColliderType.Enemy {
                if contact.bodyA.node is JumpingEnemy {
                    (contact.bodyA.node as! JumpingEnemy).jump()
                }
            } else {
                if contact.bodyB.node is JumpingEnemy {
                    (contact.bodyB.node as! JumpingEnemy).jump()
                }
            }
        }
        
        // Hero goes off-screen
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == ColliderType.Hero | ColliderType.GarbageCollector) {
                died()
        }
        
        // Hero touches a platform sensor
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (ColliderType.Hero | ColliderType.PlatformSensor) {

            let hero: Hero
            let sensor: PlatformBar
            if contact.bodyA.categoryBitMask == ColliderType.Hero {
                hero = contact.bodyA.node! as! Hero
                sensor = contact.bodyB.node! as! PlatformBar
            } else {
                hero = contact.bodyB.node! as! Hero
                sensor = contact.bodyA.node! as! PlatformBar
            }
            if hero.position.y > sensor.position.y {
                sensor.MakeSolid()
            }
        }
        
        // Hero grabs power-up
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (ColliderType.Hero | ColliderType.PowerUp) {
            if (contact.bodyA.categoryBitMask == ColliderType.PowerUp) {
                (contact.bodyA.node! as! PowerUp).onAdd(to: hero)
                contact.bodyA.node!.removeFromParent()
            } else {
                (contact.bodyB.node! as! PowerUp).onAdd(to: hero)
                contact.bodyB.node!.removeFromParent()
            }
        }
        
    }
    
    // Game Over
    func died() {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
            removeViews()
        }
        
    }
    
    // Remove buttons and energy bar
    func removeViews() {
        exitButton.removeFromSuperview()
        pauseButton.removeFromSuperview()
        dashButton.removeFromSuperview()
        energyBar.removeFromSuperview()
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hero.jump()
    }
    
    override func update(_ currentTime: TimeInterval) {
        hero.update()
        
        // Temporary stop error handling
        if hero.position == lastHeroPosition && stopErrorText.position != cameraNode.position {
            //stopErrorText = SKLabelNode(fontNamed: "Chalkduster")
            stopErrorText.text = "Hero doesn't move"
            stopErrorText.fontSize = 42
            stopErrorText.position = cameraNode.position
            stopErrorText.position = cameraNode.position
            self.addChild(stopErrorText)
        }
        if hero.position != lastHeroPosition {
            stopErrorText.removeFromParent()
        }
        lastHeroPosition = hero.position
        
        // Update energy bar
        energyBar.progress = hero.energy
        
        // Create new ground template
        if hero.position.x > currPlatform.position.x + currPlatform.width / 2 && (nextPlatform == nil) {
            
            nextPlatform = platformGenerator.getPlatform(scene: self, pos: CGPoint(x: currPlatform.position.x + currPlatform.width - 5, y: currPlatform.position.y), difficulty: difficulty)
            addChild(nextPlatform)
        }
        
        // Delete old ground set and swap next and current blocks
        if currPlatform.position.x + currPlatform.width <= self.scene!.camera!.position.x - self.frame.width / 2 {
            self.currPlatform.removeFromParent()
            
            //platformGenerator.addPlatformToPool(platform: currPlatform)
            currPlatform = self.nextPlatform!
            nextPlatform = nil
            
            print(currPlatform.position.y) // log
            
            // Increase difficulty
            if heroVelocity < maxVelocity {
                platformsPassed += 1
                if platformsPassed == platformPassToSpeedUp {
                    heroVelocity *= speedUpMult
                    platformsPassed = 0
                    if energyConsumption < maxEnergyConsumption {
                        energyConsumption += energyConsumptionIncrease
                    }
                }
            }
        }
        
        // Decrease hero speed after dash
        if hero.speedMult > 1.0 {
            hero.speedMult -= 0.05
        }
        if hero.speedMult < 1.0 {
            hero.speedMult = 1.0
        }
        
        // Make hero yet a little more tired
        hero.energy -= energyConsumption
        
        // Keep hero's speed
        hero.physicsBody!.velocity = CGVector(dx: CGFloat(heroVelocity * hero.speedMult), dy: hero.physicsBody!.velocity.dy)
        
        // Handle hero's fall
        hero.fall()
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
