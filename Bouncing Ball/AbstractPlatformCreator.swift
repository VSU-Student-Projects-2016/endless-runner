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
    let bonusPosHeight = CGFloat(20)
    let bonusPosMult = CGFloat(50)
    let smallPlatformHeight = CGFloat(100)
    let platformGapWidth = CGFloat(200)
    
    func createPlatform(scene: PlayScene, pos: CGPoint) -> PlatformTemplate {
        fatalError("This method must be overridden")
    }
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
}
