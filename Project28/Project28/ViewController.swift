//
//  ViewController.swift
//  Project28
//
//  Created by Ozan Mudul on 25.03.2023.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
	@IBOutlet var secret: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
		navigationItem.rightBarButtonItem?.isHidden = true
		
		title = "Nothing to see here"
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
	}
	
	func unlockSecretMessage() {
		secret.isHidden = false
		navigationItem.rightBarButtonItem?.isHidden = false
		title = "Secret stuff!"
		
		if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
			secret.text = text
		}
	}
	
	@objc func saveSecretMessage() {
		guard secret.isHidden == false else { return }
		
		KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
		secret.resignFirstResponder()
		secret.isHidden = true
		navigationItem.rightBarButtonItem?.isHidden = true
		title = "Nothing to see here"
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			secret.contentInset = .zero
		} else {
			secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		secret.scrollIndicatorInsets = secret.contentInset
		
		let selectedRange = secret.selectedRange
		secret.scrollRangeToVisible(selectedRange)
	}
	
	@IBAction func authenticateTapped(_ sender: UIButton) {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "You must unlock the app first"
			
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationerror in
								DispatchQueue.main.async {
					if success {
						self?.unlockSecretMessage()
					} else {
						let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				}
			}
		} else {
			authenticateWithPassword()
//			let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
//			ac.addAction(UIAlertAction(title: "OK", style: .default))
//			present(ac, animated: true)
		}
		
	}
	
	func saveSecretPassword(password: String) {
		KeychainWrapper.standard.set(password, forKey: "SecretPassword")
	}
	
	func authenticateWithPassword() {
		let secretPassword = KeychainWrapper.standard.string(forKey: "SecretPassword")
		if secretPassword?.isEmpty == true || secretPassword == nil {
			createPassword(title: "Create A Password")
		}
		else {
			let ac = UIAlertController(title: "Enter Your Password", message: nil, preferredStyle: .alert)
			ac.addTextField { (textfield) in
				textfield.isSecureTextEntry = true
			}
			ac.addAction(UIAlertAction(title: "Login", style: .default) { [weak self] _ in
				guard let text = ac.textFields?[0].text else { return }
				if text == secretPassword {
					self?.unlockSecretMessage()
				} else {
					let ac = UIAlertController(title: "Wrong Password", message: nil, preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					self?.present(ac, animated: true)
				}
			})
			present(ac, animated: true)
		}
	}
	
	func createPassword(title: String, message: String? = nil) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addTextField { (textfield) in
			textfield.isSecureTextEntry = true
		}
		ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
			guard let text = ac.textFields?[0].text else { return }
			guard !text.isEmpty else {
				self?.createPassword(title: "Create A Password", message: "Password cannot be empty")
				return
			}
			self?.saveSecretPassword(password: text)
		})
		present(ac, animated: true)
	}
}

