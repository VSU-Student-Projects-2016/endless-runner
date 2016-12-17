//
//  GameScene.swift
//  Bouncing Ball
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let playButton = SKSpriteNode(imageNamed: "play")
    let muteButton = SKSpriteNode(imageNamed: "hero_jump")
    var muted = true
    var defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        if defaults.object(forKey: "muted") == nil {
            defaults.set(muted, forKey: "muted")
        } else {
            muted = defaults.bool(forKey: "muted")
        }
        
        if muted {
            muteButton.texture = SKTexture(imageNamed: "hero_fall")
        } else {
            muteButton.texture = SKTexture(imageNamed: "hero_jump")
        }
        
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.playButton)
        self.backgroundColor = UIColor.blue
        
        self.muteButton.position = CGPoint(x: self.frame.maxX - muteButton.size.width * 1.1, y: self.frame.maxY  - muteButton.size.height)
        self.addChild(self.muteButton)
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.playButton {
                let scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                skView?.presentScene(scene)
            }
            if self.atPoint(location) == self.muteButton {
                muted = !muted
                defaults.set(muted, forKey: "muted")
                if muted {
                    muteButton.texture = SKTexture(imageNamed: "hero_fall")
                } else {
                    muteButton.texture = SKTexture(imageNamed: "hero_jump")
                }
            }
        }
    }
    

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
