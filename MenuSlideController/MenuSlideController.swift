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
    case panelExpanded
}

enum SliderPosition {
    case leftSlider
    case rightSlider
}

open class MenuSlideController: UIViewController {
    var centerNavigationController: UINavigationController!
    var centerViewController: UIViewController!
    var leftViewController: UIViewController?
    let sidepanelWidth: CGFloat = 180
    var sliderPosition: SliderPosition = .leftSlider
    
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
        if currentState == .panelExpanded {
            toggleLeft()
        } else if currentState == .panelExpanded{
            toggleRight()
        }
    }
    
    private func configureGestureRecognizer() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(manageCentralPanelPan(_:)))
//        panGesture.delegate = self
        
        let leftPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(manageCentralPanelPan(_:)))
        leftPan.delegate = self
        leftPan.edges = .left
        
        let rightPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(manageCentralPanelPan(_:)))
        rightPan.delegate = self
        rightPan.edges = .right
        
        centerNavigationController.view.addGestureRecognizer(leftPan)
        centerNavigationController.view.addGestureRecognizer(rightPan)
//        centerNavigationController.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func manageCentralPanelPan(_ recognizer: UIPanGestureRecognizer) {
        let velocityX = recognizer.velocity(in: recognizer.view).x
        let fromLeftToRight = velocityX > 0

        switch recognizer.state {
        case .began:
            showShadowForCenterViewController(true)
        case .changed:
            let translationX = recognizer.translation(in: view).x
            var frame = centerNavigationController.view.frame
            
            switch sliderPosition {
            case .leftSlider:
                frame.origin.x += translationX
                if frame.minX < 0 {return}
            case .rightSlider:
                frame.origin.x += translationX
                if frame.maxX > frame.width {return}
            }

            centerNavigationController.view.frame = frame
            recognizer.setTranslation(.zero, in: view)
            
        default:
            var openDrawer = false
            let centralVCFrame = centerNavigationController.view.frame
            
            let openDrawerFactor = CGFloat(0.2)
            let hideDrawerFactor = CGFloat(0.8)
            
            switch sliderPosition {
            case .leftSlider:
                if fromLeftToRight {
                    // open drawer
                    openDrawer = centralVCFrame.minX > sidepanelWidth * openDrawerFactor
                } else {
                    // close drawer
                    openDrawer = centralVCFrame.minX > sidepanelWidth * hideDrawerFactor
                }
            case .rightSlider:
                if fromLeftToRight {
                    // close drawer
                    openDrawer = centralVCFrame.width - centralVCFrame.maxX > sidepanelWidth * hideDrawerFactor
                    
                } else {
                    // open drawer
                    openDrawer = centralVCFrame.width - centralVCFrame.maxX > sidepanelWidth * openDrawerFactor
                }
                
            }
            
            animateToOpenDrawer(openDrawer)
        }
    }
    
    private func animateToOpenDrawer(_ openDrawer:Bool) {
        
        switch sliderPosition {
        case .leftSlider:
            if openDrawer {
                currentState = .panelExpanded
                animateLeftPanel(widthOfSidePanel: sidepanelWidth)
            } else {
                currentState = .bothPanelCollapsed
                animateLeftPanel(widthOfSidePanel: 0)
            }

        case .rightSlider:
            if openDrawer {
                currentState = .panelExpanded
                animateRightPanel(widthOfSidePanel: sidepanelWidth)
            } else {
                currentState = .bothPanelCollapsed
                animateRightPanel(widthOfSidePanel: 0)
            }
            
        }

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
        currentState == .panelExpanded ? animateLeftPanel(widthOfSidePanel: 0) : animateLeftPanel(widthOfSidePanel: sidepanelWidth)
        currentState = self.currentState == .panelExpanded ? .bothPanelCollapsed : .panelExpanded
    }
    
    func animateLeftPanel(widthOfSidePanel: CGFloat) {
        animateCenterPanelXPosition(targetPosition: widthOfSidePanel) { (success) in

        }
    }
    
    func toggleRight() {
        currentState == .panelExpanded ? animateRightPanel(widthOfSidePanel: 0) : animateRightPanel(widthOfSidePanel: sidepanelWidth)
        currentState = self.currentState == .panelExpanded ? .bothPanelCollapsed : .panelExpanded
    }
    
    func animateRightPanel(widthOfSidePanel: CGFloat) {
        animateCenterPanelXPosition(targetPosition: -widthOfSidePanel) { (success) in

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

extension MenuSlideController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
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

