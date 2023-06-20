//
//  ViewController.swift
//  FlagViewer
//
//  Created by Ozan Mudul on 1.12.2022.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.resourcePath!
        let fm = FileManager.default
        print(path)
        let arr = try! fm.contentsOfDirectory(atPath: path)
       

        for item in arr {
            if(item.hasSuffix("png")) {
                flags.append(item)
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = ""
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.layer.borderWidth = 1
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

