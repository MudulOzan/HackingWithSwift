//
//  ViewController.swift
//  GuesstheFlag
//
//  Created by Ozan Mudul on 29.11.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var question = 0
    var highScore = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		registerLocal()
		scheduleLocal()
		
		highScore = UserDefaults.standard.object(forKey: "highScore") as? Int ?? 0
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
        
    }
	
	func registerLocal() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			if granted {
				print("Granted")
			} else {
				print("Not granted")
			}
		}
	}
	
	func scheduleLocal() {
		let center = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		content.title = "Come back to play"
		content.body = "We missed you here, please come back and play."
		content.categoryIdentifier = "reminder"
		content.sound = UNNotificationSound.default
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
    
	
    func restart(action: UIAlertAction) {
        score = 0
        question = 0
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        if question < 10 {
            question += 1
            
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)
            
            title = "Country: \(countries[correctAnswer].uppercased()) Score: \(score)"
        }
        else {
			if score > highScore {
				highScore = score
				UserDefaults.standard.set(highScore, forKey: "highScore")
			}
            let ac = UIAlertController(title: "Final Results", message: "Your final score is \(score) \n The high score is: \(highScore)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restart))
            present(ac, animated: true)
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
			sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
		}
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
			sender.transform = .identity
		}
        var title: String
        var message = ""
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        }
        else {
            title = "Wrong"
            message = "Wrong! That's the flag of \(countries[correctAnswer].uppercased())"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
}
