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
    
    let EPS = CGFloat(5.0)
    
    var currentRunningBar = SKSpriteNode(imageNamed:"bar")
    var nextRunningBar = SKSpriteNode(imageNamed: "bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    
    let cameraNode = SKCameraNode()
    
    let block1 = SKSpriteNode(imageNamed:"block1")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    let bounceCountText = SKLabelNode(fontNamed: "Chalkduster")
    
    var nextPlatformCreated = false
    var onGround = true

    
 
    var score = 0
    var bounceCount = 0
    
    
    enum ColliderType:UInt32 {
        case None = 0
        case Hero = 0b1
        case Block = 0b10
        case Ground = 0b100
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.blue
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
//        let sceneBody = SKPhysicsBody(edgeLoopFrom: CGRect(dictionaryRepresentation: self.frame as! CFDictionary)!)
//        sceneBody.friction = 0
//        self.physicsBody = sceneBody
        
        cameraNode.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        
        self.currentRunningBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.currentRunningBar.position = CGPoint(
            x: self.frame.minX,
            y: self.frame.minY + (self.currentRunningBar.size.height / 2))
        
//        self.nextRunningBar.anchorPoint = CGPoint(x: 0, y: 0.5)
//        self.nextRunningBar.position = CGPoint(
//            x: self.currentRunningBar.size.width,
//            y: self.frame.minY + (self.currentRunningBar.size.height / 2) - 40)
        
        //self.heroBaseline = self.runningBar.position.y + (self.runningBar.size.height / 2) + (self.hero.size.height / 2)
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width + (self.hero.size.width / 4), y: self.frame.midY / 4)
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.Hero.rawValue
        //self.hero.physicsBody?.contactTestBitMask = ColliderType.Block.rawValue | ColliderType.Ground.rawValue
        //self.hero.physicsBody?.collisionBitMask = ColliderType.Block.rawValue | ColliderType.Ground.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.Ground.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.Ground.rawValue
        self.hero.physicsBody?.affectedByGravity = true
        self.hero.physicsBody?.restitution = 0.0
        self.hero.physicsBody?.velocity = CGVector(dx: 200.0, dy: 0.0)
        self.hero.physicsBody?.linearDamping = 0
        
        
//        self.block1.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseline)
//        self.block2.position = CGPoint(x: self.frame.maxX + self.block2.size.width, y: self.heroBaseline + (self.block1.size.height / 2))
//        self.block1.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
//        self.block1.physicsBody?.isDynamic = false
//        self.block1.physicsBody?.categoryBitMask = ColliderType.Block.rawValue
//        self.block1.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
//        self.block1.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
//        
//        self.block2.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
//        self.block2.physicsBody?.isDynamic = false
//        self.block2.physicsBody?.categoryBitMask = ColliderType.Block.rawValue
//        self.block2.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
//        self.block2.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        
        self.currentRunningBar.physicsBody = SKPhysicsBody(rectangleOf: self.currentRunningBar.size)
        self.currentRunningBar.physicsBody?.isDynamic = false
        self.currentRunningBar.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        self.currentRunningBar.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.currentRunningBar.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        self.currentRunningBar.physicsBody?.restitution = 0.0
        
        
        


        
        self.block1.name = "block1"
        self.block2.name = "block2"
        
        // Spawn Blocks
//        blockStatuses["block1"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
//        blockStatuses["block2"] = BlockStatus(isRunning: false, timeGapForNextRun: random(), currentInterval: UInt32(0))
//        
        // Show Scores
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.bounceCountText.text = "0"
        self.bounceCountText.fontSize = 42
        self.bounceCountText.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 30)
        

        
        self.addChild(self.currentRunningBar)
        //self.addChild(self.nextRunningBar)
        self.addChild(self.hero)
        //self.addChild(self.block1)
        //self.addChild(self.block2)
        self.addChild(self.scoreText)
        self.addChild(self.bounceCountText)
        
    }
    

    
    func didBegin(_ contact:SKPhysicsContact) {
        // Checking and changing onGround variable
        if((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == 5){
            onGround = true
            print("Grounded")
            
        }

        //died()
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
    
    var blockStatuses:Dictionary<String,BlockStatus> = [:]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.onGround {
            print("Jumped")
            self.hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
            self.onGround = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func createGroundBlock(position : CGPoint) {
        nextRunningBar = SKSpriteNode(imageNamed: "bar")
        self.nextRunningBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.nextRunningBar.physicsBody = SKPhysicsBody(rectangleOf: self.nextRunningBar.size)
        self.nextRunningBar.physicsBody?.isDynamic = false
        self.nextRunningBar.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        self.nextRunningBar.physicsBody?.contactTestBitMask = ColliderType.Hero.rawValue
        self.nextRunningBar.physicsBody?.collisionBitMask = ColliderType.Hero.rawValue
        self.nextRunningBar.physicsBody?.restitution = 0.0
        self.nextRunningBar.position = position
        self.addChild(nextRunningBar)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        cameraNode.position = CGPoint(x: hero.position.x, y: cameraNode.position.y)
        
        if self.hero.position.x > (self.currentRunningBar.position.x + currentRunningBar.size.width / 2) && !nextPlatformCreated{
            
            createGroundBlock(position: CGPoint(x: self.currentRunningBar.position.x + self.currentRunningBar.size.width,
                                                   y: self.currentRunningBar.position.y))
            nextPlatformCreated = true
        }
        
        if self.currentRunningBar.position.x + self.currentRunningBar.size.width <= self.frame.minX {
            self.currentRunningBar.removeFromParent()
            currentRunningBar = self.nextRunningBar.copy() as! SKSpriteNode
            self.nextRunningBar.removeFromParent()
            nextPlatformCreated = false
        }
        
        //self.position = CGPoint(x: cameraNode.position.x + 1, y: cameraNode.position.y)
        
        //rotate the hero
        //let degreeRotation = CDouble(0.6) * M_PI / 180
        //rotate the hero
        //self.hero.zRotation -= CGFloat(degreeRotation)
        
        //blockRunner()
    }
    
//    func blockRunner() {
//        for(block, blockStatus) in self.blockStatuses {
//            let thisBlock = self.childNode(withName: block)!
//            if blockStatus.shouldRunBlock() {
//                blockStatus.timeGapForNextRun = random()
//                blockStatus.currentInterval = 0
//                blockStatus.isRunning = true
//            }
//            
//            if blockStatus.isRunning {
//                if thisBlock.position.x > blockMaxX {
//                    thisBlock.position.x -= CGFloat(self.groundSpeed)
//                }else {
//                    thisBlock.position.x = self.origBlockPositionX
//                    blockStatus.isRunning = false
//                    self.score += 1
//                    if ((self.score % 5) == 0) {
//                        self.groundSpeed += 1
//                    }
//                    self.scoreText.text = String(self.score)
//                }
//            }else {
//                blockStatus.currentInterval += 1
//            }
//        }
//    }
}
