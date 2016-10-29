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
    
    init(scene: PlayScene, pos: CGPoint) {
        super.init()
        print("Initial Platform template frame.maxX: ")
        print(self.frame.maxX)
        self.position = pos
        for j in 0..<2 {
            let ground = GroundBar(image: "desert", pos: pos)
            ground.position = CGPoint(x: ground.position.x + ground.size.width / 2, y: ground.position.y)
            ground.position = CGPoint(x: ground.position.x + CGFloat(j) * ground.size.width, y: ground.position.y)
            //self.addChild(ground)
            scene.addChild(ground)
            grounds.append(ground)
            width += ground.size.width
            
            let step = Float.pi / 4
            for i in 0..<5 {
                let pos = ground.position
                let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusPosHeight + bonusPosMult * CGFloat(sin(step * Float(i)))))
                //self.addChild(bonus)
                scene.addChild(bonus)
                bonuses.append(bonus)
            }
            
            print("Platform template frame.maxX after platform creation: ")
            print(self.calculateAccumulatedFrame().minX)
            print(self.calculateAccumulatedFrame().maxX)
            //print(self.frame.maxX)
        }
        print("Platform template pos: ")
        print(self.position)
        print("Platform template width: ")
        print(width)
        //print(self.frame.maxX) it is equal to platform width
        print("Platform template platform 1 pos: ")
        print(grounds[0].position.x)
        print("Platform template platform 2 pos: ")
        print(grounds[1].position)
        
    }
    
    func random(left: Int, right: Int) -> Int {
        return Int(arc4random_uniform(UInt32(right))) + left
    }
    
//    func getBonusPlatform(pos: CGPoint) -> PlatformTemplate {
//        for j in 0..<2 {
//            let ground = GroundBar(image: "desert", pos: pos)
//            ground.position = CGPoint(x: ground.position.x + CGFloat(j)*ground.size.width, y: ground.position.y)
//            self.addChild(ground)
//            grounds.append(ground)
//            width += ground.size.width
//            
//            let step = Float.pi / 4
//            for i in 0..<5 {
//                let pos = ground.position
//                let bonus = Bonus(image: "fish", pos: CGPoint(x: pos.x + CGFloat(bonusPosMult * CGFloat(i)), y: pos.y + bonusPosHeight + bonusPosMult * CGFloat(sin(step * Float(i)))))
//                self.addChild(bonus)
//                bonuses.append(bonus)
//            }
//        }
//        return self
//    }
    
    func getPlatformSet(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
