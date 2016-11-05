//
//  PlatformTemplate.swift
//  Bouncing Ball
//
//  Created by xcode on 29.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformTemplate: SKNode {
    
    var grounds = [GroundBar]()
    var enemies = [Enemy]()
    var bonuses = [Bonus]()
    var width = CGFloat(0)
    let bonusPosHeight = CGFloat(200)
    let bonusPosMult = CGFloat(50)
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
