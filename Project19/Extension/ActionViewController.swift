//
//  ActionViewController.swift
//  Extension
//
//  Created by Ozan Mudul on 4.02.2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Foundation

class ActionViewController: UIViewController, TableViewControllerDelegate {
	@IBOutlet var script: UITextView!
	var pageTitle = ""
	var pageURL = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(readyMadeScripts))
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
					guard let itemDictionary = dict as? NSDictionary else { return }
					guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
					self?.pageTitle = javaScriptValues["title"] as? String ?? ""
					self?.pageURL = javaScriptValues["URL"] as? String ?? ""
					
					DispatchQueue.main.async {
						self?.title = self?.pageTitle
					}
				}
			}
		}
    }
	
	func didSelectRow(with value: String) {
		script.text = value
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			script.contentInset = .zero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		script.scrollIndicatorInsets = script.contentInset
		
		let selectedRange = script.selectedRange
		script.scrollRangeToVisible(selectedRange)
	}
	
	@objc func readyMadeScripts() {
		let ac = UIAlertController(title: "Select a script", message: nil, preferredStyle: .alert)
		
		ac.addAction(UIAlertAction(title: "Saved Scripts", style: .default) { [weak self] _ in
			if let tvc = self?.storyboard?.instantiateViewController(withIdentifier: "TableView") as? TableViewController {
				tvc.delegate = self
				self?.navigationController?.pushViewController(tvc, animated: true)
			}
		})
		//		ac.addAction(UIAlertAction(title: "Alert document title", style: .default) { [weak self] _ in
//			self?.script.text = "alert(document.title);"
//		})
//		ac.addAction(UIAlertAction(title: "Alert URL", style: .default) { [weak self] _ in
//			self?.script.text = "alert(document.URL);"
//		})
		
//		if let host = URL(string: pageURL)?.host(), !(URL(string: pageURL)?.host!.isEmpty)! {
//			let defaults = UserDefaults.standard
//			let script = defaults.string(forKey: host) ?? ""
//			print(host)
//			if !script.isEmpty {
//				ac.addAction(UIAlertAction(title: "Saved Script", style: .default) { [weak self] _ in
//					self?.script.text = script
//				})
//			}
//		}

		
		ac.addAction(UIAlertAction(title: "Save Script To Site", style: .default) { [weak self] _ in
//			guard let host = URL(string: self!.pageURL)?.host() else {
//				let ac = UIAlertController(title: "Error", message: "Host cannot be found", preferredStyle: .alert)
//				ac.addAction(UIAlertAction(title: "OK", style: .default))
//				self?.present(ac, animated: true)
//				return
//			}
			let ac2 = UIAlertController(title: "Script Name", message: nil, preferredStyle: .alert)
			ac2.addTextField { (textfield) in
				textfield.placeholder = "Your script name"
			}
			ac2.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
				guard let textfield = ac2.textFields?.first else { return }
				if let text = textfield.text, !textfield.text!.isEmpty {
					
					let defaults = UserDefaults.standard
					defaults.set(self?.script.text, forKey: "script:\(text)")
				}
				
			})
			ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			self?.present(ac2, animated: true)
			
		})
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	@IBAction func done() {
		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": script.text!]
		let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
		item.attachments = [customJavaScript]
		
		extensionContext?.completeRequest(returningItems: [item])
	}

}
