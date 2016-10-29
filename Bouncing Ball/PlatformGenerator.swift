//
//  PlatformGenerator.swift
//  Bouncing Ball
//
//  Created by xcode on 29.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformGenerator {
    //var platform: GroundBar!
    var platformPool = [GroundBar]()
    var bonusPool = [Bonus]()
    var enemyPool = [Enemy]()
    
    public init (){
        enemyPool.append(DashingEnemy(image: "block1", pos: CGPoint(x: 0, y : 0)))
        enemyPool.append(JumpingEnemy(image: "block1", pos: CGPoint(x: 0, y : 0)))
        enemyPool.append(Enemy(image: "block1", pos: CGPoint(x: 0, y : 0)))

        for _ in (0..<10) {
            bonusPool.append(Bonus(image: "fish", pos: CGPoint.zero))
        }
        
        platformPool.append(GroundBar(image: "desert", pos: CGPoint.zero))
        platformPool.append(GroundBar(image: "forest", pos: CGPoint.zero))
        platformPool.append(GroundBar(image: "ice", pos: CGPoint.zero))
        platformPool.append(GroundBar(image: "ponyland", pos: CGPoint.zero))
    }
    
    func getPlatform(scene: PlayScene, pos: CGPoint) -> GroundBar {
        var platform: GroundBar!
        
        if platformPool.count > 0 {
            platform = platformPool[0]
            platform.position = pos
            platformPool.remove(at: 0)
        }
        
        let randNum = random(left: 0, right: 10)
        
        if (randNum % 2 == 0) {
            addBonus(scene: scene, position: CGPoint(x: platform.position.x,
                                       y: platform.position.y + 100)) // make it variable
        }
        
        if (randNum % 3 == 0) {
            addEnemy(scene: scene, position: CGPoint(x: platform.position.x,
                                       y: platform.position.y + 50)) // make it variable
        }
        
        scene.addChild(platform)

        return platform
    }
    
    func addEnemyToPool(enemy: Enemy){
        enemyPool.append(enemy)
    }
    
    func addBonusToPool(bonus: Bonus){
        bonusPool.append(bonus)
    }
    
    func addPlatformToPool(platform: GroundBar){
        platformPool.append(platform)
    }
    
    private func addBonus(scene: PlayScene, position: CGPoint) {
        if bonusPool.count >= 5 {
            for i in 0..<5 {
                let bonus = bonusPool[0]
                bonus.position = CGPoint(x: position.x + CGFloat(i*50), y: position.y)
                bonusPool.remove(at: 0)
                scene.addChild(bonus)
            }
        }
    }
    
    private func addEnemy(scene: PlayScene, position: CGPoint) {
        if (enemyPool.count != 0) {
            let enemy = enemyPool[0]
            enemy.position = position
            enemyPool.remove(at: 0)
            scene.addChild(enemy)
        }
    }
    
//    func createNextGroundBlock(position : CGPoint) {
//        if barsPool.count > 0 {
//            nextGroundBar = barsPool[0]
//            nextGroundBar.position = position
//            barsPool.remove(at: 0)
//        } else {
//            nextGroundBar = GroundBar(image: "ice", pos: position)
//        }
//        self.addChild(nextGroundBar)
//    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
