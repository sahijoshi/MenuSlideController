//
//  MenuSlideController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 3/30/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit


enum SlideOutState {
    case bothPanelCollapsed
    case leftPanelCollapsed
    case rightPanelCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
    case topPenelExpanded
}

open class MenuSlideController: UIViewController {
    var centerNavigationController: UINavigationController!
    var centerViewController: UIViewController!
    var leftViewController: UIViewController?
    let sidepanelWidth: CGFloat = 180

    var currentState: SlideOutState = .bothPanelCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothPanelCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reArranageViews), name: .UIApplicationWillChangeStatusBarFrame, object: UIApplication.shared)
        configureGestureRecognizer()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func reArranageViews() {
        if currentState == .leftPanelExpanded {
//            toggleLeftPanel()
        }
    }
    
    private func configureGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(manageCentralPanelPan(_:)))
//        panGesture.delegate = self
        
        centerNavigationController.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func manageCentralPanelPan(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: recognizer.view).x
        let fromLeftToRight = velocity > 0
        
        
        switch recognizer.state {
        case .began:
            print("began")

        case .changed:
            let translation = recognizer.translation(in: view).x
            
            var frame = centerNavigationController.view.frame
            frame.origin.x += translation
            centerNavigationController.view.frame = frame
            recognizer.setTranslation(.zero, in: view)
        default:
            print("default")
            var openDrawer = false
            let centralVCFrame = centerNavigationController.view.frame
            
            let openDrawerFactor = CGFloat(0.2)
            let hideDrawerFactor = CGFloat(0.8)

            if fromLeftToRight {
                // close drawer
                openDrawer = centralVCFrame.minX > sidepanelWidth * openDrawerFactor
            } else {
                // opne drawer
                openDrawer = centralVCFrame.minX > sidepanelWidth * hideDrawerFactor
            }
            
            animateToOpenDrawer(openDrawer)
        }
    }
    
    private func animateToOpenDrawer(_ openDrawer:Bool) {
        openDrawer ? animateLeftPanel(widthOfSidePanel: sidepanelWidth) : animateLeftPanel(widthOfSidePanel: 0)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }

    func add(centerViewController controller: UIViewController){
        if centerNavigationController != nil {
            centerNavigationController.willMove(toParentViewController: nil)
            centerNavigationController.view.removeFromSuperview()
            centerNavigationController = nil
        }
        
        if let centerController  = controller as? UINavigationController{
            centerNavigationController = centerController
            view.addSubview(centerNavigationController.view)
            addChildViewController(centerNavigationController)
            centerNavigationController.didMove(toParentViewController: self)
        }
    }
    
    func add(leftViewController controller: UIViewController) {
        add(sidePanelChildViewController: controller)
    }
    
    func add(sidePanelChildViewController controller: UIViewController) {
        view.insertSubview(controller.view, at: 0)
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    func toggleLeft() {
        currentState == .leftPanelExpanded ? animateLeftPanel(widthOfSidePanel: 0) : animateLeftPanel(widthOfSidePanel: sidepanelWidth)
    }
    
    func animateLeftPanel(widthOfSidePanel: CGFloat) {
        animateCenterPanelXPosition(targetPosition: widthOfSidePanel) { (success) in
            self.currentState = self.currentState == .leftPanelExpanded ? .leftPanelCollapsed : .leftPanelExpanded
        }
    }
    
    func toggleRight() {
        currentState == .rightPanelExpanded ? animateRightPanel(widthOfSidePanel: 0) : animateRightPanel(widthOfSidePanel: sidepanelWidth)
    }
    
    func animateRightPanel(widthOfSidePanel: CGFloat) {
        animateCenterPanelXPosition(targetPosition: -widthOfSidePanel) { (success) in
            self.currentState = self.currentState == .rightPanelExpanded ? .rightPanelCollapsed : .rightPanelExpanded
        }
    }

    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }) { (success) in
            completion(success)
        }
    }
}

public extension UIViewController {
    
    public var slideMenuController: MenuSlideController? {
        return slideMenuControllerForViewController(self)
    }
    
    fileprivate func slideMenuControllerForViewController(_ controller : UIViewController) -> MenuSlideController? {
        if let sideController = controller as? MenuSlideController {
            return sideController
        }
        
        if let parent = controller.parent {
            return slideMenuControllerForViewController(parent)
        } else {
            return nil
        }
    }
}

