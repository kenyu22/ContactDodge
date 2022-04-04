//
//  TitleScene.swift
//  Contact Dodge!
//
//  Created by Kenny on 12/28/17.
//  Copyright © 2017 Kenny. All rights reserved.
//
import Foundation
import SpriteKit
import AVFoundation
import GameplayKit

var btnPlay : UIButton!
var gameTitle : UILabel!
var gameTitle2 : UILabel!
var background = SKSpriteNode()
var starSize = CGSize()
var playButton = SKSpriteNode()
var star = SKSpriteNode()
var playTitle = SKLabelNode()
var rocket = SKSpriteNode()

var audioPlayer: AVAudioPlayer!

class TitleScene : SKScene {
    
    
    override func didMove(to view: SKView) {
        createFireAnimation()
        //createMusic()
        spawnRocket()
        spawnBackground()
        timerStarSpawn()
        setupText()
    }
   /* func createMusic() {
        let path = Bundle.main.path(forResource: "Fez", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            var audioSession = AVAudioSession.sharedInstance()
                do {
           try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                } catch {
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
 */
    func createFireAnimation() {
        if let particles = SKEmitterNode(fileNamed: "MyParticle.sks") {
            particles.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 270)
            particles.zRotation = 3.141592
            self.addChild(particles)
        }
    }
    func spawnBackground() {
        background = SKSpriteNode(imageNamed: "bam")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -1
        background.size = CGSize(width: 1920, height: 1500)
        
        self.addChild(background)
    }
    func setupText() {
        
        playTitle = SKLabelNode()
        playTitle.fontName = "Futura"
        playTitle.color = .white
        playTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 400)
        playTitle.fontSize = 70
        playTitle.text = "PLAY"
        self.addChild(playTitle)
        
        playButton = SKSpriteNode(imageNamed: "wow2")
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 500)
        playButton.size = CGSize(width: 200, height: 200)
        
        self.addChild(playButton)
        
        
        gameTitle = UILabel(frame: CGRect(x: -10, y: 10, width: (view?.frame.width)!, height: 300))
        gameTitle.textColor = offWhiteColor
        gameTitle.font = UIFont(name: "Futura", size: 60)
        gameTitle.textAlignment = NSTextAlignment.center
        gameTitle.text = "CONTACT"
        
        gameTitle2 = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY + 70, width: (view?.frame.width)!, height: 300))
        gameTitle2.textColor = offWhiteColor
        gameTitle2.font = UIFont(name: "Futura", size: 60)
        gameTitle2.textAlignment = NSTextAlignment.center
        gameTitle2.text = "DODGE"
        
        self.view?.addSubview(gameTitle)
        self.view?.addSubview(gameTitle2)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                let sceneGame = GameScene(fileNamed: "GameScene")
                sceneGame?.scaleMode = .aspectFill
                self.view?.presentScene(sceneGame!, transition: SKTransition.fade(with: .black, duration: 0.2))
                
                playTitle.isHidden = true
                playButton.isHidden = true
                
                gameTitle.removeFromSuperview()
                gameTitle2.removeFromSuperview()
              //  audioPlayer.stop()
            
            }
        }
    }
    
    func timerStarSpawn() {
        let wait = SKAction.wait(forDuration: 0.2)
        let spawn = SKAction.run {
            self.spawnStar()
        }
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        if isAlive == true {
            self.spawnStar()
        }
    }
    func starsMove() {
        let moveTo = SKAction.moveTo(y: -900, duration: 0.9)
        let destroy = SKAction.removeFromParent()
        star.run(SKAction.sequence([moveTo, destroy]))
    }
    func spawnStar() {
        let randomSize = Int(arc4random_uniform(50) + 2)
        let randomX = GKRandomDistribution(lowestValue: -320, highestValue: 320)
        let position = CGFloat(randomX.nextInt())
        starSize = CGSize(width: randomSize, height: randomSize)
        star = SKSpriteNode(color: offWhiteColor, size: starSize)
        star.size = starSize
        star.position = CGPoint(x: position, y: 1000)
        
        starsMove()
        
        self.addChild(star)
    }
    func spawnRocket() {
        rocket = SKSpriteNode(imageNamed: "124570")
        rocket.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 110)
        rocket.size = CGSize(width: 350, height: 350)
        
        self.addChild(rocket)
    }
    
}
