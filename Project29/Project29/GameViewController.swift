//
//  GameViewController.swift
//  Project29
//
//  Created by Ozan Mudul on 26.03.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	var currentGame: GameScene!
	
	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!
	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!
	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerNumber: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var windLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        angleChanged(angleSlider)
		velocityChanged(velocitySlider)
		
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
				
				currentGame = scene as? GameScene
				currentGame.viewController = self
				windLabel.text = currentGame.windText
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
	
	@IBAction func angleChanged(_ sender: UISlider) {
		angleLabel.text = "Angle: \(Int(sender.value))°"
	}
	
	@IBAction func velocityChanged(_ sender: UISlider) {
		velocityLabel.text = "Velocity: \(Int(sender.value))"
	}
	
	@IBAction func launch(_ sender: UIButton) {
		angleSlider.isHidden = true
		angleLabel.isHidden = true
		
		velocitySlider.isHidden = true
		velocityLabel.isHidden = true
		
		launchButton.isHidden = true
		
		currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
	}
	
	func activePlayer(number: Int) {
		if number == 1 {
			playerNumber.text = "<<< PLAYER ONE"
		} else {
			playerNumber.text = "PLAYER TWO >>>"
		}
		
		angleSlider.isHidden = false
		angleLabel.isHidden = false
		
		velocitySlider.isHidden = false
		velocityLabel.isHidden = false
		
		launchButton.isHidden = false
	}
	
	func updateScoreLabel(label: String) {
		scoreLabel.text = label
	}
	
	func updateWindLabel(label: String) {
		windLabel.text = label
	}
}
