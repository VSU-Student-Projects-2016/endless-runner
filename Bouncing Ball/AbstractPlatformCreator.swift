//
//  AbstractPlatrofmCreator.swift
//  Bouncing Ball
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class AbstractPlatformCreator {
    let bonusHighPosHeight = CGFloat(150)
    let bonusMidPosHeight = CGFloat(90)
    let bonusLowPosHeight = CGFloat(40)
    let bonusPosMult = CGFloat(50)
    let smallPlatformHeight = CGFloat(100)
    let platformGapWidth = CGFloat(200)
    let overlayWidth = CGFloat(10)
    
    func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        fatalError("This method must be overridden")
    }
    
    func addBonuses(scene: PlayScene, pos: CGPoint, stepHorizontal: CGFloat, quantity: Int, halfArc: Bool = false) {
        var stepVertical = CGFloat.pi / CGFloat(quantity - 1)
        if halfArc {
            stepVertical /= 2
        }
        for i in 0..<quantity {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(stepHorizontal * CGFloat(i)), y: pos.y + bonusPosMult * CGFloat(sin(stepVertical * CGFloat(i)))))
            scene.addChild(bonus)
        }
    }
    
    func addBonusLine(scene: PlayScene, pos: CGPoint, stepHorizontal: CGFloat, quantity: Int, isBadBonus : Bool = true) {
        if isBadBonus {
            for i in 0..<quantity {
                let badBonus = BadBonus(image: "gold_fish-1", pos: CGPoint(x: pos.x + CGFloat(stepHorizontal * CGFloat(i)), y: pos.y))
                scene.addChild(badBonus)
            }
        } else {
            for i in 0..<quantity {
                let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(stepHorizontal * CGFloat(i)), y: pos.y))
                scene.addChild(bonus)
            }
        }
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
}
