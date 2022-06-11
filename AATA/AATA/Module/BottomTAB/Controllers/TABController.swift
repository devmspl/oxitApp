//
//  TABController.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

///
let tabItemColor: UIColor = UIColor(named: "clr_light_bg") ?? UIColor.init(red: 137.0/255.0, green: 190.0/255.0, blue: 163.0/255.0, alpha: 1)
// rgba(137, 190, 163, 1)


///
class TABController: UITabBarController {
    // MARK: - Variables
    ///
    @IBInspectable var indicatorColor: UIColor = UIColor()
    ///
    @IBInspectable var onTopIndicator: Bool = true
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
//        object_setClass(self.tabBar, WeiTabBar.self)
        self.tabBar.backgroundColor = .white
    }
    
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = self.viewControllers?.filter({ vc in
            if SharedDataManager.shared.userGroupName != UserGroupName.mobileUser.rawValue {
                return true
            }
            if let rId = vc.restorationIdentifier, rId == "SettingNVC" {
                return false
            }
            return true
        })
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    ///
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Draw Indicator above the tab bar items
        guard let numberOfTabs = tabBar.items?.count else { return }
        let numberOfTabsFloat = CGFloat(numberOfTabs)
        let imageSize = CGSize(width: tabBar.frame.width / numberOfTabsFloat, height: tabBar.frame.height)
        let indicatorImage = UIImage.drawTabBarIndicator(color: indicatorColor, size: imageSize, onTop: onTopIndicator)
        self.tabBar.selectionIndicatorImage = indicatorImage
        self.tabBar.tintColor = tabItemColor
    }
}

extension TABController: UITabBarControllerDelegate {
    ///
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let viewControllers = tabBarController.viewControllers ?? []
        for controller in viewControllers {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

/////
//class WeiTabBar: UITabBar {
//    ///
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = UIDevice.current.hasNotch ? 100 : 60 // self.frame.size.height
//        return sizeThatFits
//    }
//}

extension UIImage {
    ///
    class func drawTabBarIndicator(color: UIColor, size: CGSize, onTop: Bool) -> UIImage {
        let indicatorHeight = size.height / 30
        let yPosition = onTop ? 0 : (size.height - indicatorHeight)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // color.setFill()
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(tabItemColor.cgColor)
            // ctx.setStrokeColor(UIColor.green.cgColor)
            // ctx.setLineWidth(10)
        }
        UIRectFill(CGRect(x: 0, y: yPosition, width: size.width, height: indicatorHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
