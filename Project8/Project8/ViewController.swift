//
//  ViewController.swift
//  SwiftWords
//
//  Created by Ozan Mudul on 14.12.2022.
//

import UIKit

class ViewController: UIViewController {
	var cluesLabel: UILabel!
	var answersLabel: UILabel!
	var currentAnswer: UITextField!
	var scoreLabel: UILabel!
	var letterButtons = [UIButton]()
	
	var activatedButtons = [UIButton]()
	var solutions = [String]()
	
	var correctAnswers = 0
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	var level = 1
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)
		
		cluesLabel = UILabel()
		cluesLabel.translatesAutoresizingMaskIntoConstraints = false
		cluesLabel.font = UIFont.systemFont(ofSize: 24)
		cluesLabel.text = "CLUES"
		cluesLabel.numberOfLines = 0
		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(cluesLabel)
		
		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.font = UIFont.systemFont(ofSize: 24)
		answersLabel.text = "ANSWERS"
		answersLabel.textAlignment = .right
		answersLabel.numberOfLines = 0
		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		view.addSubview(answersLabel)
		
		currentAnswer = UITextField()
		currentAnswer.translatesAutoresizingMaskIntoConstraints = false
		currentAnswer.placeholder = "Tap letters to guess"
		currentAnswer.textAlignment = .center
		currentAnswer.font = UIFont.systemFont(ofSize: 44)
		currentAnswer.isUserInteractionEnabled = false
		view.addSubview(currentAnswer)
		
		let submit = UIButton(type: .system)
		submit.translatesAutoresizingMaskIntoConstraints = false
		submit.setTitle("SUBMIT", for: .normal)
		submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
		view.addSubview(submit)
		
		let clear = UIButton(type: .system)
		clear.translatesAutoresizingMaskIntoConstraints = false
		clear.setTitle("CLEAR", for: .normal)
		clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
		view.addSubview(clear)
		
		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		buttonsView.layer.borderColor = UIColor.gray.cgColor
		buttonsView.layer.borderWidth = 1
		buttonsView.layer.cornerRadius = 10
		view.addSubview(buttonsView)
		
		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
			cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
			answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
			answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
			answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
			currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
			submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
			submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
			submit.heightAnchor.constraint(equalToConstant: 44),
			clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
			clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
			clear.heightAnchor.constraint(equalToConstant: 44),
			buttonsView.widthAnchor.constraint(equalToConstant: 750),
			buttonsView.heightAnchor.constraint(equalToConstant: 320),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
			buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])
		
		let width = 150
		let height = 80
		
		for row in 0..<4 {
			for column in 0..<5 {
				let letterButton = UIButton(type: .system)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				letterButton.setTitle("WWW", for: .normal)
				letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside )
				
				let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
				letterButton.frame = frame
				
				buttonsView.addSubview(letterButton)
				letterButtons.append(letterButton)
			}
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		performSelector(inBackground: #selector(loadLevel), with: nil)
		
	}
	
	@objc func letterTapped(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return }
		
		currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
		activatedButtons.append(sender)
//		sender.isHidden = true
		fadeAnimate(sender: sender, alpha: 0.1)
		
	}
	
	func fadeAnimate(sender: UIButton, alpha: CGFloat) {
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
			sender.alpha = alpha
		}
	}
	
	@objc func submitTapped(_ sender: UIButton) {
		guard let answerText = currentAnswer.text else { return }
		
		if let solutionPosition = solutions.firstIndex(of: answerText) {
			activatedButtons.removeAll()
			
			var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
			splitAnswers?[solutionPosition] = answerText
			answersLabel.text = splitAnswers?.joined(separator: "\n")
			
			currentAnswer.text = ""
			score += 1
			correctAnswers += 1
			
			if correctAnswers % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
				present(ac, animated: true)
			}
			
		}
		else {
			let ac = UIAlertController(title: "Incorrect guess!", message: "You guessed wrong and lost some points", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Ok", style: .default))
			score -= 1
			present(ac, animated: true)
		}
	}
	
	func levelUp(action: UIAlertAction) {
		level += 1
		
		solutions.removeAll(keepingCapacity: true)
		performSelector(inBackground: #selector(loadLevel), with: nil)
		
		for button in letterButtons {
//			button.isHidden = false
			fadeAnimate(sender: button, alpha: 1)
		}
	}
	
	@objc func clearTapped(_ sender: UIButton) {
		currentAnswer.text = ""
		
		for button in activatedButtons {
//			button.isHidden = false
			fadeAnimate(sender: button, alpha: 1)
		}
		
		activatedButtons.removeAll()
	}
	
	@objc func loadLevel() {
		var clueString = ""
		var solutionsString = ""
		var letterBits = [String]()
		
		if let levelFleUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
			if let levelContents = try? String.init(contentsOf: levelFleUrl) {
				var lines = levelContents.components(separatedBy: "\n")
				lines.shuffle()
				
				for (index, line) in lines.enumerated() {
					let parts = line.components(separatedBy: ": ")
					let answer = parts[0]
					let clue = parts[1]
					
					clueString += "\(index + 1). \(clue)\n"
					
					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionsString += "\(solutionWord.count) letters\n"
					solutions.append(solutionWord)
					
					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
			}
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
			self?.answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
			if  self?.letterButtons.count == letterBits.count {
				for i in 0..<(self?.letterButtons.count)! {
					self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
				}
			}
		}
	}
}

