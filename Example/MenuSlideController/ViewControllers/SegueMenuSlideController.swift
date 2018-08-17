//
//  SegueMenuSlideController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 8/17/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit
import MenuSlideControllerSource

class SegueMenuSlideController: MenuSlideController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "showSideController", sender: nil)
        performSegue(withIdentifier: "showDetailController1", sender: nil)
    }

}
