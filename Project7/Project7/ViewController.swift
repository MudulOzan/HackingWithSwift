//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Ozan Mudul on 13.12.2022.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()
	var filteredPetitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
		performSelector(inBackground: #selector(fetchJson), with: nil)
	}
	
	@objc func fetchJson() {
		var urlString:String
		
		
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		
		
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseJson(json: data)
				return
			}
		}
		showError()
		performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
	}
	
	@objc func filterPetitions() {
		let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
			if let item = ac?.textFields?[0].text {
				self?.performSelector(inBackground: #selector(self?.filterPetitionsContains), with: item)
			}
		}
		
		ac.addAction(searchAction)
		ac.addAction(UIAlertAction(title: "Clear filter", style: .default) { [weak self] _ in
			self?.filteredPetitions = self!.petitions
			self?.tableView.reloadData()
		})
		
		ac.preferredAction = searchAction
		present(ac, animated: true)
	}
	
	@objc func filterPetitionsContains(_ item: String) {
		filteredPetitions = petitions.filter {
			$0.title.localizedCaseInsensitiveContains(item)
			|| $0.body.localizedCaseInsensitiveContains(item)
		}
		tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
	}
	
	@objc func showCredits() {
		let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	@objc func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func  parseJson(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			filteredPetitions = petitions
			tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
		} else {
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredPetitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let petition = filteredPetitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
	
}

