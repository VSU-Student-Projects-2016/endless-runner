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
        
        
        let step = Float.pi / 4
        for i in 0..<6 {
            let pos = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2, y: smallPlatform.position.y + bonusMidPosHeight)
            let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusPosMult * CGFloat(sin(step * Float(i)))))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
//        let shield = EnergyPU(image: "hero");
//        shield.position = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 5, y: smallPlatform.position.y + bonusLowPosHeight)
//        scene.addChild(shield)
        
//        let bonus = Bonus(image: "fish", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 5, y: smallPlatform.position.y + bonusLowPosHeight))
//        scene.addChild(bonus)
//        platformTemplate.bonuses.append(bonus)
        
        for i in 0..<5 {
            let pos = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 6, y: smallPlatform.position.y + bonusMidPosHeight)
            let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusPosMult * CGFloat(sin(step * Float(i)))))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
        let shield = ShieldPU(image: "hero");
        shield.position = CGPoint(x: smallPlatform.position.x + smallPlatform.size.width / 2 + bonusPosMult * 11, y: smallPlatform.position.y + bonusLowPosHeight)
        scene.addChild(shield)
        
        
        let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width, y: smallPlatform.position.y - smallPlatformHeight))
        scene.addChild(enemy)
        platformTemplate.enemies.append(enemy)
        
        let leapingEnemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground3.position.x, y: smallPlatform.position.y - smallPlatformHeight))
        scene.addChild(leapingEnemy)
        platformTemplate.enemies.append(leapingEnemy)
        
        
        return platformTemplate
    }
}
