//
//  GameScene.swift
//  ShootingGame
//
//  Created by Ozan Mudul on 2.02.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
	var waterFg: SKSpriteNode!
	var waterBg: SKSpriteNode!
	var targetSpeed = 4.0
	var gameTimer: Timer?
	var timeInterval = 1.0
	var scoreLabel: SKLabelNode!
	var score = 0 {
		didSet{
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var bulletsSprite: SKSpriteNode!
	var bulletTextures = [
		SKTexture(imageNamed: "shots0"),
		SKTexture(imageNamed: "shots1"),
		SKTexture(imageNamed: "shots2"),
		SKTexture(imageNamed: "shots3"),
	]
	
	var bullets = 3 {
		didSet {
			bulletsSprite.texture = bulletTextures[bullets]
		}
	}
	
	var level = 0
	
	override func didMove(to view: SKView) {
		createInterface()
		createBackground()
		createWater()
		targetTimer()
	}
	
	func createInterface() {
		bulletsSprite = SKSpriteNode(imageNamed: "shots3")
		bulletsSprite.position = CGPoint(x: 70, y: 30)
		bulletsSprite.zPosition = 500
		addChild(bulletsSprite)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: \(score)"
		scoreLabel.position = CGPointMake(720, 10)
		scoreLabel.zPosition = 9999
		addChild(scoreLabel)
	}
	
	func createBackground() {
		let background = SKSpriteNode(imageNamed: "wood-background")
		background.zPosition = 1
		background.position = CGPointMake(400, 300)
		addChild(background)
		
		let curtains = SKSpriteNode(imageNamed: "curtains")
		curtains.zPosition = 400
		curtains.position = CGPointMake(400, 300)
		addChild(curtains)
		
		let grassTrees = SKSpriteNode(imageNamed: "grass-trees")
		grassTrees.zPosition = 100
		grassTrees.position = CGPointMake(400, 300)
		addChild(grassTrees)
	}
	
	func createWater() {
		func animate(_ node: SKNode, distance: CGFloat, duration: TimeInterval) {
			let movementUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
			let movementDown = movementUp.reversed()
			let sequence = SKAction.sequence([movementUp, movementDown])
			let repeatForever = SKAction.repeatForever(sequence)
			node.run(repeatForever)
		}
		
		waterFg = SKSpriteNode(imageNamed: "water-fg")
		waterFg.zPosition = 190
		waterFg.position = CGPointMake(400, 210)
		addChild(waterFg)
		
		waterBg = SKSpriteNode(imageNamed: "water-bg")
		waterBg.zPosition = 300
		waterBg.position = CGPointMake(400, 110)
		addChild(waterBg)
		
		animate(waterFg, distance: 8, duration: 1.3)
		animate(waterBg, distance: 12, duration: 1)
	}
	
	func targetTimer() {
		gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
	}
    
	@objc func createTarget() {
		let target = Target()
		target.create()
		
		var x = 0
		var moveX = 900
		var minusY = 0
		let row = Int.random(in: 1...3)

		if(row == 3) {
			target.setScale(0.7)
			minusY = -20
		}
		
		if(row == 2) {
			x = 800
			moveX = -900
			target.setScale(0.85)
			target.xScale = -target.xScale
			minusY = -10
		}
		
		target.zPosition = CGFloat(300 / row + 50)
		target.position = CGPointMake(CGFloat(x), CGFloat(row * 100 + minusY))
		
		addChild(target)
		speedUp()
		
		target.run(SKAction.moveBy(x: CGFloat(moveX), y: 0, duration: targetSpeed))
	}
	
	func speedUp() {
		level += 1
		if level % 20 == 0 {
			timeInterval *= 0.95
			targetSpeed *= 0.95
		
		} else if level == 60{
			gameOver()
		}
	}
	
	func gameOver() {
		gameTimer?.invalidate()
		let gameOverImage = SKSpriteNode(imageNamed: "game-over")
		gameOverImage.zPosition = 9999
		gameOverImage.position = CGPointMake(400, 300)
		addChild(gameOverImage)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first
		let touchLocation = touch!.location(in: self)
		let hitNode = atPoint(touchLocation)

		if bullets == 0 {
			run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
			bullets = 3
			return
		}
		shoot()
			
		let hitNodes = nodes(at: touchLocation).filter { $0.name == "target" }
			
		guard let hitNode = hitNodes.first else {
			score -= 1
			return }
		guard let parentNode = hitNode.parent as? Target else {
			score -= 1
			return
		}
		parentNode.hit()
		score += 1
	}
	

	
	func shoot() {
		if bullets > 0 {
			bullets -= 1
			run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
		} else {
			run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
		}
	}
}
