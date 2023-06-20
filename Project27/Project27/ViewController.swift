//
//  ViewController.swift
//  Project27
//
//  Created by Ozan Mudul on 23.03.2023.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var currentDrawType = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()

		drawRectangle()
	}

	func drawRectangle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
			
			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)
			
			ctx.cgContext.addRect(rectangle)
			ctx.cgContext.drawPath(using: .fillStroke)
		}
		
		imageView.image = img
	}
	
	func drawCircle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)
			
			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)
			
			ctx.cgContext.addEllipse(in: rectangle)
			ctx.cgContext.drawPath(using: .fillStroke)
		}
		
		imageView.image = img
	}
	
	func drawCheckerboard() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			ctx.cgContext.setFillColor(UIColor.black.cgColor)
			
			for row in 0 ..< 8 {
				for col in 0 ..< 8 {
					if (row + col) % 2 == 0 {
						ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				}
			}
		}
		
		imageView.image = img
	}
	
	func drawRotatedSquares() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)
			
			let rotations = 16
			let amount = Double.pi / Double(rotations)
			
			for _ in 0 ..< rotations {
				ctx.cgContext.rotate(by: CGFloat(amount))
				ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
			}
			
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
		}
		
		imageView.image = img
	}
	
	func drawLines() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)
			
			var first = true
			var length: CGFloat = 256
			
			for _ in 0 ..< 256 {
				ctx.cgContext.rotate(by: .pi / 2)
				
				if first {
					ctx.cgContext.move(to: CGPoint(x: length, y: 50))
					first = false
				} else {
					ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
				}
				
				length *= 0.99
			}
			
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
		}
		
		imageView.image = img
	}
	
	func drawImagesAndText() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let attrs: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: 36),
				.paragraphStyle: paragraphStyle
			]
			
			let string = "The best-laid schemes o'\nmice an' men gang aft agley"
			let attributedString = NSAttributedString(string: string, attributes: attrs)
			
			attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
			
			let mouse = UIImage(named: "mouse")
			mouse?.draw(at: CGPoint(x: 300, y: 150))
		}
		
		imageView.image = img
	}
	
	func drawTwin() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let word = "TWIN"

			var startPoint = CGPoint(x: 150, y: 256)

			for letter in word {
				ctx.cgContext.move(to: startPoint)
				
				switch letter {
				case "T":
					let endPoint = CGPoint(x: startPoint.x + 50, y: startPoint.y)
					let endPoint2 = CGPoint(x: startPoint.x + 25, y: startPoint.y + 50)
					ctx.cgContext.addLine(to: endPoint)
					ctx.cgContext.move(to: CGPoint(x: startPoint.x + 25, y: startPoint.y))
					ctx.cgContext.addLine(to: endPoint2)
				case "W":
					let endPoint1 = CGPoint(x: startPoint.x + 20, y: startPoint.y + 50)
					let endPoint2 = CGPoint(x: endPoint1.x + 20, y: startPoint.y)
					let endPoint3 = CGPoint(x: endPoint2.x + 20, y: endPoint1.y)
					let endPoint4 = CGPoint(x: endPoint3.x + 20, y: endPoint1.y - 50)
					ctx.cgContext.addLine(to: endPoint1)
					ctx.cgContext.addLine(to: endPoint2)
					ctx.cgContext.addLine(to: endPoint3)
					ctx.cgContext.addLine(to: endPoint4)
					startPoint.x += 30
				case "I":
					let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + 50)
					ctx.cgContext.addLine(to: endPoint)
					startPoint.x -= 50
				case "N":
					ctx.cgContext.move(to: CGPoint(x: startPoint.x, y: startPoint.y + 50))
					let endPoint1 = CGPoint(x: startPoint.x, y: startPoint.y)
					let endPoint2 = CGPoint(x: endPoint1.x + 30, y: endPoint1.y + 50)
					let endPoint3 = CGPoint(x: endPoint2.x, y: endPoint1.y)
					ctx.cgContext.addLine(to: endPoint1)
					ctx.cgContext.addLine(to: endPoint2)
					ctx.cgContext.addLine(to: endPoint3)
				default:
					break
				}
				startPoint.x += 70
			}
			ctx.cgContext.setLineWidth(5)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
		}
		imageView.image = img
	}
	
	func drawStar() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let img = renderer.image { ctx in
			let starPath = UIBezierPath()
			let starWidth: CGFloat = 100.0
			let starHeight: CGFloat = 100.0

			let starPoints: [CGPoint] = [
				CGPoint(x: starWidth * 0.5, y: 0),
				CGPoint(x: starWidth * 0.6, y: starHeight * 0.4),
				CGPoint(x: starWidth, y: starHeight * 0.4),
				CGPoint(x: starWidth * 0.7, y: starHeight * 0.6),
				CGPoint(x: starWidth * 0.8, y: starHeight),
				CGPoint(x: starWidth * 0.5, y: starHeight * 0.8),
				CGPoint(x: starWidth * 0.2, y: starHeight),
				CGPoint(x: starWidth * 0.3, y: starHeight * 0.6),
				CGPoint(x: 0, y: starHeight * 0.4),
				CGPoint(x: starWidth * 0.4, y: starHeight * 0.4)
			]

			ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
			ctx.cgContext.beginPath()
			ctx.cgContext.move(to: starPoints[0])

			for i in 1..<starPoints.count {
				ctx.cgContext.addLine(to: starPoints[i])
			}

			ctx.cgContext.closePath()
			ctx.cgContext.fillPath()
		}
		imageView.image = img
	}
	
	@IBAction func redrawTapped(_ sender: UIButton) {
		currentDrawType += 1
		
		if currentDrawType > 7 {
			currentDrawType = 0
		}
		
		switch currentDrawType {
		case 0:
			drawRectangle()
		case 1:
			drawCircle()
		case 2:
			drawCheckerboard()
		case 3:
			drawRotatedSquares()
		case 4:
			drawLines()
		case 5:
			drawImagesAndText()
		case 6:
			drawTwin()
		case 7:
			drawStar()
		default:
			break
		}
	}
	
}

