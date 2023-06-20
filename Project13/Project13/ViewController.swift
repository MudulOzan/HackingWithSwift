//
//  ViewController.swift
//  InstaFilter
//
//  Created by Ozan Mudul on 14.01.2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet var intensityView: UIStackView!
	@IBOutlet var radiusView: UIStackView!
	@IBOutlet var scaleView: UIStackView!
	@IBOutlet var centerView: UIStackView!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!
	@IBOutlet var radius: UISlider!
	@IBOutlet var scale: UISlider!
	@IBOutlet var center: UISlider!
	@IBOutlet var filterButton: UIButton!
	var currentImage: UIImage!
	var context: CIContext!
	var currentFilter: CIFilter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "InstaFilter"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
		
		context = CIContext()
		currentFilter = CIFilter(name: "CISepiaTone")
		filterButton.setTitle("CISepiaTone", for: .normal)
	}
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		fadeAnimate(alpha: 0)
		currentImage = image
		fadeAnimate(alpha: 1)
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
	}
	
	func fadeAnimate(alpha: CGFloat) {
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
			self.imageView.alpha = alpha
		}
	}
	
	func applyProcessing() {
		let inputKeys = currentFilter.inputKeys
		print(inputKeys)
		if inputKeys.contains(kCIInputIntensityKey) {
			intensityView.isHidden = false
			currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
		} else {
			intensityView.isHidden = true
		}
		
		if inputKeys.contains(kCIInputRadiusKey) {
			radiusView.isHidden = false
			currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
			
		} else {
			radiusView.isHidden = true
		}
		
		if inputKeys.contains(kCIInputScaleKey) {
			scaleView.isHidden = false
			currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
		} else {
			scaleView.isHidden = true
		}
		
		if inputKeys.contains(kCIInputCenterKey) {
			centerView.isHidden = false
			currentFilter.setValue(CIVector(x: currentImage.size.width / CGFloat(center.value), y: currentImage.size.height / CGFloat(center.value)), forKey: kCIInputCenterKey)
		} else {
			centerView.isHidden = true
		}

		if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
			let processedImage = UIImage(cgImage: cgimg)
			self.imageView.image = processedImage
		}
	}
	
	func setFilter(action: UIAlertAction) {
		guard currentImage != nil else { return }
		
		guard let actionTitle = action.title else { return }
		
		currentFilter = CIFilter(name: actionTitle)
		filterButton.setTitle(actionTitle, for: .normal)
				
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
	}
	

	
	@IBAction func changeFilter(_ sender: Any) {
		let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	
	@IBAction func save(_ sender: Any) {
		guard let image = imageView.image else {
			let ac = UIAlertController(title: "No image selected", message: nil, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
			return
		}
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@IBAction func intensityChanged(_ sender: Any) {
		applyProcessing()
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
}

