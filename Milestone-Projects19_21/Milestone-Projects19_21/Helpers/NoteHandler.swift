//
//  NoteHandler.swift
//  ConsolidationVIII
//
//  Created by Ozan Mudul on 10.02.2023.
//

import Foundation

enum SaveResult: Error {
	case success
	case savingFailed(title: String, reason: String)
}


struct NoteHandler {
	static func save(note: Note, completion: (SaveResult) -> Void) {
		let filename = getDocumentsDirectory().appendingPathComponent("\(note.key).txt")
		
		do {
			let jsonData = try JSONEncoder().encode(note)
			let jsonString = String(data: jsonData, encoding: .utf8)
			
			if !FileManager.default.fileExists(atPath: filename.path) {
				FileManager.default.createFile(atPath: filename.path, contents: nil, attributes: nil)
			}
			
			try jsonString!.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
			completion(.success)
		} catch {
			completion(.savingFailed(title: "Failed to save note", reason: error.localizedDescription))
		}
	}
	
	static func delete(note: Note, completion: (SaveResult) -> Void) {
		let filename = getDocumentsDirectory().appendingPathComponent("\(note.key).txt")
		
		if !FileManager.default.fileExists(atPath: filename.path) {
			completion(.savingFailed(title: "Failed to delete note", reason: "File does not exist"))
			return
		}
		
		do {
			try FileManager.default.removeItem(at: filename)
			completion(.success)
		} catch {
			completion(.savingFailed(title: "Failed to delete note", reason: error.localizedDescription))
		}
	}
	
	static func readAll() -> [Note] {
		var notes = [Note]()
		let fileManager = FileManager.default
		let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

		do {
			let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
			for fileURL in fileURLs {
				if let contents = try? Data(contentsOf: fileURL) {
					let decoder = JSONDecoder()
					if let note = try? decoder.decode(Note.self, from: contents) {
						notes.append(note)
					} else {
						let fileContents = String(data: contents, encoding: .utf8) ?? "unknown contents"
						print("Error parsing note: \(fileURL) - contents: \(fileContents)")
					}
				} else {
					print("Error reading contents")
				}
			}
		} catch {
			print("Error reading files: \(error)")
		}

		print("Read \(notes.count) notes: \(notes)")
		return notes
	}

}

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}
