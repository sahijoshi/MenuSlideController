# MenuSlideController

[![Platform](https://img.shields.io/cocoapods/p/SideMenuController.svg?style=flat)](http://cocoapods.org/pods/SideMenuController)
[![Version](https://img.shields.io/cocoapods/v/SideMenuController.svg?style=flat)](http://cocoapods.org/pods/SideMenuController)
[![License](https://img.shields.io/cocoapods/l/SideMenuController.svg?style=flat)](http://cocoapods.org/pods/SideMenuController)

MenuSlideController is a highly customizable and simple container view controller which manages child view controllers in a single master-detail interface. The master panel can be displayed on left or either right side of the detail panel, which can be slide in or out by tapping a button or using swipe gesture. The library is designed to support storyboard.

# Preview


# Installation
---------------
### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install with following command.
```bash
$ gem install cocoapods
```

##### Podfile
```bash
$ pod 'MenuSlideController'
```
# Requirements
-------------
- Supported build target - iOS 11+
- Xcode 9 or later

# Usage
------------
### Using Storyboards
Use by subclassing MenuSlideController and add the following code to add master and detail view conroller.

```bash
class SegueMenuSlideController: MenuSlideController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "showSideController", sender: nil)
        performSegue(withIdentifier: "showDetailController1", sender: nil)
    }

}
```

### Programmaticallly
```bash
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        let centerVC = storyboard.instantiateViewController(withIdentifier: "CenterNavVC")
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuController")
        
        let menuSliderVC = MenuSlideController()
        menuSliderVC.add(centerViewController: centerVC)
        menuSliderVC.add(sideViewController: menuVC)
        
        MenuSlideController.settings.sliderPosition = .leftSlider
        MenuSlideController.settings.sidepanelWidth = 180

        window?.rootViewController = menuSliderVC
        window?.makeKeyAndVisible()

        return true
    }

```

