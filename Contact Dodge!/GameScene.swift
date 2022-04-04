//
//  GameScene.swift
//  Spike Jumper
//
//  Created by Kenny on 12/27/17.
//  Copyright © 2017 Kenny. All rights reserved.
//

import SpriteKit
import GameplayKit

var vBlock = SKSpriteNode()
var hBlock = SKSpriteNode()

var vSize = CGSize(width: 35, height: 1400)

var leftPlayer = SKSpriteNode()
var rightPlayer = SKSpriteNode()

var Spike1 = SKSpriteNode()
var Spike2 = SKSpriteNode()
var Spike3 = SKSpriteNode()
var Spike4 = SKSpriteNode()

var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

let spawnDelay = 1

var spikeSpeed = 2.5

var spike1SpawnRate = 0.5
var spike2SpawnRate = 0.685
var spike3SpawnRate = 0.823
var spike4SpawnRate = 0.487

var spikeSize = CGSize(width: 40, height: 40)

var isAlive = true

var touchLocation = CGPoint()

struct physicsCategory {
    static let leftPlayer : UInt32 = 0
    static let leftSpikes : UInt32 = 1
    static let rightPlayer : UInt32 = 2
    static let rightSpikes : UInt32 = 3
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.30, green: 0.20, blue: 0.95, alpha: 1.0)
        spawnVBlock()
        
        spawnSpike1()
        timerSpawnSpike1()

        spawnLeftPlayer()

        }
    
    
    func spawnVBlock() {
        vBlock.size = CGSize(width: 35, height: 1400)
        vBlock.color = UIColor.black
        vBlock.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        vBlock.physicsBody = SKPhysicsBody(rectangleOf: vSize)
        vBlock.physicsBody?.affectedByGravity = false
        
        self.addChild(vBlock)
        
        
    }
    
    func spawnSpike1() {
        let Spike12 = CGPoint(x: self.frame.midX - 37, y: -1000)
        let Spike11 = CGPoint(x: self.frame.midX - 358, y: -1000)
        let xPositions = [
            Spike11,
            Spike12
        ]
        let randomX = Int(arc4random_uniform(UInt32(xPositions.count)))
        
        Spike1 = SKSpriteNode()
        Spike1.color = .white
        Spike1.size = spikeSize
        Spike1.position = xPositions[randomX]
        
        moveSpike1Up()
        
        self.addChild(Spike1)
    }
    
    func moveSpike1Up() {
        let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed)
        let destroy = SKAction.removeFromParent()
        
        Spike1.run(SKAction.sequence([moveTo, destroy]))
        
    }
    
    func timerSpawnSpike1() {
        let wait = SKAction.wait(forDuration: spike1SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike1()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func spawnLeftPlayer() {
        leftPlayer = SKSpriteNode(imageNamed: "Bomberman")
        leftPlayer.size = CGSize(width: 90, height: 90)
        leftPlayer.position = CGPoint(x: self.frame.midX - 340, y: self.frame.midY + 300)
        
        self.addChild(leftPlayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            if isAlive == true {
                movePlayerOnTouch()
            }
        }
    }
    func movePlayerOnTouch() {
        leftPlayer.position.x = (touchLocation.x)
    }
    
    //cut
    
    func spawnSpike2() {
        let randomX = GKRandomDistribution(lowestValue: -40, highestValue: -40)
        let position = CGFloat(randomX.nextInt())
        Spike2 = SKSpriteNode(imageNamed: "SJ_SpikeLeft")
        Spike2.size = spikeSize
        Spike2.position = CGPoint(x: position, y: -1000)
        
        moveSpike2Up()
        
        self.addChild(Spike2)
    }
    func moveSpike2Up() {
        let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed)
        let destroy = SKAction.removeFromParent()
        
        Spike2.run(SKAction.sequence([moveTo, destroy]))
        
    }
    func timerSpawnSpike2() {
        let wait = SKAction.wait(forDuration: spike2SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike2()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func spawnSpike3() {
        let randomX = GKRandomDistribution(lowestValue: 40, highestValue: 40)
        let position = CGFloat(randomX.nextInt())
        Spike3 = SKSpriteNode(imageNamed: "SJ_SpikeRight")
        Spike3.size = spikeSize
        Spike3.position = CGPoint(x: position, y: -1000)
        
        moveSpike3Up()
        
        self.addChild(Spike3)
    }
    func moveSpike3Up() {
        let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed)
        let destroy = SKAction.removeFromParent()
        
        Spike3.run(SKAction.sequence([moveTo, destroy]))
        
    }
    func timerSpawnSpike3() {
        let wait = SKAction.wait(forDuration: spike3SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike3()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func spawnSpike4() {
        let randomX = GKRandomDistribution(lowestValue: 350, highestValue: 350)
        let position = CGFloat(randomX.nextInt())
        Spike4 = SKSpriteNode(imageNamed: "SJ_SpikeLeft")
        Spike4.size = spikeSize
        Spike4.position = CGPoint(x: position, y: -1000)
        
        moveSpike4Up()
        
        self.addChild(Spike4)
    }
    
    func moveSpike4Up() {
        let moveTo = SKAction.moveTo(y: 700, duration: spikeSpeed)
        let destroy = SKAction.removeFromParent()
        
        Spike4.run(SKAction.sequence([moveTo, destroy]))
        
    }
    
    func timerSpawnSpike4() {
        let wait = SKAction.wait(forDuration: spike4SpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnSpike4()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
