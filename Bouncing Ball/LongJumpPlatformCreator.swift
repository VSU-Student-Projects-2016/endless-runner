//
//  LongJumpPlatformCreator.swift
//  EndlessRunner
//
//  Created by Admin on 21.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class LongJumpPlatformCreator : AbstractPlatformCreator {
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground1 = GroundBar(image: "desert", pos: pos)
        let ground2 = GroundBar(image: "desert", pos: pos)
        
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width + platformGapWidth, y: ground1.position.y)
        
        scene.addChild(ground1)
        scene.addChild(ground2)
        
        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        
        platformTemplate.width = ground1.size.width + ground2.size.width - overlayWidth
        
        var randNum = random(left: 0, right: 10)
        if randNum < 4 {
            let extraSmallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground1.position.x - ground1.size.width * 3 / 8, y: ground1.position.y + smallPlatformHeight))
            scene.addChild(extraSmallPlatform)
            platformTemplate.grounds.append(extraSmallPlatform)
        }
        
        let smallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground1.position.x + ground1.size.width / 4, y: ground1.position.y + smallPlatformHeight * 2))
        scene.addChild(smallPlatform)
        platformTemplate.grounds.append(smallPlatform)
        
        // add bonus half arc
        addBonuses(scene: scene, pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult, y: smallPlatform.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 9, halfArc: true)
        
        // add bad bonuses
        addBadBonuses(scene: scene, pos: CGPoint(x: ground1.position.x + ground1.size.width / 2 + bonusPosMult, y: ground1.position.y + bonusHighPosHeight), stepHorizontal: bonusPosMult, quantity: 3)
        
        // add dashing enemy
        let dashEnemy = DashingEnemy(image: "block1", pos: CGPoint(x: smallPlatform.position.x, y: ground1.position.y + 200))
        scene.addChild(dashEnemy)
        platformTemplate.enemies.append(dashEnemy)
        
        // add leaping enemy
        let leapingEnemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground2.position.x - ground1.size.width * 3 / 8, y: ground2.position.y + 200))
        scene.addChild(leapingEnemy)
        platformTemplate.enemies.append(leapingEnemy)
        
        let smallPlatformBonus = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground2.position.x - ground2.size.width / 4, y: ground2.position.y + smallPlatformHeight * 3))
        scene.addChild(smallPlatformBonus)
        platformTemplate.grounds.append(smallPlatformBonus)

        
        let shield = ShieldPU(image: "hero_fall");
        shield.position = CGPoint(x: smallPlatformBonus.position.x, y: smallPlatformBonus.position.y + bonusLowPosHeight)
        scene.addChild(shield)

        
        
        return platformTemplate
    }
}
