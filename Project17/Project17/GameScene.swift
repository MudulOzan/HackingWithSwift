//
//  GameScene.swift
//  Project17
//
//  Created by Ozan Mudul on 31.01.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var starfield: SKEmitterNode!
	var player: SKSpriteNode!
	
	var scoreLabel: SKLabelNode!
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var possibleEnemies = ["ball", "hammer", "tv"]
	var isGameOver = false
	var gameTimer: Timer?
	var grabbed = false
	var totalEnemies = 0
	var timeInterval = 1.0
	
	func enemyTimer() {
		gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
	}

    override func didMove(to view: SKView) {
		enemyTimer()
		
		backgroundColor = .black
		
		starfield = SKEmitterNode(fileNamed: "starfield")
		starfield.position = CGPointMake(1024, 384)
		starfield.advanceSimulationTime(10)
		addChild(starfield)
		starfield.zPosition = -1
		
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPointMake(100, 384)
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		player.physicsBody?.contactTestBitMask = 1
		player.name = "player"
		addChild(player)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.position = CGPointMake(16, 16)
		scoreLabel.horizontalAlignmentMode = .left
		addChild(scoreLabel)

		score = 0
		
		physicsWorld.gravity = CGVectorMake(0, 0)
		physicsWorld.contactDelegate = self
    }
	
	@objc func createEnemy() {
		guard let enemy = possibleEnemies.randomElement() else { return }
		
		let sprite = SKSpriteNode(imageNamed: enemy)
		sprite.position = CGPointMake(1200, CGFloat.random(in: 50...736))
		addChild(sprite)
		totalEnemies += 1
		if score.isMultiple(of: 20) {
			timeInterval -= 0.1
			gameTimer?.invalidate()
			enemyTimer()
		}
		
		sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
		sprite.physicsBody?.categoryBitMask = 1
		sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
		sprite.physicsBody?.angularVelocity = 5
		sprite.physicsBody?.linearDamping = 0
		sprite.physicsBody?.angularDamping = 0
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.location(in: self)
		let touchedNode = atPoint(location)

		if location.y < 100 {
			location.y = 100
		} else if location.y > 668 {
			location.y = 668
		}
		
		if let name = touchedNode.name {
			if name == "player" {
				grabbed = true
			}
		}
		
		if grabbed == true {
			player.position = location
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		grabbed = false
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position
		addChild(explosion)
		
		player.removeFromParent()
		
		isGameOver = true
		gameTimer?.invalidate()
	}
      
    override func update(_ currentTime: TimeInterval) {
		for node in children {
			if node.position.x < -300 {
				node.removeFromParent()
			}
		}
		
		if !isGameOver {
			score += 1
		}
    }
}
