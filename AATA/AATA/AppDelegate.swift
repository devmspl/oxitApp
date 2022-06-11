//
//  AppDelegate.swift
//  AATA
//
//  Created by Uday Patel on 17/09/21.
//

import UIKit
// import AmazonFreeRTOS
import AWSMobileClient
import IQKeyboardManagerSwift
import Sentry

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    ///
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupNetworkManager()
        setupIQKeyboardManager()
        verifyFont()
        //// FreeRTOS SDK Logging, will switch to AWSDDLog in future releases
        // AmazonFreeRTOSManager.shared.isDebug = true
        //// AWS SDK Logging
        // AWSDDLog.sharedInstance.logLevel = .all
        // AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        
        // Setup the user sign-in with cognito: https://aws-amplify.github.io/docs/ios/authentication#manual-setup
        AWSServiceManager.default().defaultServiceConfiguration = AWSServiceConfiguration(region: AmazonConstants.AWS.region, credentialsProvider: AWSMobileClient.default())
        
        SentrySDK.start { options in
            options.dsn = "https://a607189464b4466eaa4a48e1c3b7b472@o1193894.ingest.sentry.io/6316242"
            options.debug = true // Enabled debug when first installing is always helpful

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// This function initialize Network manager.
    func setupNetworkManager() {
        _ = NetworkManager.sharedInstance // do not remove this line
        _ = NetworkConfiguration.shared
    }
    
    /// Setting up IQKeyboard
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIStackView.self, UIView.self]
    }
    
    ///
    func verifyFont() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(name)")
            }
        }
    }
}

struct AmazonConstants {
    struct AWS {
        static let region = AWSRegionType.USEast1
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

/**
 Prod Environment
 User Pool ID: us-east-1_j9yitXBaR
 App Client ID: 146030bpmuorch0tr99gcg1g9u
 App Client Secret: 1ttdvgooma345g5jknqrmdvnbt0stkt16km7ad41p2deie19mfvu
 QA Environment
 User Pool ID: us-east-1_h60QcqbJD
 App Client ID: 6fluc2uh9k74e73fr6vs15c5c9
 App Client Secret: t67bses1oe2bfcjd09pkcvivu7mqh9cku9omr0r8irivhhtb579
 Dev Environment
 User Pool ID: us-east-1_IlDeKGxyq
 App Client ID: 7a8pedop4obr0kgejc297le7dl
 App Client Secret: 6l9jedpvitadhf8d06ij7kel6eiqsioaemav81m6jseseui4fq
 :+1:
 1


 */
