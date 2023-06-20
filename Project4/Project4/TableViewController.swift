//
//  TableViewController.swift
//  EasyBrowser
//
//  Created by Ozan Mudul on 7.12.2022.
//

import UIKit

class TableViewController: UITableViewController {
    var webSites = ["apple.com", "google.com", "wikipedia.org"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("sa")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)

        cell.textLabel?.text = webSites[indexPath.row]
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            vc.selectedSite = webSites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
