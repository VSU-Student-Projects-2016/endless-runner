//
//  BonusPlatformCreator.swift
//  Bouncing Ball
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class BonusPlatformCreator : AbstractPlatformCreator {
    //let bonusPosHeight = CGFloat(200)
    //let bonusPosMult = CGFloat(50)
    
    override func createPlatform(scene: PlayScene, pos: CGPoint) -> PlatformTemplate {
        
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        for j in 0..<2 {
            let ground = GroundBar(image: "desert", pos: pos)
            ground.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y)
            ground.position = CGPoint(x: ground.position.x + CGFloat(j) * ground.size.width, y: ground.position.y)
            scene.addChild(ground)
            platformTemplate.grounds.append(ground)
            platformTemplate.width += ground.size.width
            
            // Add power-up
            let shield = EnergyPU(image: "hero");
            shield.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y + smallPlatformHeight * 2)
            scene.addChild(shield)
            
            let randNum = random(left: 0, right: 10)
            
            if (randNum < 7) {
                let step = Float.pi / 4
                for i in 0..<5 {
                    let pos = ground.position
                    let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusHighPosHeight + bonusPosMult * CGFloat(sin(step * Float(i)))))
                    scene.addChild(bonus)
                    platformTemplate.bonuses.append(bonus)
                }
            }
        }
        
        return platformTemplate
    }
}
