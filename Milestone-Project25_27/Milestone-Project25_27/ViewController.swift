//
//  ViewController.swift
//  Milestone-Project25_27
//
//  Created by Ozan Mudul on 24.03.2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet var imageView: UIImageView!
	var firstTitle: String = ""
	var secondTitle: String = ""
	var userImage: UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
	}
	
	@objc func addMeme() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		picker.sourceType = .photoLibrary
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		userImage = image
		
		dismiss(animated: true, completion: nil)
		
		let ac = UIAlertController(title: "Add Top Title", message: nil, preferredStyle: .alert)
		let ac2 = UIAlertController(title: "Add Bottom Title", message: nil, preferredStyle: .alert)
		ac.addTextField()
		ac2.addTextField()
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let ac2Action = UIAlertAction(title: "Title", style: .default) { [weak self] _ in
			guard let textField = ac2.textFields?.first else { return }
			self?.secondTitle = textField.text ?? ""
			self?.render()
		}
		ac2.addAction(ac2Action)
		ac2.addAction(cancelAction)
		
		let acAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
			guard let textField = ac.textFields?.first else { return }
			self?.firstTitle = textField.text ?? ""
			self?.present(ac2, animated: true)
		}
		
		ac.addAction(acAction)
		ac.addAction(cancelAction)
		present(ac, animated: true, completion: nil)
	}
	
	func render() {
		guard userImage != nil else { return }
		
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let attrs: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: 24),
				.paragraphStyle: paragraphStyle,
				.foregroundColor: UIColor.red
			]
			
			let string = title
			let topTitle = NSAttributedString(string: firstTitle, attributes: attrs)
			let bottomTitle = NSAttributedString(string: secondTitle, attributes: attrs)
			
			userImage.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
			topTitle.draw(with: CGRect(x: 32, y: 16, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
			bottomTitle.draw(with: CGRect(x: 32, y: 448, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)

		}
		imageView.image = img
	}
}

