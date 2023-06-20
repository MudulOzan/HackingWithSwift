import UIKit

extension UIView {
	func bounceOut(duration: TimeInterval) {
		UIView.animate(withDuration: duration) { [unowned self] in
			self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
		}
	}
}

extension Int {
	func times(string: String) {
		for _ in 0 ..< 5 {
			print(string)
		}
	}
}
print(0.times(string: "Hello"))

print(5.times(string: "hi"))

extension Array where Element: Comparable{
	mutating func remove(item: Element) {
		if let location = self.firstIndex(of: item) {
			self.remove(at: location)
		}
	}
}
