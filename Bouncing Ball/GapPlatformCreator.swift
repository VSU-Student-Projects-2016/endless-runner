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
    //let bonusPosHeight = CGFloat(200)
    //let bonusPosMult = CGFloat(50)
    //let platformGapWidth = CGFloat(200)
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, complexity: Int) -> PlatformTemplate {
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
        
        if (randNum < 8) {
            let step = Float.pi / 4
            for i in 0..<5 {
                let pos = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
                let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusHighPosHeight + bonusPosMult * CGFloat(sin(step * Float(i)))))
                scene.addChild(bonus)
                platformTemplate.bonuses.append(bonus)
            }
        }
        
        randNum = random(left: 0, right: 2)
        if (randNum == 0) {
            let enemy = DashingEnemy(image: "block1", pos: CGPoint(x: ground1.position.x + ground1.size.width / 2 - 100, y: ground1.position.y + 200))
            scene.addChild(enemy)
            platformTemplate.enemies.append(enemy)
        }
        return platformTemplate
    }
}
