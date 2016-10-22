//
//  ColliderType.swift
//  Bouncing Ball
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation

public struct ColliderType {
    public static let None: UInt32 = 0
    public static let Hero: UInt32 = 0b1
    public static let Ground: UInt32 = 0b10
    public static let Enemy: UInt32 = 0b100
    public static let Bonus: UInt32 = 0b1000
    public static let GarbageCollector: UInt32 = 0b10000
}
