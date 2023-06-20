//
//  ViewController.swift
//  CountryViewer
//
//  Created by Ozan Mudul on 22.01.2023.
//

import UIKit

class ViewController: UITableViewController {
	var allCountries = [Country]()
	var countries = [Country]()
	var year = 2023
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DispatchQueue.global(qos: .background).async {
			self.loadCountries()
		}
	}

	@objc func loadCountries() {
		let urlString: String = "https://h4jvckyvc3jqdg6t2dsxd53bza0lqkml.lambda-url.eu-west-3.on.aws"

		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parseJson(json: data)
				return
			}
		}
		showError()
	}
	
	func showError() {
		let ac = UIAlertController(title: "Loading error",
			message: "There was a problem loading the feed; please check your connection and try again.",
			preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func parseJson(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
			countries = jsonCountries.results
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
		cell.textLabel?.text = countries[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
		vc.country = countries[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
		
	}
}

