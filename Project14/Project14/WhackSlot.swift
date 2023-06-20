//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Ozan Mudul on 15.01.2023.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
	var charNode: SKSpriteNode!
	var isVisible = false
	var isHit = false
	
	func configure(at position: CGPoint) {
		self.position = position
		
		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)
		
		let cropNode = SKCropNode()
		cropNode.position = CGPointMake(0, 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
		
		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPointMake(0, -90)
		charNode.name = "character"
		cropNode.addChild(charNode)
		
		addChild(cropNode)
	}
	
	func show(hideTime: Double) {
		if isVisible { return }
		
		charNode.xScale = 1
		charNode.yScale = 1
		
		showMud()
		charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
		isVisible = true
		isHit = false
		
		if Int.random(in: 0...2) == 0 {
			charNode.texture = SKTexture(imageNamed: "penguinGood")
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: "penguinEvil")
			charNode.name = "charEnemy"
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
			self?.hide()
		}
	}
	
	func hide() {
		if !isVisible { return }
		
		charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
		
		showMud()
		isVisible = false
	}
	
	func hit() {
		isHit = true
		
		if let smokeParticles = SKEmitterNode(fileNamed: "smokeParticles") {
			smokeParticles.position = CGPointMake(charNode.position.x, charNode.position.y + 5)
			smokeParticles.zPosition = 1
			addChild(smokeParticles)
		}
		let delay = SKAction.wait(forDuration: 0.25)
		let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
		let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
		charNode.run(SKAction.sequence( [delay, hide, notVisible]))
	}
	
	func showMud() {
		if let mudParticles = SKEmitterNode(fileNamed: "mudParticles") {
			mudParticles.position = charNode.position
			addChild(mudParticles)
		}
	}
}
