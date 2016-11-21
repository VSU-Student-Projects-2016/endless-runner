//
//  MultipleMiniPlatformsCreator.swift
//  Bouncing Ball
//
//  Created by Admin on 11.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class MultipleMiniPlatformCreator : AbstractPlatformCreator {
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground1 = PlatformBar(image: "0_25desert", pos: pos)
        let ground2 = PlatformBar(image: "0_25desert", pos: pos)
        let ground3 = PlatformBar(image: "0_25desert", pos: pos)
        let ground4 = PlatformBar(image: "0_25desert", pos: pos)
        
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width, y: ground1.position.y + smallPlatformHeight)
        
        ground3.position = CGPoint(x: ground2.position.x + ground2.size.width / 2, y: ground1.position.y)
        ground4.position = CGPoint(x: ground3.position.x + ground3.size.width, y: ground1.position.y)
        
        
        var randNum = random(left: 0, right: 2)
        if randNum == 0 {
            ground3.position = CGPoint(x: ground2.position.x + ground2.size.width, y: ground2.position.y + smallPlatformHeight)
        }else{
            ground3.position = CGPoint(x: ground2.position.x + ground2.size.width, y: ground2.position.y - smallPlatformHeight)
        }
        
        randNum = random(left: 0, right: 2)
        if randNum == 0 {
            ground4.position = CGPoint(x: ground3.position.x + ground3.size.width, y: ground2.position.y)
        }else{
            ground4.position = CGPoint(x: ground3.position.x + ground3.size.width, y: ground2.position.y - smallPlatformHeight)
        }
        
        scene.addChild(ground1)
        scene.addChild(ground2)
        scene.addChild(ground3)
        scene.addChild(ground4)
        
        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        platformTemplate.grounds.append(ground3)
        platformTemplate.grounds.append(ground4)
        platformTemplate.width = ground1.size.width + ground2.size.width + ground3.size.width + ground4.size.width

//        
//        let randNum = random(left: 0, right: 2)
//        if randNum == 0 {
//            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: smallPlatform.position.x, y: smallPlatform.position.y - smallPlatformHeight))
//            scene.addChild(enemy)
//            platformTemplate.enemies.append(enemy)
//        }
//        
//        for i in 0..<4 {
//            let bonus = Bonus(image: "fish", pos: CGPoint(x: leftSmallPlatform.position.x - leftSmallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : leftSmallPlatform.position.y + bonusPosHeight))
//            scene.addChild(bonus)
//            platformTemplate.bonuses.append(bonus)
//        }
//        
//        for i in 0..<4 {
//            let bonus = Bonus(image: "fish", pos: CGPoint(x: smallPlatform.position.x - smallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : smallPlatform.position.y + bonusPosHeight))
//            scene.addChild(bonus)
//            platformTemplate.bonuses.append(bonus)
//        }
//        
//        for i in 0..<4 {
//            let bonus = Bonus(image: "fish", pos: CGPoint(x: rightSmallPlatform.position.x - rightSmallPlatform.size.width / 4 + CGFloat(i)*bonusPosMult, y : rightSmallPlatform.position.y + bonusPosHeight))
//            scene.addChild(bonus)
//            platformTemplate.bonuses.append(bonus)
//        }
        return platformTemplate
    }
}
