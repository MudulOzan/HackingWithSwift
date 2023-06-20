//
//  DetailViewController.swift
//  PhotosApp
//
//  Created by Ozan Mudul on 9.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
	var selectedImage: String?
	@IBOutlet var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		
		if let selectedImage = selectedImage {
			imageView.image = UIImage(contentsOfFile: selectedImage)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
}
