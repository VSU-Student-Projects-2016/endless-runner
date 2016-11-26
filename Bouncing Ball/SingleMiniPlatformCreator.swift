//
//  SingleMiniPlatformCreator.swift
//  Bouncing Ball
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class SingleMiniPlatformCreator : AbstractPlatformCreator {
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground1 = GroundBar(image: "desert", pos: pos)
        let ground2 = GroundBar(image: "desert", pos: pos)
        let ground3 = GroundBar(image: "desert", pos: pos)
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width - overlayWidth, y: ground1.position.y)
        ground3.position = CGPoint(x: ground2.position.x + ground2.size.width - overlayWidth, y: ground2.position.y)
        scene.addChild(ground1)
        scene.addChild(ground2)
        scene.addChild(ground3)
        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        platformTemplate.grounds.append(ground3)
        platformTemplate.width = ground1.size.width + ground2.size.width - overlayWidth + ground3.size.width - overlayWidth
        
        let smallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y + smallPlatformHeight * 2))
        scene.addChild(smallPlatform)
        platformTemplate.grounds.append(smallPlatform)
        
        // Add extra small platform
        var randNum = random(left: 0, right: 10)
        if randNum + difficulty < 11 {
            let smallPlatformMid = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground1.position.x + ground1.size.width / 4, y: ground1.position.y + smallPlatformHeight))
            scene.addChild(smallPlatformMid)
            platformTemplate.grounds.append(smallPlatformMid)
        }
        
        // place bonuces for dash or for double jump randomly
        randNum = random(left: 0, right: 10)
        if randNum < 5 {
            // add bonus arc
            addBonuses(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2, y: smallPlatform.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
            
            // add bonus or golden bonus randomly
            randNum = random(left: 0, right: 10)
            if randNum < 4{
                let goldBonus = GoldBonus(image: "gold_fish", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 5, y: smallPlatform.position.y + bonusLowPosHeight * 1.3))
                scene.addChild(goldBonus)
            } else {
                let bonus = Bonus(image: "fish", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 5, y: smallPlatform.position.y + bonusLowPosHeight * 1.3))
                scene.addChild(bonus)
            }
            
            // add bonus arc
            addBonuses(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 6, y: smallPlatform.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
            
            // add bad bonuses
            addBonusLine(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 3, y: ground2.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
            
            // add shield powerup or gold fish
            randNum = random(left: 0, right: 10)
            if randNum + difficulty < 14 {
                let shield = ShieldPU(image: "hero");
                shield.position = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 11, y: smallPlatform.position.y + bonusLowPosHeight)
                scene.addChild(shield)
            } else {
                let goldBonus = GoldBonus(image: "gold_fish", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 11, y: smallPlatform.position.y + bonusLowPosHeight));
                scene.addChild(goldBonus)
            }
            
        } else {
            // add bonus arc
            addBonuses(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2, y: smallPlatform.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 11)
            
            // add bad bonuses
            addBonusLine(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 3, y: smallPlatform.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 6)
            
            // add shield powerup or gold fish
            randNum = random(left: 0, right: 10)
            if randNum + difficulty < 14 {
                let shield = ShieldPU(image: "hero");
                shield.position = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 11, y: smallPlatform.position.y + bonusLowPosHeight)
                scene.addChild(shield)
            } else {
                let goldBonus = GoldBonus(image: "gold_fish", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 11, y: smallPlatform.position.y + bonusLowPosHeight));
                scene.addChild(goldBonus)
            }
        }
        
        // add random gold fish instead powerup
        
        
        // Add standing enemy
        randNum = random(left: 0, right: 10)
        if randNum < 7 {
            let enemy = Enemy(image: "block1", pos: CGPoint(x: ground1.position.x + smallPlatform.size.width, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        }
        
        // Add jumping enemy
        randNum = random(left: 0, right: 10)
        if randNum < 8 {
            let jumpingEnemy = JumpingEnemy(image: "block1", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(jumpingEnemy)
            platformTemplate.enemies.append(jumpingEnemy)
        }
        
        // Add leaping/dashing enemy here
        randNum = random(left: 0, right: 10)
        var leapingEnemyAdded = false
        if randNum < 5 {
            let leapingEnemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground3.position.x - ground3.size.width / 8, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(leapingEnemy)
            platformTemplate.enemies.append(leapingEnemy)
            leapingEnemyAdded = true
        } else {
            let dashingEnemy = DashingEnemy(image: "block1", pos: CGPoint(x: ground3.position.x - ground3.size.width / 8, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(dashingEnemy)
            platformTemplate.enemies.append(dashingEnemy)
        }
        
        randNum = random(left: 0, right: 10)
        if randNum < 7 {
            if leapingEnemyAdded {
                let dashingEnemy = DashingEnemy(image: "block1", pos: CGPoint(x: ground3.position.x + ground3.size.width / 8, y: smallPlatform.position.y - smallPlatformHeight))
                scene.addChild(dashingEnemy)
                platformTemplate.enemies.append(dashingEnemy)
            } else {
                let leapingEnemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground3.position.x + ground3.size.width / 8, y: smallPlatform.position.y - smallPlatformHeight))
                scene.addChild(leapingEnemy)
                platformTemplate.enemies.append(leapingEnemy)
            }
        } else {
            let enemy = Enemy(image: "block1", pos: CGPoint(x: ground3.position.x + ground3.size.width / 8, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        }
        
        return platformTemplate
    }
}
