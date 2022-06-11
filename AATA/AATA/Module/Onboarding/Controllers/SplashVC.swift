//
//  SplashVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit
import AWSMobileClient
import SideMenuSwift

///
class SplashVC: UIViewController {
    // MARK: - Varibales
    ///
    var timer: Timer?
    ///
    var isExecuteForcedLoggedOut: Bool = false
    ///
    let viewModel = SplashViewModal()
    
    // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // APIServices.shared.loggedOutUserSession { (_) in
        // self.navigateToTABDasboard()
        // }
        showLogin()
        guard let navigationController = self.navigationController else { return }
        Constants.navigationController = navigationController
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Methods
    ///
    func setTimerToAvoidSplashFreeze() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] timer in
            self?.isExecuteForcedLoggedOut = true
            APIServices.shared.loggedOutUserSession { (_) in }
            self?.navigateToSignIn()
        }
    }
    
    ///
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    ///
    func showLogin() {
        setTimerToAvoidSplashFreeze()
        AWSMobileClient.default().initialize { [weak self] userState, error in
            self?.invalidateTimer()
            guard let isExecuteForcedLoggedOut = self?.isExecuteForcedLoggedOut, !isExecuteForcedLoggedOut else { return }
            
            // initialize error
            if let error = error {
                print(error.localizedDescription)
                self?.navigateToSignIn()
                return
            }
            
            // process userState
            guard let userState = userState else {
                self?.navigateToSignIn()
                return
            }
            
            switch userState {
            case .signedIn:
                self?.setTimerToAvoidSplashFreeze()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    AWSMobileClient.default().getTokens { (tokens, error) in
                        self?.invalidateTimer()
                        guard let isExecuteForcedLoggedOut = self?.isExecuteForcedLoggedOut, !isExecuteForcedLoggedOut else { return }
                        guard error == nil else {
                            self?.navigateToSignIn()
                            return
                        }
                        SharedDataManager.shared.idToken = tokens?.idToken?.tokenString ?? ""
                        self?.getPropertyAPI()
                    }
                }
            case .signedOut:
                self?.navigateToSignIn()
            default:
                APIServices.shared.loggedOutUserSession { (_) in }
                self?.navigateToSignIn()
            }
        }
    }
    
    ///
    func getPropertyAPI() {
        viewModel.getPropertyAPI { [weak self] (response, isSuccess) in
            CommonMethods.hideProgressHud()
            if response.count == 0 && isSuccess {
                DispatchQueue.main.async {
                    CommonPopup.shared.setupPopup(title: R.string.localizable.error(), message: R.string.localizable.noPropertyFoundIfTheProblemPersistsPleaseContactYourSystemAdministrator(), defaultButtonTitle: R.string.localizable.okaY(), destroyButtonTitle: "") { _ in
                        self?.navigateToSignIn(0.0)
                    }
                }
            } else if response.count == 1, let property = response.first {
                Constants.selectedProperty = property
                self?.navigateToTABDasboard()
            } else if response.count > 1 {
                guard let id = UserDefaults.standard.value(forKey: "propertyID") as? Int else {
                    self?.navigateToPropertyList()
                    return
                }
                let selectedProperty = response.first { $0.id == id }
                if let selProp = selectedProperty {
                    Constants.selectedProperty = selProp
                    self?.navigateToTABDasboard()
                } else {
                   self?.navigateToPropertyList()
                }
            } else {
                self?.navigateToSignIn(0.0)
                APIServices.shared.loggedOutUserSession { _ in }
            }
        }
    }
    
    ///
    func navigateToSignIn(_ navigateAfterInterval: Double = 5.0) {
        APIServices.shared.loggedOutUserSession { (_) in }
        DispatchQueue.main.asyncAfter(deadline: .now() + navigateAfterInterval) {
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.onboarding.landingVC() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    ///
    func navigateToPropertyList(_ navigateAfterInterval: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + navigateAfterInterval) {
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.bottomTAB.propertyVC() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
    
    ///
    func navigateToTABDasboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
    
            guard let menuViewController = R.storyboard.onboarding.sideMenuVC() else { return }
            guard let contentViewController = R.storyboard.bottomTAB.tabController() else { return }
            let sideVC =  SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
            self.navigationController?.setViewControllers([sideVC], animated: false)
        }
    }
}
//
//extension String {
//         public enum DateFormatType {
//        
//        /// The ISO8601 formatted year "yyyy" i.e. 1997
//        case isoYear
//        
//        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
//        case isoYearMonth
//        
//        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
//        case isoDate
//        
//        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
//        case isoDateTime
//        
//        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
//        case isoDateTimeSec
//        
//        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
//        case isoDateTimeMilliSec
//        
//        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
//        case dotNet
//        
//        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
//        case rss
//        
//        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
//        case altRSS
//        
//        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
//        case httpHeader
//        
//        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
//        case standard
//        
//        /// A custom date format string
//        case custom(String)
//        
//        /// The local formatted date and time "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 19:20:00
//        case localDateTimeSec
//        
//        /// The local formatted date  "yyyy-MM-dd" i.e. 1997-07-16
//        case localDate
//        
//        /// The local formatted  time "hh:mm a" i.e. 07:20 am
//        case localTimeWithNoon
//        
//        /// The local formatted date and time "yyyyMMddHHmmss" i.e. 19970716192000
//        case localPhotoSave
//        
//        case birthDateFormatOne
//        
//        case birthDateFormatTwo
//        
//        ///
//        case messageRTetriveFormat
//        
//        ///
//        case emailTimePreview
//        
//        var stringFormat:String {
//          switch self {
//          //handle iso Time
//          case .birthDateFormatOne: return "dd/MM/YYYY"
//          case .birthDateFormatTwo: return "dd-MM-YYYY"
//          case .isoYear: return "yyyy"
//          case .isoYearMonth: return "yyyy-MM"
//          case .isoDate: return "yyyy-MM-dd"
//          case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
//          case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
//          case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//          case .dotNet: return "/Date(%d%f)/"
//          case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
//          case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
//          case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
//          case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
//          case .custom(let customFormat): return customFormat
//            
//          //handle local Time
//          case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
//          case .localTimeWithNoon: return "hh:mm a"
//          case .localDate: return "yyyy-MM-dd"
//          case .localPhotoSave: return "yyyyMMddHHmmss"
//          case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//          case .emailTimePreview: return "dd MMM yyyy, h:mm a"
//          }
//        }
// }
//        
// func toDate(_ format: DateFormatType = .isoDate) -> Date?{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format.stringFormat
//        let date = dateFormatter.date(from: self)
//        return date
//  }
// }
