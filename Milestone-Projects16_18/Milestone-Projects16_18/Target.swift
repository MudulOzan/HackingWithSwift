//
//  Target.swift
//  ShootingGame
//
//  Created by Ozan Mudul on 3.02.2023.
//

import Foundation
import SpriteKit

class Target: SKNode {
	var target: SKSpriteNode!
	var stick: SKSpriteNode!
	
	func create() {
		let targetVariation = "target\(Int.random(in: 0...3))"
		target = SKSpriteNode(imageNamed: targetVariation)
		let stickVariation = "stick\(Int.random(in:0...2))"
		stick = SKSpriteNode(imageNamed: stickVariation)

		target.name = "target"
		target.position.y += 110
		
		addChild(target)
		addChild(stick)
	}
	
	func hit() {
		removeAllActions()
		target.name = nil

		let animationTime = 0.2
		target.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
		stick.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
		run(SKAction.fadeOut(withDuration: animationTime))
		run(SKAction.moveBy(x: 0, y: -30, duration: animationTime))
		run(SKAction.scaleX(by: 0.8, y: 0.7, duration: animationTime))
	}
}
