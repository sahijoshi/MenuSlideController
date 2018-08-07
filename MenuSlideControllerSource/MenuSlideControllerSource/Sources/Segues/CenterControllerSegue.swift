//
//  CenterControllerSegue.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 6/27/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

open class CenterControllerSegue: UIStoryboardSegue {

    override open func perform() {
        if let sideMenuController = self.source as? MenuSlideController {
            guard let destinationController = destination as? UINavigationController
                else {
                    fatalError("Destination controller needs to be instance of UINavigationController")
            }
            sideMenuController.add(centerViewController: destinationController)
        }
    }

}
