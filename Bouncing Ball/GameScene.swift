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
    let muteButton = SKSpriteNode(imageNamed: "snd_active")
    var backgroundImage = SKSpriteNode(imageNamed: "MainMenuBackground")
    //var muteButton : UIButton!
    //var screen : UIView?
    
    var muted = false
    var defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        if defaults.object(forKey: "muted") == nil {
            defaults.set(muted, forKey: "muted")
        } else {
            muted = defaults.bool(forKey: "muted")
        }
        
        if muted {
            muteButton.texture = SKTexture(imageNamed: "snd_muted")
        } else {
            muteButton.texture = SKTexture(imageNamed: "snd_active")
        }
        
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.zPosition = -170
        self.addChild(backgroundImage)
        /*screen = UIView()
        screen!.sizeThatFits(self.frame.size)
        screen!.frame.origin = CGPoint(x: self.frame.minX, y: self.frame.minY)
        screen!.frame.size = self.frame.size
        self.view?.addSubview(screen!)*/
        
        playButton = UIButton(frame: CGRect(x: self.frame.midX + frame.size.width / 2.7, y: self.frame.midY + frame.size.height / 2.6, width: 200.0, height: 100.0))
        playButton.setBackgroundImage(UIImage(named: "Button"), for: UIControlState.normal)
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.brown, for: .normal)
        playButton.addTarget(self, action: #selector(self.playButtonPressed(_:)), for: .touchUpInside)
        playButton.titleLabel!.font = UIFont(name: "PressStart2P", size: 20)
        self.view?.addSubview(playButton)
        
        self.backgroundColor = UIColor.gray
        
        /*muteButton = UIButton(frame: CGRect(x:  self.frame.maxX - #imageLiteral(resourceName: "snd_active").size.width * 1.5, y: self.frame.maxY  - #imageLiteral(resourceName: "snd_active").size.height * 1.5, width: #imageLiteral(resourceName: "snd_active").size.width, height: #imageLiteral(resourceName: "snd_active").size.height))
        if defaults.bool(forKey: "muted") {
            muteButton.setImage(#imageLiteral(resourceName: "snd_muted"), for: .normal)
        } else {
            muteButton.setImage(#imageLiteral(resourceName: "snd_active"), for: .normal)
        }
        muteButton.addTarget(self, action: #selector(self.muteButtonPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(muteButton)*/
        
        
        //screen!.addSubview(playButton)
        //screen!.addSubview(muteButton)
        

        
        
        
        
        self.muteButton.position = CGPoint(x: self.frame.maxX - muteButton.size.width * 1.1, y: self.frame.minY  + muteButton.size.height * 1.1)
        self.addChild(self.muteButton)
    }
  
    func playButtonPressed(_ sender: UIButton!) {
        let scene = PlayScene(size: self.size)
        let skView = self.view as SKView!
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.size = (skView?.bounds.size)!
        playButton.removeFromSuperview()
        //muteButton.removeFromSuperview()
        skView?.presentScene(scene)
    }
    
    /*func muteButtonPressed(_ sender: UIButton!){
        var muted = defaults.bool(forKey: "muted")
        muted = !muted
        defaults.set(muted, forKey: "muted")
        if muted {
            muteButton.setImage(#imageLiteral(resourceName: "snd_muted"), for: .normal)
        } else {
            muteButton.setImage(#imageLiteral(resourceName: "snd_active"), for: .normal)
        }
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.muteButton {
                muted = !muted
                defaults.set(muted, forKey: "muted")
                if muted {
                    muteButton.texture = SKTexture(imageNamed: "snd_muted")
                } else {
                    muteButton.texture = SKTexture(imageNamed: "snd_active")
                }
            }
        }
    }
    

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
