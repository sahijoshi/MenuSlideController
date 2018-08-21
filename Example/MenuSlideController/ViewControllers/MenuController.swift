//
//  MenuController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 7/10/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    let segues = ["showDetailController1", "showDetailController2", "showDetailController3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.init(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        cell.textLabel?.text = "Controller \(indexPath.row + 1)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
    }
    
}
