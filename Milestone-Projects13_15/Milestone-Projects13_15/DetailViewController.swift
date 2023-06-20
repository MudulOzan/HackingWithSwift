//
//  DetailViewController.swift
//  CountryViewer
//
//  Created by Ozan Mudul on 22.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
	var country: Country!

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var capitalCityLabel: UILabel!
	@IBOutlet var sizeLabel: UILabel!
	@IBOutlet var populationLabel: UILabel!
	@IBOutlet var currencyLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		guard let country = country else { return }
		
		nameLabel.text = country.name
		capitalCityLabel.text = country.capitalCity
		sizeLabel.text = country.size
		populationLabel.text = country.population
		currencyLabel.text = country.currency
    }
}
