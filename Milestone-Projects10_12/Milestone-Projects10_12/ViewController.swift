//
//  ViewController.swift
//  PhotosApp
//
//  Created by Ozan Mudul on 9.01.2023.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	var images = [CustomImage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
		
		let defaults = UserDefaults.standard
		
		if let savedImages = defaults.object(forKey: "images") as? Data {
			let jsonDecoder = JSONDecoder()
			
			do {
				images = try jsonDecoder.decode([CustomImage].self, from: savedImages)
			} catch {
				showAlert(title: "Image Load Failed", message: "Failed to load images, please contact app developers")
			}
		}
		
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		longPressRecognizer.minimumPressDuration = 0.3
		self.view.addGestureRecognizer(longPressRecognizer)
	}
	
	@objc func addImage() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		picker.sourceType = .camera
		
		present(picker, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let customImage = images[indexPath.row]
		let image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(customImage.name).path)
		
		cell.imageView?.image = image
		cell.textLabel?.text = images[indexPath.row].caption

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			let image = images[indexPath.row]

			let path = getDocumentsDirectory().appendingPathComponent(image.name)

			vc.selectedImage = path.path
			vc.title = images[indexPath.row].caption
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@objc func handleLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
		if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
			let touchPoint = longPressGestureRecognizer.location(in: self.view)
			if let indexPath = tableView.indexPathForRow(at: touchPoint) {
				let ac = UIAlertController(title: "Edit Image", message: nil, preferredStyle: .alert)
				ac.addTextField()
				ac.addAction(UIAlertAction(title: "Rename Image", style: .default) { [unowned self, ac] _ in
					let newName = ac.textFields![0]
					images[indexPath.row].caption = newName.text!
					self.save()
					self.tableView?.reloadData()
				})
				
				ac.addAction(UIAlertAction(title: "Delete Image", style: .destructive) { [unowned self] _ in
					images.remove(at: indexPath.row)
					self.save()
					self.tableView.reloadData()
				})
				
				ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
				present(ac,animated: true)
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let imageNumber = getImageNumber(number: images.count + 1)
		let imgToAdd = CustomImage(name: imageName, caption: "IMG_\(imageNumber)")
		images.append(imgToAdd)
		save()
		tableView.reloadData()
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	func getImageNumber(number: Int) -> String {
		var imageNumber = ""
		let digits = 4 - Int(floor(log10(Double(number))) + 1)
		for _ in 1...(digits) {
			imageNumber += "0"
		}
		imageNumber += String(number)
		return imageNumber
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		
		if let savedData = try? jsonEncoder.encode(images) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "images")
		} else {
			showAlert(title: "Failed to save", message: "Failed to save the image. Please contact app developers")
		}
	}
	
	func showAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
}
