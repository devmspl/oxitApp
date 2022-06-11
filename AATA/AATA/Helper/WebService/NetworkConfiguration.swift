//
//  NetworkConfiguration.swift
//  NPI
//
//  Created by Uday Patel on 01/07/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit

/// Enum DevelopmentEnvironment
///
/// - staging: staging
/// - development: development
/// - local: local
/*
 enum DevelopmentEnvironment: String {
 ///
 case production = "Production"
 ///
 case staging = "Staging"
 ///
 case development = "Development"
 ///
 case QA = "QA"
 }
 */


/// Network configuration.
class NetworkConfiguration: NSObject {
    
    // MARK: - Variables
    ///
    var stormGlassHostURL: String = ""
    ///
    var stormGlassAPIKey: String = ""
    ///
    var hostURL: String = ""
    ///
    var serverURL: String = ""
    ///
    var accessTokenURL: String = ""
    /// This value will be set from splash controller from PLIST.
    var clientId = 0 // watercop: 291, NPS: 2
    
    // MARK: - Init
    /// Initializers
    fileprivate override init() {
        super.init()
        /*self.buildEnvironment = .development*/
        initializeHostEndPoints()
    }
    
    /// for NetworkConfiguration
    class var shared: NetworkConfiguration {
        ///
        struct Static {
            ///
            static var instance: NetworkConfiguration?
            ///
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = NetworkConfiguration()
        }
        return Static.instance ?? NetworkConfiguration() // change
    }
    
    /// buildEnvironment setUp
    /*
     var buildEnvironment: DevelopmentEnvironment {
     didSet {
     /*
     "https://r9tpvncq83.execute-api.us-east-1.amazonaws.com/stage/"
     */
     DispatchQueue(label: "AWS-User-Details", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none).sync {
     self.configureAWSUserDetail()
     }
     /*
     if buildEnvironment == .production {
     fatalError("Not Configured yet!!")
     } else if buildEnvironment == .staging {
     hostURL = "https://api.oxtech.com/"
     } else if buildEnvironment == .development {
     hostURL = "https://api-dev.oxtech.com/"
     }
     */
     serverURL = hostURL
     }
     }
     */
    
    func initializeHostEndPoints() {
        /*
         "https://r9tpvncq83.execute-api.us-east-1.amazonaws.com/stage/"
         */
        DispatchQueue(label: "AWS-User-Details", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .none).sync {
            self.configureAWSUserDetail()
        }
    }
    
    ///
    func configureAWSUserDetail() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "awsconfiguration", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                guard let configurationDictionary = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [String: Any] else { return }
                guard let customConfiguration = configurationDictionary["CustomConfiguration"] as? [String: Any] else { return }
                if let stormGlassHostURL = customConfiguration["stormGlassHostURL"] as? String {
                    self.stormGlassHostURL = stormGlassHostURL
                }
                if let stormGlassAPIKey = customConfiguration["stormGlassAPIKey"] as? String {
                    self.stormGlassAPIKey = stormGlassAPIKey
                    // "5636a9de-4260-11ec-bf98-0242ac130002-5636aa74-4260-11ec-bf98-0242ac130002"
                    // stormGlassAPIKey
                }
                if let clientIndetifier = customConfiguration["ClientId"] as? Int {
                    self.clientId = clientIndetifier
                }
                if let hostURL = customConfiguration["hostURL"] as? String {
                    self.hostURL = hostURL
                    serverURL = self.hostURL
                }
            }
        } catch {
            print("Fail to read JSON file.")
        }
    }
}

/* Policy Name:
 Dev: MobileIoTListenerPolicydev
 QA: MobileIoTListenerPolicyqa
 Prod: MobileIoTListenerPolicystage
 */
