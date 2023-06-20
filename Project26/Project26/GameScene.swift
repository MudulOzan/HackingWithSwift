//
//  GameScene.swift
//  Project26
//
//  Created by Ozan Mudul on 19.03.2023.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
	case player = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
	case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	var player: SKSpriteNode!
	var lastTouchPosition:  CGPoint?
	var motionManager: CMMotionManager!
	var scoreLabel: SKLabelNode!
	var isGameOver = false
	var level = 1
	var maxLevel = 2
	var portals = [SKSpriteNode]()
	var canTeleport = true
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	override func didMove(to view: SKView) {
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
		
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		background.name = "background"
		addChild(background)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.zPosition = 2
		addChild(scoreLabel)
		
		loadLevel()
		createPlayer()
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if nodeA == player {
			playerCollided(with: nodeB)
		} else if nodeB == player {
			playerCollided(with: nodeA)
		}
	}
    
	func playerCollided(with node: SKNode) {
		if node.name == "vortex" {
			player.physicsBody?.isDynamic = false
			isGameOver = true
			score -= 1
			
			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(to: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])
			
			player.run(sequence) { [weak self] in
				self?.createPlayer()
				self?.isGameOver = false
			}
		} else if node.name == "star" {
			node.removeFromParent()
			score += 1
		} else if node.name == "finish" {
			if level < maxLevel {
				level += 1
				player.physicsBody?.isDynamic = false

				let move = SKAction.move(to: node.position, duration: 0.25)
				let scale = SKAction.scale(to: 0.0001, duration: 0.25)
				let remove = SKAction.removeFromParent()
				let sequence = SKAction.sequence([move, scale, remove])
				
				player.run(sequence) { [weak self] in
					for child in self!.children {

						if child.name != "background" {
							child.removeFromParent()
						}
					}
					self?.loadLevel()
					self?.createPlayer()
				}
			}
		} else if node.name == "portal" {
			guard canTeleport == true else { return }
			if let portalTo = portals.first(where: {$0.position != node.position}) {
				canTeleport = false
				Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { [weak self] _ in
					self?.canTeleport = true
				}
				player.physicsBody?.isDynamic = false

				let move = SKAction.move(to: node.position, duration: 0.25)
				let scaleDown = SKAction.scale(to: 0.0001, duration: 0.25)
				let remove = SKAction.removeFromParent()
				let sequence = SKAction.sequence([move, scaleDown, remove])

				lastTouchPosition = nil

				player.run(sequence) { [weak self] in
					self?.createPlayer(position: portalTo.position)
				}
			}
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		guard isGameOver == false else { return }
		
		#if targetEnvironment(simulator)
			if let currentTouch = lastTouchPosition {
				let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
				physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
			}
		#else
			if let accelerometerData = motionManager.accelerometerData {
				physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.x * 50)
			}
		#endif
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		lastTouchPosition = location
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		lastTouchPosition = location
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchPosition = nil
	}
	
	func createPlayer(position: CGPoint = CGPoint(x: 96, y: 672)) {
		player = SKSpriteNode(imageNamed: "player")
		player.position = position
		player.zPosition = 1
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody?.allowsRotation = false
		player.physicsBody?.linearDamping = 0.5
		
		player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.portal.rawValue
		player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
		addChild(player)
	}
	
	func loadLevel() {
		guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
			fatalError("Could not find level\(level).txt in the app bundle.")
		}
		guard let levelString = try? String(contentsOf: levelURL) else {
			fatalError("Could not load level\(level).txt from the app bundle.")
		}
		
		let lines = levelString.components(separatedBy: "\n")
		
		for (row, line) in lines.reversed().enumerated() {
			for (column, letter) in line.enumerated() {
				let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
				
				if letter == "x" {
					let node = SKSpriteNode(imageNamed: "block")
					node.position = position
					
					node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
					node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
					node.physicsBody?.isDynamic = false
					addChild(node)
				} else if letter == "v" {
					let node = SKSpriteNode(imageNamed: "vortex")
					node.name = "vortex"
					node.position = position
					node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					
					node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					addChild(node)
				} else if letter == "s" {
					let node = SKSpriteNode(imageNamed: "star")
					node.name = "star"
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					
					node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					node.position = position
					addChild(node)
				} else if letter == "f" {
					let node = SKSpriteNode(imageNamed: "finish")
					node.name = "finish"
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					
					node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					node.position = position
					addChild(node)
				} else if letter == "p" {
					let node = SKSpriteNode(imageNamed: "portal")
					node.color = .purple
					node.name = "portal"
					node.position = position
					node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 32)
					node.physicsBody?.isDynamic = false
					
					node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					portals.append(node)
					addChild(node)
				} else if letter == " " {
					// empty space
				} else {
					fatalError("Unknown level letter: \(letter)")
				}
 			}
		}
	}
}
