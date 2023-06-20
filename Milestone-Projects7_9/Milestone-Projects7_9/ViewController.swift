//
//  ViewController.swift
//  Hangman
//
//  Created by Ozan Mudul on 15.12.2022.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var attemptsLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var wordText: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var usedLettersLabel: UILabel!
	
	var attempts = 10 {
		didSet {
			if attempts == 0 {
				gameOver()
			}
			attemptsLabel.text = "Attempts: \(attempts)"
		}
	}
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	var allWords = [String]()
	var hiddenWord: String!
	var usedLetters = [String]()
	var promptWord = "" {
		didSet {
			wordText.text = promptWord
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadGame()
	}
	
	func gameOver() {
		let ac = UIAlertController(title: "Game Over", message: "Do you want to play another one?", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
			self?.loadGame()
		})
		ac.addAction(UIAlertAction(title: "No, thanks.", style: .cancel))
	}

	func loadGame() {
		if let wordsUrl = Bundle.main.url(forResource: "Words", withExtension: "txt") {
			if let wordsToLoad = try? String(contentsOf: wordsUrl) {
				allWords = wordsToLoad.components(separatedBy: "\n").filter { !$0.isEmpty }
				allWords.shuffle()
				prepareWord()
			}
		}
		
	}

	@IBAction func submitTapped(_ sender: UIButton) {
		let ac = UIAlertController(title: "Enter a letter", message: nil, preferredStyle: .alert)
		ac.addTextField()
		ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
			let result = ac.textFields?[0].text
			
			self?.validateResult(result: result!.uppercased())
		})
		present(ac, animated: true)
	}

	func prepareWord() {
		if(allWords.count > 0) {
			hiddenWord = allWords.popLast()
			prepareTextField()
		}
		else {
			gameOver()
		}
	}
	
	func prepareTextField() {
		var newText = ""
		for letter in hiddenWord {
			let strLetter = String(letter)

			if usedLetters.contains(strLetter) {
				newText += strLetter
			}
			else {
				newText += "?"
			}
		}
		promptWord = newText
		if(!newText.contains("?")) {
			levelUp()
		}
	}
	
	func levelUp() {
		score += 1
		attempts = 10
		usedLetters = []
		usedLettersLabel.text = ""
		prepareWord()
	}
	
	func validateResult(result: String) {
		var alertTitle = ""
		var alertMessage = ""
		if !result.isEmpty {
			if result.count == 1 {
				if(!usedLetters.contains(result)) {
					usedLettersLabel.text! += result + " "
					usedLetters.append(result)
					if(hiddenWord.contains(result)) {
						prepareTextField()
					}
					else {
						attempts -= 1
						
					}
					return
				}
				else {
					alertTitle = "Already used"
					alertMessage = "This letter is already used."
				}
			}
			else {
				alertTitle = "Only a letter"
				alertMessage = "You can only submit one letter at a time."
			}
		}
		else {
			alertTitle = "Nothing entered"
			alertMessage = "You should enter a letter."

		}
		showAlert(title: alertTitle, message: alertMessage)
	}
	
	@IBAction func foundWord(_ sender: Any) {
		let ac = UIAlertController(title: "Enter the whole word", message: nil, preferredStyle: .alert)
		ac.addTextField()
		ac.addAction(UIAlertAction(title: "Guess", style: .default) { [weak self, weak ac] _ in
			guard let guess = ac?.textFields![0].text else { return }
			if guess.count < 1 { return }
			
			if guess.lowercased() == self?.hiddenWord.lowercased() {
				self?.levelUp()
			}
			else {
				self?.attempts -= 2
			}
		})
		present(ac, animated: true)
	}
	
	func showAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
}

