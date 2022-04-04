//
//  GameScene.swift
//  Contact Dodge!
//
//  Created by Kenny on 12/28/17.
//  Copyright © 2017 Kenny. All rights reserved.
//

import SpriteKit
import GameplayKit

var enemy = SKSpriteNode()
var enemySize = CGSize(width: 40, height: 40)
var player = SKSpriteNode()
var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

var isAlive = true
var enemySpeed = 1.7
var enemySpawnRate = 0.2

var scoreBlock = SKSpriteNode()

var scoreLabel = SKLabelNode()
var highScoreLabel = SKLabelNode()
var mainLabel = SKLabelNode()

var playerSize = CGSize(width: 110, height: 110)

var score = 0
var highScore = UserDefaults().integer(forKey: "High Score")

var touchLocation = CGPoint()
var background2 = SKSpriteNode()

struct physicsCategory {
    static let player : UInt32 = 0
    static let enemy : UInt32 = 1
    static let scoreBlock : UInt32 = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    override func didMove(to view: SKView) {
        
      //  spawnBackground()
        self.backgroundColor = .black
        physicsWorld.contactDelegate = self
        resetGameVariablesOnStart()
        spawnScoreBlock()
        spawnScoreLabel()
        spawnMainLabel()
        spawnPlayer()
        spawnEnemy()
        timerSpawnEnemies()
        }
    func spawnBackground() {
        background2 = SKSpriteNode(imageNamed: "wow")
        background2.size = CGSize(width: 1920, height: 1500)
        background2.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background2.zPosition = -5
        self.addChild(background2)
    }
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed: "124570")
        player.size = playerSize
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 400)
        player.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = physicsCategory.player
        player.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player.physicsBody?.isDynamic = true
        player.name = "playerName"
        
        self.addChild(player)
    }
    func spawnEnemy() {
        let randomX = GKRandomDistribution(lowestValue: -320, highestValue: 320)
        let position = CGFloat(randomX.nextInt())
        
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        
        

        enemy = SKSpriteNode()
        enemy.color = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        enemy.size = enemySize
        enemy.position = CGPoint(x: position, y: 1000)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = physicsCategory.player | physicsCategory.scoreBlock
        enemy.physicsBody?.isDynamic = true
        enemy.name = "enemyName"
        
        moveEnemyToFloor()
        
        self.addChild(enemy)
    }
    func moveEnemyToFloor() {
        let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        
        enemy.run(SKAction.sequence([moveTo, destroy]))
        
        if score > 1000 {
            let enemySpeed = 1.5
            let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()
            
            enemy.run(SKAction.sequence([moveTo, destroy]))
            
        } else if score > 2000 {
            let enemySpeed = 1.3
            let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()
            
            enemy.run(SKAction.sequence([moveTo, destroy]))
        } else if score > 3000 {
            let enemySpeed = 1.1
            let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()
            
            enemy.run(SKAction.sequence([moveTo, destroy]))
        } else if score > 4000 {
            let enemySpeed = 0.9
            let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()
            
            enemy.run(SKAction.sequence([moveTo, destroy]))
        } else if score > 5000 {
            let enemySpeed = 0.6
            let moveTo = SKAction.moveTo(y: -650, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()
            
            enemy.run(SKAction.sequence([moveTo, destroy]))
        }
        
    }
    func timerSpawnEnemies() {
        let wait = SKAction.wait(forDuration: enemySpawnRate)
        let spawn = SKAction.run {
            if isAlive == true {
                self.spawnEnemy()
                
            }
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.player) || (firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.enemy)) {
            playerEnemyCollision(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
            
        }
        if ((firstBody.categoryBitMask == physicsCategory.scoreBlock) && (secondBody.categoryBitMask == physicsCategory.enemy) || (firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.scoreBlock)) {
           scoreAddition(contactA: firstBody.node as! SKSpriteNode, contactB: secondBody.node as! SKSpriteNode)
        }
    }
    func scoreAddition(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "scoreName" && contactB.name == "enemyName" {
            score = score + 25
            updateScore()
        }
        if contactB.name == "scoreName" && contactA.name == "enemyName" {
            score = score + 25
            updateScore()
        }
    }

    func playerEnemyCollision(contactA: SKSpriteNode, contactB: SKSpriteNode) {
        if contactA.name == "enemyName" && contactB.name == "playerName" {
            isAlive = false
            gameOverLogic()
        }
        
        if contactB.name == "enemyName" && contactA.name == "playerName" {
            isAlive = false
            gameOverLogic()
        }
    }
    func gameOverLogic() {
        mainLabel.fontSize = 90
        mainLabel.text = "Game Over."
        
        resetTheGame()
    }
    func resetTheGame() {
        let wait = SKAction.wait(forDuration: 1.0)
        let theTitleScene = TitleScene(fileNamed: "TitleScene")
        theTitleScene?.scaleMode = .aspectFill
        let theTransition = SKTransition.crossFade(withDuration: 0.4)
        
        let changeScene = SKAction.run {
            self.scene?.view?.presentScene(theTitleScene!, transition: theTransition)
            
        }
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
        
    }
    func resetGameVariablesOnStart() {
        isAlive = true
        
        score = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            if isAlive == true{
                mainLabel.isHidden = true
            } else {
                mainLabel.isHidden = false
            }
            
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
        player.position.x = (touchLocation.x)
    }
    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel.fontSize = 100
        mainLabel.fontColor = offWhiteColor
        mainLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        
        mainLabel.text = "Start"
        self.addChild(mainLabel)
        
    }
    func spawnScoreBlock() {
        scoreBlock = SKSpriteNode()
        scoreBlock.size = CGSize(width: 700, height: 3)
        scoreBlock.color = .black
        scoreBlock.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 630)
        scoreBlock.physicsBody = SKPhysicsBody(rectangleOf: scoreBlock.size)
        scoreBlock.physicsBody?.affectedByGravity = false
        scoreBlock.physicsBody?.allowsRotation = false
        scoreBlock.physicsBody?.categoryBitMask = physicsCategory.scoreBlock
        scoreBlock.physicsBody?.contactTestBitMask = physicsCategory.enemy
        scoreBlock.physicsBody?.isDynamic = true
        scoreBlock.name = "scoreName"
        
        self.addChild(scoreBlock)
    }
    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 420)
        scoreLabel.text = "Score: \(score)"
        self.addChild(scoreLabel)
    }
    func spawnHighScoreLabel() {
        highScoreLabel = SKLabelNode(fontNamed: "Futura")
        highScoreLabel.fontSize = 70
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        highScoreLabel.text = "High score: \(highScore)"
        self.addChild(highScoreLabel)
    }
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    func movePlayerOffScreen() {
        player.position.x = -500
    }
    func saveHighScore() {
       
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isAlive == false {
            movePlayerOffScreen()
        }
        if (score > UserDefaults().integer(forKey: "High Score")) {
            saveHighScore()
        }
    }
}
