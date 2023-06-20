//
//  TableViewController.swift
//  Extension
//
//  Created by Ozan Mudul on 4.02.2023.
//

import UIKit
import Foundation

protocol TableViewControllerDelegate: AnyObject {
	func didSelectRow(with value: String)
}

class TableViewController: UITableViewController {
	weak var delegate: TableViewControllerDelegate?
	var allKeys = [String]()
	let prefix = "script:"
	override func viewDidLoad() {
		super.viewDidLoad()
				
		let defaults = UserDefaults.standard
		allKeys = Array(defaults.dictionaryRepresentation().keys).filter { (key) -> Bool in
			return key.hasPrefix(prefix)
		}
		allKeys = allKeys.map { (key) -> String in
			return key.replacingOccurrences(of: prefix, with: "")
		}

	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allKeys.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = allKeys[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let defaults = UserDefaults.standard
		let key = allKeys[indexPath.row]
		let value = defaults.string(forKey: prefix + key) ?? ""
		delegate?.didSelectRow(with: value)
		self.navigationController?.popViewController(animated: true)
	}
	
}
