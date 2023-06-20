//
//  ViewController.swift
//  Project21
//
//  Created by Ozan Mudul on 5.02.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
	}
	
	@objc func registerLocal() {
		let center = UNUserNotificationtCenter.current()
		
		center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
			if granted {
				print("Yay")
			} else {
				print("D'oh")
			}
		}
	}
	
	@objc func scheduleLocal() {
		registerCategorioes()
		let center = UNUserNotificationCenter.current()
		
		let content = UNMutableNotificationContent()
		content.title = "Late wake up call"
		content.body = "The early bird catches the worm, but the second mouse gets the cheese."
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = UNNotificationSound.default
		
		var dateComponents = DateComponents()
		dateComponents.hour = 19
		dateComponents.minute = 25
//		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

		
//		center.removeAllPendingNotificationRequests()
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	func registerCategorioes() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
		let remindMeLater = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .destructive)
		let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [])
		
		center.setNotificationCategories([category])
	}


	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom data recieved: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				alertMessage(message: "Default identifier")
			case "show":
				alertMessage(message: "Show more information...")
			case "remind":
				scheduleLocal()
			default:
				break
			}
		}
		completionHandler()
	}
	
	func alertMessage(message: String) {
		let ac = UIAlertController(title: "Identifier", message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}

