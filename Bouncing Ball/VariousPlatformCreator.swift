//
//  VariousPlatformCreator.swift
//  Bouncing Ball
//
//  Created by Admin on 11.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class VariousPlatformCreator : AbstractPlatformCreator {
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground1 = GroundBar(image: "desert", pos: pos)
        let ground2 = GroundBar(image: "desert", pos: pos)
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width - overlayWidth, y: ground1.position.y)
        
        let platformLeft = PlatformBar(image: "0_25desert", pos: pos)
        let platformRight = PlatformBar(image: "0_25desert", pos: pos)
        let platformMiddle = PlatformBar(image: "0_25desert", pos: pos)
        
        //ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        platformLeft.position = CGPoint(x: ground1.position.x, y: ground1.position.y + smallPlatformHeight)
        platformRight.position = CGPoint(x: ground1.position.x + ground1.size.width - platformRight.size.width, y: ground1.position.y + smallPlatformHeight)
        var randNum = random(left: 0, right: 2)
        if randNum == 0 {
            platformMiddle.position = CGPoint(x: ground1.position.x + platformLeft.size.width * 1.5, y: ground1.position.y + smallPlatformHeight)
        }
        else{
            platformMiddle.position = CGPoint(x: ground1.position.x + platformLeft.size.width * 1.5, y: ground1.position.y + smallPlatformHeight * 2)
        }
        
        scene.addChild(ground1)
        scene.addChild(ground2)
        scene.addChild(platformLeft)
        scene.addChild(platformRight)
        scene.addChild(platformMiddle)
        
        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        platformTemplate.grounds.append(platformLeft)
        platformTemplate.grounds.append(platformRight)
        platformTemplate.grounds.append(platformMiddle)
        platformTemplate.width = ground1.size.width + ground2.size.width
        
        randNum = random(left: 0, right: 3)
        switch randNum {
        case 0:
            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: platformLeft.position.x + platformLeft.size.width, y: platformLeft.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        case 1:
            let enemy = Enemy(image: "block1", pos: CGPoint(x: platformLeft.position.x + platformLeft.size.width, y: platformLeft.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        default: break
        }
        
        randNum = random(left: 0, right: 3)
        switch randNum {
        case 0:
            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: platformMiddle.position.x + platformMiddle.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        case 1:
            let enemy = DashingEnemy(image: "block1", pos: CGPoint(x: platformMiddle.position.x + platformMiddle.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        default:
            break
        }
        
        for i in 0..<4 {
            let bonus = Bonus(pos: CGPoint(x: platformMiddle.position.x - platformMiddle.size.width / 4 + CGFloat(i)*bonusPosMult, y : ground1.position.y + bonusLowPosHeight))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
        randNum = random(left: 0, right: 2)
        if randNum == 0 {
            for i in 0..<4 {
                let bonus = Bonus(pos: CGPoint(x: platformLeft.position.x - platformLeft.size.width / 4 + CGFloat(i) * bonusPosMult, y : platformLeft.position.y + bonusLowPosHeight))
                scene.addChild(bonus)
                platformTemplate.bonuses.append(bonus)
            }
        
            for i in 0..<4 {
                let bonus = Bonus(pos: CGPoint(x: platformRight.position.x - platformRight.size.width / 4 + CGFloat(i) * bonusPosMult, y : platformRight.position.y + bonusLowPosHeight))
                scene.addChild(bonus)
                platformTemplate.bonuses.append(bonus)
            }
        }
        
        addBonuses(scene: scene, pos: CGPoint(x: platformRight.position.x + platformRight.size.width / 2, y: platformRight.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 10)
        
        randNum = random(left: 0, right: 10)
        if randNum - difficulty < 5 {
            let enemy = LeapingEnemy(image: "block1", pos: CGPoint(x: ground2.position.x + bonusPosMult * 10, y: ground2.position.y + 200))
            scene.addChild(enemy)
        }
        
        return platformTemplate
    }
}
