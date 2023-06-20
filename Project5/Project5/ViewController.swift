//
//  ViewController.swift
//  WordScramble
//
//  Created by Ozan Mudul on 8.12.2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
	var usedWords = [String]()
	var currentWord = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
		let defaults = UserDefaults.standard
		currentWord = defaults.object(forKey: "currentWord") as? String ?? ""
		
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
             allWords = ["silkworm"]
        }
        
        startGame()
    }


    @objc func startGame() {
		let defaults = UserDefaults.standard
		if currentWord.isEmpty {
			currentWord = allWords.randomElement() ?? ""
			title = currentWord
			defaults.set(currentWord, forKey: "currentWord")
		} else {
			title = currentWord
		}
        usedWords.removeAll(keepingCapacity: true)
		usedWords = defaults.object(forKey: "usedWords") as? [String] ?? [String]()
        tableView.reloadData()
    }
	
	@objc func restartGame() {
		let defaults = UserDefaults.standard
		currentWord = allWords.randomElement() ?? ""
		title = currentWord
		defaults.set(currentWord, forKey: "currentWord")
		usedWords.removeAll(keepingCapacity: true)
		defaults.set(usedWords, forKey: "usedWords")
		tableView.reloadData()
	}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer.lowercased(), at: 0)
					UserDefaults.standard.set(usedWords, forKey: "usedWords")

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        } else {
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from '\(title!.lowercased())'!")
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()

        for letter in word {
            if let position = tempWord.range(of: String(letter)) {
                tempWord.remove(at: position.lowerBound)
            } else {
                return false
            }
        }

        return true
    }
        
    func isOriginal(word: String) -> Bool {
        if(word.lowercased() == title!.lowercased()) {
            return false
        }
        return !usedWords.contains(word.lowercased())
    }
        
    func isReal(word: String) -> Bool {
        if(word.count < 3) {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
}

