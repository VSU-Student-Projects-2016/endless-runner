//
//  PowerUp.swift
//  Bouncing Ball
//
//  Created by xcode on 12.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

//public protocol Updatable {
//    func update()
//}
public protocol PowerUp {
     func onAdd(to hero: Hero)
     func onContact(with enemy: Enemy)
     //func onEnergyStep()
     func update()
     //func shouldAffectEnergy()
    
     func removeFromHero()
    
    //func shouldAffectEnergy() -> Bool
}

public extension PowerUp {
    public func shouldAffectEnergy() -> Bool {
        return false
    }
}
