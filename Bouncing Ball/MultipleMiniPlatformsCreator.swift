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
        let ground5 = PlatformBar(image: "0_25desert", pos: pos)
        let ground6Top = PlatformBar(image: "0_25desert", pos: pos)
        let ground6Bottom = PlatformBar(image: "0_25desert", pos: pos)
        
        ground1.position = CGPoint(x: ground1.position.x + ground1.size.width / 2, y: ground1.position.y)
        ground2.position = CGPoint(x: ground1.position.x + ground1.size.width, y: ground1.position.y + smallPlatformHeight)
        
        ground3.position = CGPoint(x: ground2.position.x + ground2.size.width, y: ground1.position.y)
        
        var randNum = random(left: 0, right: 10)
        if randNum < 5 {
            ground3.position = CGPoint(x: ground3.position.x + platformGapWidth, y: ground3.position.y)
            platformTemplate.width += platformGapWidth
        }
        
        ground4.position = CGPoint(x: ground3.position.x + ground3.size.width, y: ground1.position.y)
        
        ground5.position = CGPoint(x: ground4.position.x + ground4.size.width, y: ground2.position.y)
        
        randNum = random(left: 0, right: 10)
        if randNum < 5 {
            ground5.position = CGPoint(x: ground5.position.x + platformGapWidth, y: ground5.position.y)
            platformTemplate.width += platformGapWidth
        }
        
        ground6Top.position = CGPoint(x: ground5.position.x + ground5.size.width, y: ground5.position.y + smallPlatformHeight)
        ground6Bottom.position = CGPoint(x: ground5.position.x + ground5.size.width, y: ground5.position.y - smallPlatformHeight)
        
        
        randNum = random(left: 0, right: 2)
        if randNum == 0 {
            ground3.position = CGPoint(x: ground3.position.x, y: ground2.position.y + smallPlatformHeight)
        }else{
            ground3.position = CGPoint(x: ground3.position.x, y: ground2.position.y - smallPlatformHeight)
        }
        
        randNum = random(left: 0, right: 10)
        if randNum < 7 {
            addBonusLine(scene: scene, pos: CGPoint(x: ground3.position.x - ground3.size.width / 2 + bonusPosMult * 1.5, y: ground3.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4, isBadBonus: false)
        }
        
        randNum = random(left: 0, right: 2)
        if randNum == 0 {
            ground4.position = CGPoint(x: ground4.position.x, y: ground2.position.y)
        }else{
            ground4.position = CGPoint(x: ground4.position.x, y: ground2.position.y - smallPlatformHeight)
        }
        
        randNum = random(left: 0, right: 10)
        if randNum < 5 {
            addBonusLine(scene: scene, pos: CGPoint(x: ground6Top.position.x - ground6Top.size.width / 2 + bonusPosMult * 1.5, y: ground6Top.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4)
            if randNum < 3 {
                addBonusLine(scene: scene, pos: CGPoint(x: ground6Bottom.position.x - ground6Bottom.size.width / 2 + bonusPosMult * 1.5, y: ground6Bottom.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4, isBadBonus: false)
            }
        } else {
            addBonusLine(scene: scene, pos: CGPoint(x: ground6Bottom.position.x - ground6Bottom.size.width / 2 + bonusPosMult * 1.5, y: ground6Bottom.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4)
            if randNum < 8 {
                addBonusLine(scene: scene, pos: CGPoint(x: ground6Top.position.x - ground6Top.size.width / 2 + bonusPosMult * 1.5, y: ground6Top.position.y + bonusLowPosHeight), stepHorizontal: bonusPosMult, quantity: 4, isBadBonus: false)
            }
        }
        
        
        scene.addChild(ground1)
        scene.addChild(ground2)
        scene.addChild(ground3)
        scene.addChild(ground4)
        scene.addChild(ground5)
        scene.addChild(ground6Top)
        scene.addChild(ground6Bottom)

        platformTemplate.grounds.append(ground1)
        platformTemplate.grounds.append(ground2)
        platformTemplate.grounds.append(ground3)
        platformTemplate.grounds.append(ground4)
        platformTemplate.grounds.append(ground5)
        platformTemplate.grounds.append(ground6Top)
        platformTemplate.grounds.append(ground6Bottom)
        platformTemplate.width = ground1.size.width + ground2.size.width + ground3.size.width + ground4.size.width + ground5.size.width + ground6Top.size.width

        return platformTemplate
    }
}
