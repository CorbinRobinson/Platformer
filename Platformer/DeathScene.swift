//
//  DeathScene.swift
//  Platformer
//
//  Created by Corbin Robinson on 4/16/20.
//  Copyright © 2020 user919218. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DeathScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        print("Arrived at death scene")
        let display = SKSpriteNode(imageNamed: "youDied")
        display.size = CGSize(width: 150, height: 200)
        self.addChild(display)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch registered")
        let gameScene = SKScene(fileNamed: "GameScene")
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
    }
}
