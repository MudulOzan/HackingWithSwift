import UIKit

let name = "Taylor"

for letter in name {
	print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
	subscript(i: Int) -> String {
		return String(self[index(startIndex, offsetBy: i)])
	}
}

print(letter)
print(name[3])

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
	func deletingPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return self }
		return String(self.dropFirst(prefix.count))
	}
	
	func deletingSuffix(_ suffix: String) -> String {
		guard self.hasSuffix(suffix) else { return self }
		return String(self.dropLast(suffix.count))
	}
}

let weather = "it's going to rain"
print(weather.capitalized)


extension String {
	var capitalizedFirst: String {
		guard let firstLetter = self.first else { return "" }
		return firstLetter.uppercased() + self.dropFirst()
	}
}

let input = "Swift is like Objective-C without the C"
print(input.contains("Swift"))

let languages = ["Python", "Ruby", "Swift", "Swift is like Objective-C without the C"]
print(languages.contains("Swift"))

extension String {
	func containsAny(of array: [String]) -> Bool {
		for item in array {
			if self.contains(item) {
				return true
			}
		}
		
		return false
	}
}

print(input.containsAny(of: languages))

print(languages.contains(where: input.contains))

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
	.foregroundColor: UIColor.white,
	.backgroundColor: UIColor.red,
	.font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)


let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

extension String {
	func withPrefix(_ prefix: String) -> String {
		if(self.hasPrefix(prefix)) {
			return self
		} else {
			return prefix + self
		}
	}
	func isNumeric() -> Bool {
		return self.allSatisfy { Character in
			Character.isNumber
		}
	}
	var lines: [String] {
		return self.components(separatedBy: "\n")
	}
}

let myString = "dog"
let watchDog = "watchdog"
print(myString.withPrefix("watch"))
print(watchDog.withPrefix("watch"))

let a = "asd123asd"
let b = "123asd123"
let c = "123123213"

print(a.isNumeric())
print(b.isNumeric())
print(c.isNumeric())

let myLines = "this\nis\na\ntest"
print(myLines.lines)
