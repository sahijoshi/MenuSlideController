//
//  CenterViewController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 4/9/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toggleLeft(_ sender: Any) {
        slideMenuController?.toggleLeft()
    }
    
    @IBAction func toggleRight(_ sender: Any) {
        slideMenuController?.toggleRight()
    }

}
