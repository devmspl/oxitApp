//
//  CommonMethods.swift
//  MyWaterController
//
//  Created by Uday Patel on 28/09/21.
//

import UIKit

///
class CommonMethods: NSObject {
    // MARK: Validation Methods
    /// Validate email string.
    ///
    /// - Parameter email: email.
    /// - Returns: (true/false).
    class func validate(email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegEx = #"^\S+@\S+\.\S+$"# // "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}" // "^(.+)@(.+)$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: email) { return false }
        return true
    }

    // MARK: - Navigation Methods
    /**
     This methods manage the navigation.
     
     - parameter destinationVC:        destination view controller
     - parameter navigationController: navigation controller object
     - parameter animated:             Animation (true/false)
     */
    class func navigateTo(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController, animated: Bool ) {
        
        var VCFound: Bool = false
        let viewControllers: NSArray = navigationController.viewControllers as NSArray
        var indexofVC: NSInteger = 0
        for vc in navigationController.viewControllers {
            if vc.nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        
        DispatchQueue.main.async(execute: {
            if VCFound == true, let controller = viewControllers.object(at: indexofVC) as? UIViewController {
                navigationController.popToViewController(controller, animated: animated)
            } else {
                navigationController.pushViewController(destinationVC, animated: animated)
            }
        })
    }
    
    /**
     This methods is used to get reference of already present viewcontroller object.
     
     - parameter destinationVC:        destination view controller
     - parameter navigationController: navigation controller object
     
     - returns: Object of destination view controller
     */
    class func findViewControllerRefInStack(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController) -> UIViewController {
        var VCFound = false
        let viewControllers = navigationController.viewControllers
        var indexofVC = 0
        for vc: UIViewController in viewControllers {
            if vc.nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        if VCFound == true {
            return viewControllers[indexofVC]
        } else {
            return destinationVC
        }
    }
    
    // MARK: - Color Methods
    ///
    static func colorWithHexString(_ hex: NSString ) -> UIColor {
        let rgbValue = 0xFFEEDD
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat((rgbValue & 0xFF))/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // MARK: - User Default Methods
    ///
    static func writeData(data: Data, forKey: String) {
        UserDefaults.standard.set(data, forKey: forKey)
    }
    
    ///
    static func readData(forKey: String) -> Data? {
        if let data = UserDefaults.standard.value(forKey: forKey) as? Data {
            return data
        }
        return Data()
    }

    ///
    static func removeData(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
    
    // MARK: - HUD Methods
    ///
    static var activityIndicator: ActivityLoader = ActivityLoader()
    /// Show Progress HUD.
    static func showProgressHud(inView view: UIView) {
        DispatchQueue.main.async {
            view.endEditing(true)
            self.activityIndicator.showActivityIndicator(uiView: view)
        }
    }
    
    /// Hide Progress HUD.
    static func hideProgressHud() {
        DispatchQueue.main.async {
            activityIndicator.hideActivityIndicator()
        }
    }
    
    static func convertSecondToTimeZoneString(seconds: Int) -> String {
        let hour = String(format: "%02d", Int(abs(seconds) / 3600))
        let min = String(format: "%02d", Int(abs(seconds) % 3600)/60)
        let appendSign = seconds > 0 ? "+" : "-"
        let timeZoneOffset = appendSign + hour + min
        return timeZoneOffset
    }
    
    ///
    static func getAttributed(text1: String, text2: String, fontSize1: CGFloat = 14.0, fontSize2: CGFloat = 18.0) -> NSMutableAttributedString {
        let value1Attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize1)]
        let value1String = NSMutableAttributedString(string: "\(text1)", attributes: value1Attribute)
        
        let value2Attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize2)]
        let value2String = NSMutableAttributedString(string: "\(text2)", attributes: value2Attribute)
        
        let combination = NSMutableAttributedString()
        combination.append(value1String)
        combination.append(value2String)
        return combination
    }
}
