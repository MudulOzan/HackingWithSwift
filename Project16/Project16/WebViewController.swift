//
//  WebViewController.swift
//  Project16
//
//  Created by Ozan Mudul on 30.01.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
	var capital: Capital?
	@IBOutlet var webView: WKWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		guard let capital else { return }
		
		let url = URL(string: "https://wikipedia.org/wiki/\(capital.title ?? "")")!
		webView.load(URLRequest(url: url))
	}
}
