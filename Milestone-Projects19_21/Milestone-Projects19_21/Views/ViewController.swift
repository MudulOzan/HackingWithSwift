//
//  ViewController.swift
//  ConsolidationVIII
//
//  Created by Ozan Mudul on 7.02.2023.
//

import UIKit

protocol MainViewDelegate {
	func alertMain(title: String, message: String)
	func updateNote(note: Note)
	func deleteNote(note: Note, dismiss: Bool)
}

class ViewController: UITableViewController, MainViewDelegate {
	var notes = [Note]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
		notes = NoteHandler.readAll()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		cell.textLabel?.text = notes[indexPath.row].title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewNote(note: notes[indexPath.row])
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

	   let deleteaction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
		   guard let self = self else { return }

		   self.deleteNote(note: self.notes[indexPath.row], dismiss: false)
		   completionHandler(true)
	   }
		deleteaction.backgroundColor = UIColor.red
		return UISwipeActionsConfiguration(actions: [deleteaction])
	}
	
	func deleteNote(note: Note, dismiss: Bool) {
		guard let noteIndex = notes.firstIndex(where: { $0.key == note.key }) else {
			showAlert(title: "Could not find note", message: nil)
			return
		}
		if(dismiss) {
			navigationController?.popViewController(animated: true)
		}
			
		NoteHandler.delete(note: note) { result in
			switch result {
			case .success:
				print("Note deleted successfully.")
				notes.remove(at: noteIndex)
				tableView.reloadData()
			case .savingFailed(let title, let message):
				showAlert(title: title, message: message)
			}
		}
	}
	
	@objc func addNote() {
		let note = Note(title: "New Note", content: "")
		notes.append(note)
		viewNote(note: note)
	}
	
	func alertMain(title: String, message: String) {
		showAlert(title: title, message: message)
	}
	
	func viewNote(note: Note) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
			vc.note = note
			vc.delegate = self
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func updateNote(note: Note) {
		if let index = notes.firstIndex(where: { $0.key == note.key }) {
			notes[index].title = note.title
			notes[index].content = note.content
		}
		tableView.reloadData()
	}
}

