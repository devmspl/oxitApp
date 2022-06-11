//
//  SharedDataManager.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

import Foundation

/// Data manager to save data into user default.
class SharedDataManager {
    /// DataManager shared instance.
    static let shared = SharedDataManager()
    
    ///
    let userDefault = UserDefaults.standard
    
    ///
    var idToken: String {
        get {
            guard let idToken = userDefault.string(forKey: "idToken") else {
                return ""
            }
            return idToken
        }
        set {
            userDefault.set(newValue, forKey: "idToken")
        }
    }
    
    ///
    var isLoggedIn: Bool {
        get {
            guard let isLoggedIn = userDefault.value(forKey: "isLoggedIn") as? Bool else {
                return false
            }
            return isLoggedIn
        }
        set {
            userDefault.set(newValue, forKey: "isLoggedIn")
        }
    }
    
    ///
    var userGroupName: String {
        get {
            guard let groupName = userDefault.string(forKey: "userGroupName") else {
                return ""
            }
            return groupName
        }
        set {
            userDefault.set(newValue, forKey: "userGroupName")
        }
    }
}
