//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Ozan Mudul on 6.12.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var webSites = ["apple.com", "google.com", "wikipedia.org"]
    var forwardButton: UIBarButtonItem!
    var backwardButton: UIBarButtonItem!
    var selectedSite: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let siteToLoad = selectedSite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
            
            
            let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
            forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
            backwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
            
            
            forwardButton.isEnabled = webView.canGoForward
            backwardButton.isEnabled = webView.canGoBack
            
            progressView = UIProgressView(progressViewStyle: .default)
            progressView.sizeToFit()
            let progressButton = UIBarButtonItem(customView: progressView)
            
            toolbarItems = [backwardButton, forwardButton, progressButton, spacer, refresh]
            navigationController?.isToolbarHidden = false
            
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            
            
            
            let url = URL(string: "https://\(siteToLoad)")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for webSite in webSites {
            ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
            
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://\(actionTitle)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        backwardButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for webSite in webSites {
                if host.contains(webSite) {
                    decisionHandler(.allow)
                    return
                }
            }
            if !webSites.contains(host) {
                let ac = UIAlertController(title: "Not Allowed", message: "You are not allowed to open this page.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Close", style: .cancel)
                
                ac.addAction(action)
                present(ac, animated: true)
            }
        }
        
        decisionHandler(.cancel)
    }
}

