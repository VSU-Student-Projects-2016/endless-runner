//
//  TripleMiniPlatformCreator.swift
//  Bouncing Ball
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class TripleMiniPlatformCreator : AbstractPlatformCreator {
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground1 = GroundBar(image: "desert", pos: pos)
        let ground2 = GroundBar(image: "desert", pos: pos)
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width, y: ground1.position.y)
        scene.addChild(ground1)
        scene.addChild(ground2)
        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        platformTemplate.width = ground1.size.width + ground2.size.width
        
        let smallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y + smallPlatformHeight * 2))
        scene.addChild(smallPlatform)
        platformTemplate.grounds.append(smallPlatform)
        
        let leftSmallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: smallPlatform.position.x - smallPlatform.size.width, y: smallPlatform.position.y - smallPlatformHeight))
        scene.addChild(leftSmallPlatform)
        platformTemplate.grounds.append(leftSmallPlatform)
        
        let rightSmallPlatform = PlatformBar(image: "0_25desert", pos: CGPoint(x: smallPlatform.position.x + smallPlatform.size.width, y: smallPlatform.position.y - smallPlatformHeight))
        scene.addChild(rightSmallPlatform)
        platformTemplate.grounds.append(rightSmallPlatform)
        
        let randNum = random(left: 0, right: 2)
        if randNum == 0 {
            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: smallPlatform.position.x, y: smallPlatform.position.y - smallPlatformHeight))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        }
        
        for i in 0..<4 {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: leftSmallPlatform.position.x - leftSmallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : leftSmallPlatform.position.y + bonusLowPosHeight))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
        for i in 0..<4 {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: smallPlatform.position.x - smallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : smallPlatform.position.y + bonusLowPosHeight))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
        for i in 0..<4 {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: rightSmallPlatform.position.x - rightSmallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : rightSmallPlatform.position.y + bonusLowPosHeight))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        return platformTemplate
    }
}
