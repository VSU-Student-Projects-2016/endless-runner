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
    //let bonusPosHeight = CGFloat(20)
    //let bonusPosMult = CGFloat(50)
    //let smallPlatformHeight = CGFloat(100)
    
    override func createPlatform(scene: PlayScene, pos: CGPoint) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground = GroundBar(image: "desert", pos: pos)
        let platformLeft = GroundBar(image: "0_25desert", pos: pos)
        let platformRight = GroundBar(image: "0_25desert", pos: pos)
        let platformMiddle = GroundBar(image: "0_25desert", pos: pos)
        
        ground.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y)
        platformLeft.position = CGPoint(x: ground.position.x, y: ground.position.y + smallPlatformHeight)
        platformRight.position = CGPoint(x: ground.position.x + ground.size.width - platformRight.size.width, y: ground.position.y + smallPlatformHeight)
        var randNum = random(left: 0, right: 2)
        if randNum == 0 {
            platformMiddle.position = CGPoint(x: ground.position.x + platformLeft.size.width * 1.5, y: ground.position.y + smallPlatformHeight)
        }
        else{
            platformMiddle.position = CGPoint(x: ground.position.x + platformLeft.size.width * 1.5, y: ground.position.y + smallPlatformHeight * 2)
        }
        
        scene.addChild(ground)
        scene.addChild(platformLeft)
        scene.addChild(platformRight)
        scene.addChild(platformMiddle)
        
        platformTemplate.grounds.append(ground)
        platformTemplate.grounds.append(platformLeft)
        platformTemplate.grounds.append(platformRight)
        platformTemplate.grounds.append(platformMiddle)
        platformTemplate.width = ground.size.width
        
        randNum = random(left: 0, right: 3)
        switch randNum {
        case 0:
            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: platformRight.position.x + platformRight.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        case 1:
            let enemy = Enemy(image: "block1", pos: CGPoint(x: platformRight.position.x - platformRight.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        default:
            break
        }
        
        randNum = random(left: 0, right: 3)
        switch randNum {
        case 0:
            let enemy = JumpingEnemy(image: "block1", pos: CGPoint(x: platformMiddle.position.x + platformMiddle.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        case 1:
            let enemy = Enemy(image: "block1", pos: CGPoint(x: platformMiddle.position.x + platformMiddle.size.width, y: platformRight.position.y - smallPlatformHeight / 2))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        default:
            break
        }
        
        for i in 0..<4 {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: platformMiddle.position.x - platformMiddle.size.width / 4 + CGFloat(i)*bonusPosMult, y : ground.position.y + bonusLowPosHeight))
            scene.addChild(bonus)
            platformTemplate.bonuses.append(bonus)
        }
        
        randNum = random(left: 0, right: 2)
        if randNum == 0 {
            for i in 0..<4 {
                let bonus = Bonus(image: "fish", pos: CGPoint(x: platformLeft.position.x - platformLeft.size.width / 4 + CGFloat(i) * bonusPosMult, y : platformLeft.position.y + bonusLowPosHeight))
                scene.addChild(bonus)
                platformTemplate.bonuses.append(bonus)
            }
        
            for i in 0..<4 {
                let bonus = Bonus(image: "fish", pos: CGPoint(x: platformRight.position.x - platformRight.size.width / 4 + CGFloat(i) * bonusPosMult, y : platformRight.position.y + bonusLowPosHeight))
                scene.addChild(bonus)
                platformTemplate.bonuses.append(bonus)
            }
        }
        return platformTemplate
    }
}
