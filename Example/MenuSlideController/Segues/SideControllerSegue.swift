//
//  SideControllerSegue.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 6/27/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

open class SideControllerSegue: UIStoryboardSegue {
    
    override open func perform() {
        if let sideController = self.source as? MenuSlideController {
            sideController.add(leftViewController: destination)
        } else {
            fatalError("This type of segue must only be used from a SideMenuController")
        }
    }

}
