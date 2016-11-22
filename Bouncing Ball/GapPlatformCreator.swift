//
//  GapPlatformCreator.swift
//  Bouncing Ball
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class GapPlatformCreator : AbstractPlatformCreator {
    
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
        platformTemplate.width = ground1.size.width + ground2.size.width + platformGapWidth
        
        var randNum = random(left: 0, right: 10)
        
        // Add bonuses
        if (randNum < 8) {
            addBonuses(scene: scene, pos: CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
        }
        
        // Add enemy
        randNum = random(left: 0, right: 10)
        if (randNum < 5) {
            randNum = random(left: 0, right: 10)
            if randNum < 5 {
                let enemy = DashingEnemy(image: "block1", pos: CGPoint(x: ground1.position.x + ground1.size.width / 2 - 100, y: ground1.position.y + 200))
                scene.addChild(enemy)
                platformTemplate.enemies.append(enemy)
            } else {
                let enemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground1.position.x + ground1.size.width / 2 - 100, y: ground1.position.y + 200))
                scene.addChild(enemy)
                platformTemplate.enemies.append(enemy)
            }
        }
        
        return platformTemplate
    }
}
