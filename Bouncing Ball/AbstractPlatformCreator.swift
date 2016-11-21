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
    
    func addBonuses(scene: PlayScene, pos: CGPoint, stepHorizontal: CGFloat, quantity: Int) {
        let stepVertical = CGFloat.pi / 4
        //let stepHorizontal = CGFloat(length / CGFloat(quantity - 1))
        for i in 0..<quantity {
            let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(stepHorizontal * CGFloat(i)), y: pos.y + bonusPosMult * CGFloat(sin(stepVertical * CGFloat(i)))))
            scene.addChild(bonus)
            //platformTemplate.bonuses.append(bonus)
        }
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
}
