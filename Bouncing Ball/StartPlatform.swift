//
//  StartPlatform.swift
//  EndlessRunner
//
//  Created by xcode on 26.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class StartPlatformCreator: AbstractPlatformCreator {
    override func createPlatform(scene: PlayScene, pos: CGPoint, difficulty: Int) -> PlatformTemplate {
        let platformTemplate = PlatformTemplate()
        platformTemplate.position = pos
        let ground = GroundBar(image: "desert", pos: pos)
        ground.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y)
        platformTemplate.grounds.append(ground)
        platformTemplate.width = ground.size.width
        scene.addChild(ground)
        return platformTemplate
    }
}
