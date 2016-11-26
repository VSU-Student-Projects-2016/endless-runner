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
    
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        
        let platformTemplate = PlatformTemplate()
        var randNum: Int
        platformTemplate.position = pos
        for i in 0..<2 {
            let ground = GroundBar(image: "desert", pos: pos)
            ground.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y)
            ground.position = CGPoint(x: ground.position.x + CGFloat(i) * ground.size.width, y: ground.position.y)
            if i > 0 {
                ground.position = CGPoint(x: ground.position.x - overlayWidth, y: ground.position.y)
            }
            scene.addChild(ground)
            platformTemplate.grounds.append(ground)
            platformTemplate.width += ground.size.width - overlayWidth
            if i > 0 {
                platformTemplate.width -= overlayWidth
            }
            
            // add bad bonuses under power-up
            randNum = random(left: 0, right: 10)
            if i == 0 && randNum - difficulty < 6 {
                addBadBonuses(scene: scene, pos: CGPoint(x: ground.position.x + ground.size.width / 2 - bonusPosMult * 2, y: ground.position.y + bonusHighPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
            }
            // Add power-up
            randNum = random(left: 0, right: 10)
            if i == 0 && randNum < 3 {
                let enegryBooster = EnergyPU(image: "hero");
                enegryBooster.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y + smallPlatformHeight * 2.5)
                scene.addChild(enegryBooster)
            }
            
            // Add bonuses arc
            randNum = random(left: 0, right: 10)
            if (randNum < 8) {
                addBonuses(scene: scene, pos: CGPoint(x: ground.position.x, y: ground.position.y + bonusMidPosHeight), stepHorizontal: bonusPosMult, quantity: 5)
            }
            if randNum - difficulty < 2 {
                addBadBonuses(scene: scene, pos: CGPoint(x: ground.position.x + bonusPosMult / 2, y: ground.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4)
            }
            
        }
        
        
        
        return platformTemplate
    }
}
