//
//  DetailViewController.swift
//  ConsolidationVIII
//
//  Created by Ozan Mudul on 9.02.2023.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
	@IBOutlet var textView: UITextView!
	var note: Note!
	var saveTimer: Timer?
	var delegate: MainViewDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textView.delegate = self
		textView.text = note.content
		
		let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(actionsTapped))
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
		navigationItem.rightBarButtonItems = [composeButton, deleteButton]
		
	}
	
	@objc func actionsTapped() {
		let ac = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Share", style: .default) { [weak self] _ in
			let activityViewController = UIActivityViewController(activityItems: [self?.note.content ?? ""], applicationActivities: nil)
			
			activityViewController.excludedActivityTypes = [.airDrop, .postToFacebook]
			
			self?.present(activityViewController, animated: true, completion: nil)
		})
		present(ac, animated: true)
		
	}
	
	func textViewDidChange(_ textView: UITextView) {
		saveTimer?.invalidate()
		saveTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
			guard let self = self else { return }
			self.saveNote()
		})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		saveNote(dismiss: true)
	}
	
	@objc func deleteNote() {
		delegate?.deleteNote(note: note, dismiss: true)
	}
	
	func saveNote(dismiss: Bool = false) {
		guard let text = textView.text else { return }
		let firstLine = text.split(separator: "\n").first
		
		note.title = String(firstLine ?? "New Note")
		note.content = textView.text
		
		NoteHandler.save(note: note) { result in
			switch result {
			case .success:
				delegate?.updateNote(note: note)
				print("Note saved successfully.")
			case .savingFailed(let title, let message):
				if dismiss {
					delegate?.alertMain(title: title, message: message)
				} else {
					showAlert(title: title, message: message)
				}
			}
		}
	}
}
