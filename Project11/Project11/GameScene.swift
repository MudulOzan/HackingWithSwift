//
//  GameScene.swift
//  Pachinko
//
//  Created by Ozan Mudul on 2.01.2023.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var fontName = "Chalkduster"
	var ballColors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
	var scoreLabel: SKLabelNode!
	var isGameOver = false
	
	var gameOverLabel: SKLabelNode!
	var startGameLabel: SKLabelNode!
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var editLabel: SKLabelNode!
	
	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}
	
	var ballsLabel: SKLabelNode!
	
	var ballsInScene = 0 {
		didSet {
			if ballsInScene <= 0 && balls <= 0 {
				isGameOver = true
				gameOver()
			}
		}
	}
	var balls = 5 {
		didSet {
			ballsLabel.text = "Balls: \(balls)"
		}
		
	}
	
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPointMake(512, 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		scoreLabel = SKLabelNode(fontNamed: fontName)
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPointMake(980, 700)
		addChild(scoreLabel)
		
		editLabel = SKLabelNode(fontNamed: fontName)
		editLabel.text = "Edit"
		editLabel.position = CGPointMake(80, 700)
		addChild(editLabel)
		
		ballsLabel = SKLabelNode(fontNamed: fontName)
		ballsLabel.text = "Balls: 5"
		ballsLabel.horizontalAlignmentMode = .right
		ballsLabel.position = CGPointMake(980, 655)
		addChild(ballsLabel)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
		
		makeSlot(at: CGPointMake(128, 0), isGood: true)
		makeSlot(at: CGPointMake(384, 0), isGood: false)
		makeSlot(at: CGPointMake(640, 0), isGood: true)
		makeSlot(at: CGPointMake(896, 0), isGood: false)
		
		makeBouncer(at: CGPointMake(0, 0))
		makeBouncer(at: CGPointMake(256, 0))
		makeBouncer(at: CGPointMake(512, 0))
		makeBouncer(at: CGPointMake(768, 0))
		makeBouncer(at: CGPointMake(1024, 0))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let objects = nodes(at: location)
		
		if objects.contains(editLabel) {
			editingMode.toggle()
		} else {
			if editingMode {
				let size = CGSize(width: Int.random(in: 16...128), height: 16)
				let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
				box.zRotation = CGFloat.random(in: 0...3)
				box.position = location
				box.name = "box"
				
				box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
				box.physicsBody?.isDynamic = false
				addChild(box)
			} else {
				if balls > 0 {
					let ball = SKSpriteNode(imageNamed: "ball\(ballColors.randomElement()!)")
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
					ball.physicsBody?.restitution = 0.4
					ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
					ball.position = CGPoint(x: location.x, y: 768)
					ball.name = "ball"
					addChild(ball)
					balls -= 1
					ballsInScene += 1
				}
				if isGameOver {
					if objects.contains(startGameLabel) {
						for child in self.children {
							print(child)
							if child.name == "box" || child.name == "gameOver" {
								child.removeFromParent()
							}
						}
						score = 0
						balls = 5
						isGameOver = false
					}
				}
			}
		}
	}
	
	func gameOver() {
		gameOverLabel = SKLabelNode(fontNamed: fontName)
		gameOverLabel.text = "Game Over"
		gameOverLabel.fontColor = .red
		gameOverLabel.position = CGPointMake(512, 400)
		gameOverLabel.name = "gameOver"
		addChild(gameOverLabel)
		
		let startGamePos = CGPointMake(512, 350)
		startGameLabel = SKLabelNode(fontNamed: fontName)
		startGameLabel.text = "Start New Game"
		startGameLabel.position = startGamePos
		startGameLabel.name = "gameOver"
		addChild(startGameLabel)
	}
	
	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
		bouncer.physicsBody?.isDynamic = false
		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		var sloteBase: SKSpriteNode
		var slotGlow: SKSpriteNode
		
		if isGood {
			sloteBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			sloteBase.name = "good"
		} else {
			sloteBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			sloteBase.name = "bad"
		}
		
		sloteBase.position = position
		slotGlow.position = position
		
		sloteBase.physicsBody = SKPhysicsBody(rectangleOf: sloteBase.size)
		sloteBase.physicsBody?.isDynamic = false
		
		addChild(sloteBase)
		addChild(slotGlow)
		
		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)
	}
	
	func collision(betwwen ball: SKNode, object: SKNode) {
		if object.name == "good" {
			destroy(ball: ball)
			score += 1
			balls += 1
			ballsInScene -= 1
		} else if object.name == "bad"{
			destroy(ball: ball)
			score -= 1
			ballsInScene -= 1
		} else if object.name == "box" {
			destroy(box: object)
		}
	}
	
	func destroy(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = ball.position
			addChild(fireParticles)
		}
		
		ball.removeFromParent()
	}
	
	func destroy(box: SKNode) {
		if let popParticles = SKEmitterNode(fileNamed: "PopParticles") {
			popParticles.position = box.position
			addChild(popParticles)
		}
		
		box.removeFromParent()
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if nodeA.name == "ball" {
			collision(betwwen: nodeA, object: nodeB)
		} else if nodeB.name == "ball" {
			collision(betwwen: nodeB, object: nodeA)
		}
	}
}

