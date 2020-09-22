//
//  WonScene.swift
//  Platformer
//
//  Created by Corbin Robinson on 4/16/20.
//  Copyright © 2020 user919218. All rights reserved.
//

import Foundation
import SpriteKit

class WonScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touch.view?.isUserInteractionEnabled = true
            if touch == touches.first {
                print("Going to game")
                let gameScene = SKScene(fileNamed: "GameScene")
                self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
       
    }
}
