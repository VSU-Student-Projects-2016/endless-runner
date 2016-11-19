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
    let bonusLowPosHeight = CGFloat(40)
    let bonusPosMult = CGFloat(50)
    let smallPlatformHeight = CGFloat(100)
    let platformGapWidth = CGFloat(200)
    
    func createPlatform(scene: PlayScene, pos: CGPoint, complexity: Int) -> PlatformTemplate {
        fatalError("This method must be overridden")
    }
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
}
