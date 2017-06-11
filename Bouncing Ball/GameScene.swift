//
//  GameScene.swift
//  Bouncing Ball
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    
    var playButton : UIButton!
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
        
        playButton = UIButton(frame: CGRect(x: self.frame.midX + frame.size.width / 3, y: self.frame.midY + frame.size.height / 3, width: 200.0, height: 100.0))
        playButton.setBackgroundImage(UIImage(named: "Button"), for: UIControlState.normal)
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.brown, for: .normal)
        playButton.addTarget(self, action: #selector(self.playButtonPressed(_:)), for: .touchUpInside)
        playButton.titleLabel!.font = UIFont(name: "PressStart2P", size: 20)
        self.view?.addSubview(playButton)
        self.backgroundColor = UIColor.gray
        
        self.muteButton.position = CGPoint(x: self.frame.maxX - muteButton.size.width * 1.1, y: self.frame.minY  + muteButton.size.height)
        self.addChild(self.muteButton)
    }
  
    func playButtonPressed(_ sender: UIButton!) {
        let scene = PlayScene(size: self.size)
        let skView = self.view as SKView!
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.size = (skView?.bounds.size)!
        playButton.removeFromSuperview()
        skView?.presentScene(scene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
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
