//
//  GameScene.swift
//  Platformer
//
//  Created by Corbin Robinson, Bo Stevens, Parker Rosenberg, Christopher Newton on 4/12/20.
//  Copyright © 2020 user919218. All rights reserved.
//

import SpriteKit
import GameplayKit

//Movement code
    var currentCamera = SKCameraNode()
    var player = SKSpriteNode()
    var playerSize = CGSize(width: 100, height: 100)
    var touchLocation = CGPoint()
    var right = false
    var left = false
    var up = false

    var Spikes = SKSpriteNode()
    var boulder = SKSpriteNode()
    var dead = SKSpriteNode()
    var rippered = false
    var win = SKSpriteNode()
    var wonnered = false


//Animation code
    //Animation count is used to cycle through frames of player animation
    var animationCount = 0;

    var playerIdleAtlas = SKTextureAtlas();
    var playerIdleArr: [SKTexture] = [];

    var playerRunAtlas = SKTextureAtlas();
    var playerRunArr: [SKTexture] = [];



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?

    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            if touchLocation.x > player.position.x{
                player.xScale = abs(player.xScale);
                right = true
            }else{
                player.xScale = abs(player.xScale) * -1;
                left = true
            }
            
            if rippered {
                dead.zPosition = -1
                rippered = false
            }
            if wonnered {
                win.zPosition = -1
                wonnered = false
            }
            
            //Calls function to animate player running
            animatePlayer(playerRunArr, "RunningAnimation")
            
            if touchLocation.y > player.position.y+50{
                up = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        right = false
        left = false
        up = false
        
        //returns player to idle animation
        animatePlayer(playerIdleArr, "IdleAnimation")
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node == player && contact.bodyB.node == Spikes || contact.bodyA.node == Spikes && contact.bodyB.node == player){
            dead = ((self.childNode(withName: "dead") as? SKSpriteNode)!)
            dead.zPosition = 1
            rippered = true
            right = false
            left = false
            up = false
            player.removeFromParent()
            spawnPlayer()
        }
    }
    
    override func didMove(to view: SKView) {
        spawnPlayer()
        self.camera = currentCamera
        
        Spikes = ((self.childNode(withName: "//Spikes") as? SKSpriteNode)!)
        dead = ((self.childNode(withName: "dead") as? SKSpriteNode)!)
        win = ((self.childNode(withName: "win") as? SKSpriteNode)!)
        boulder = ((self.childNode(withName: "Boulder") as? SKSpriteNode)!)
        //sets up physics to handle collisions
        physicsWorld.contactDelegate = self;
        
        currentCamera.xScale = 0.75
        currentCamera.yScale = 0.75
    }
    
    
    func spawnPlayer(){

        //Creates arrays of images that are used for animation
        createTextureAtlasses()
        
        
        //applies first texture to our player
        player = SKSpriteNode(texture: playerIdleArr[0])
        player.size = playerSize
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerSize.width/2.3, height: playerSize.height))
        player.physicsBody?.allowsRotation = false;
        player.physicsBody?.mass = 0.5;
        player.physicsBody?.contactTestBitMask = 0x00000001
        addChild(player)
        
        //calls method that animates player by cycling through the arrray of images
        animatePlayer(playerIdleArr, "IdleAnimation")
        
    }

    
    func createTextureAtlasses(){
        //Turns our Atlas folder into an array of textures for animation
        
        //Creates atlas for idle animation with flame
        playerIdleAtlas = SKTextureAtlas(named: "idle.atlas")
        for i in 1...playerIdleAtlas.textureNames.count{
            playerIdleArr.append(playerIdleAtlas.textureNamed("Sprite-000\(i).png"))
        }
        
        //creates run animation without flame
        playerRunAtlas = SKTextureAtlas(named: "No_flame.atlas")
        for i in 1...playerRunAtlas.textureNames.count{
            playerRunArr.append(playerRunAtlas.textureNamed("threnAnim-0\(i).png"))
        }
        
    }

    func animatePlayer(_ arr: [SKTexture], _ name: String){
        //Method takes an array of textures and the name of our animation and runs it on our character
        player.run(SKAction.repeatForever(SKAction.animate(with: arr, timePerFrame: 0.1, resize: false, restore: true)), withKey: name)
    }
    
    //Checks to see if camera is about to go out of bounds and stops it from going further
    func checkCameraBounds(){
        if(player.position.y < 59){
            currentCamera.position.y = 59
        }
        if(player.position.y > 200){
            currentCamera.position.y = 200
        }
        if(player.position.x > 150){
            currentCamera.position.x = 150
        }
        if(player.position.x < -380){
            currentCamera.position.x = -380
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if up{
            player.position.y += 10
        }
        if right {
            player.position.x += 4
        }else if left{
            player.position.x -= 4
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        //Resets player's position if they drop below the screen
        if (player.position.y < -1500) {
            dead = ((self.childNode(withName: "dead") as? SKSpriteNode)!)
            dead.zPosition = 1
            rippered = true
            right = false
            left = false
            up = false
            player.removeFromParent()
            spawnPlayer()
        }
        
        //checking win condition
        if player.position.x >= 594{
            win = ((self.childNode(withName: "win") as? SKSpriteNode)!)
            win.zPosition = 1
            wonnered = true
            right = false
            left = false
            up = false
            boulder.position.x = 207.874
            boulder.position.y = 320
            player.removeFromParent()
            spawnPlayer()
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        currentCamera.position = player.position
        checkCameraBounds()

        self.lastUpdateTime = currentTime
    }
    
    
}
