//
//  BaseViewController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 8/21/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.addTarget(self, action: #selector(toggleSlider(sender:)), for: .touchUpInside)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnMenu.setImage(UIImage(named: "menu"), for: .normal)
        
        let barMenuItem = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = barMenuItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @objc func toggleSlider(sender: Any) {
        slideMenuController?.toggleLeft()
    }
}
